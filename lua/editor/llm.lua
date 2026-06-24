-- ============================================================================
-- 🦙  llm.lua — funky local-LLM integration
-- ============================================================================
-- Pipes the current buffer (or visual selection) through `ai-query`, the
-- trust-boundary wrapper around the local llama.cpp server (Qwen3-8B @ :11500).
-- `ai-query` treats piped content as *untrusted DATA* (safe-extract mode), so
-- prompt-injection in the buffer can't hijack the instruction. The response
-- lands in a floating markdown scratch buffer (render-markdown prettifies it).
--
-- Keymaps (under the existing <leader>ai "AI" group):
--   <leader>aiq   ask the local LLM about the buffer / selection (prompts task)
--   <leader>aiE   explain the buffer / selection
--   <leader>air   review the buffer / selection for bugs & smells
-- ============================================================================

local M = {}

local AIQ = "ai-query"
local SPINNER = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

-- Snacks notifier if present (gives us replaceable, animated toasts), else
-- fall back to plain vim.notify.
local function notify(msg, level, opts)
  opts = opts or {}
  opts.title = opts.title or "🦙 ai-query"
  local ok, snacks = pcall(require, "snacks")
  if ok and snacks.notifier then
    opts.level = level
    return snacks.notify(msg, opts)
  end
  vim.notify(msg, level, opts)
  return opts.id
end

-- Gather DATA: visual range when given, otherwise the whole buffer.
local function collect(line1, line2)
  if line1 and line2 and line1 > 0 and line2 >= line1 then
    return table.concat(vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false), "\n")
  end
  return table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
end

-- Floating markdown scratch buffer for the response.
local function float(title, body)
  local lines = vim.split(body, "\n", { plain = true })
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local width = math.min(100, math.floor(vim.o.columns * 0.8))
  local height = math.min(#lines + 1, math.floor(vim.o.lines * 0.8))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = math.max(height, 3),
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " " .. title .. " ",
    title_pos = "center",
  })
  vim.wo[win].wrap = true
  vim.wo[win].conceallevel = 2
  for _, key in ipairs { "q", "<Esc>" } do
    vim.keymap.set("n", key, "<cmd>close<cr>", { buffer = buf, nowait = true, silent = true })
  end
end

-- Run ai-query async with DATA on stdin and TASK as argv.
local function query(task, mode, line1, line2)
  if vim.fn.executable(AIQ) == 0 then
    notify("`ai-query` not on PATH — is the zsh bin dir loaded?", vim.log.levels.ERROR)
    return
  end

  local data = collect(line1, line2)
  if data:gsub("%s", "") == "" then
    notify("Nothing to send (empty buffer/selection).", vim.log.levels.WARN)
    return
  end

  local nid =
    notify(SPINNER[1] .. "  thinking… (" .. mode .. ")", vim.log.levels.INFO, { timeout = false })

  -- Animate the spinner until the job returns.
  local frame, done = 1, false
  local timer = vim.uv.new_timer()
  timer:start(
    0,
    90,
    vim.schedule_wrap(function()
      if done then
        return
      end
      frame = (frame % #SPINNER) + 1
      notify(
        SPINNER[frame] .. "  thinking… (" .. mode .. ")",
        vim.log.levels.INFO,
        { id = nid, timeout = false }
      )
    end)
  )

  local function finish()
    done = true
    if timer and not timer:is_closing() then
      timer:stop()
      timer:close()
    end
  end

  vim.system(
    { AIQ, "--mode", mode, task },
    { stdin = data, text = true },
    vim.schedule_wrap(function(res)
      finish()
      if res.code ~= 0 then
        notify(
          "ai-query failed (exit " .. res.code .. "):\n" .. (res.stderr or ""),
          vim.log.levels.ERROR,
          { id = nid }
        )
        return
      end
      notify("✓ done", vim.log.levels.INFO, { id = nid, timeout = 1500 })
      local out = (res.stdout or ""):gsub("%s+$", "")
      if out == "" then
        out = "_(model returned no content)_"
      end
      float("🦙 " .. task, out)
    end)
  )
end

-- range=true commands pass line1/line2 even with no selection (whole-buffer
-- default), so detect a "real" selection by comparing to the buffer extent.
local function range_or_nil(opts)
  if opts.range and opts.range > 0 then
    return opts.line1, opts.line2
  end
  return nil, nil
end

function M.setup()
  local function map(lhs, task_or_prompt, mode, desc)
    vim.keymap.set({ "n", "v" }, lhs, function()
      -- Capture the most recent visual selection range, if any.
      local mode_char = vim.fn.mode()
      local l1, l2
      if mode_char:match "[vV\22]" then
        l1, l2 = vim.fn.line "v", vim.fn.line "."
        if l1 > l2 then
          l1, l2 = l2, l1
        end
        vim.cmd "normal! \27" -- leave visual mode so marks settle
      end
      if task_or_prompt == nil then
        vim.ui.input({ prompt = "🦙 ai-query task: " }, function(input)
          if input and input ~= "" then
            query(input, mode, l1, l2)
          end
        end)
      else
        query(task_or_prompt, mode, l1, l2)
      end
    end, { desc = desc })
  end

  map("<leader>aiq", nil, "safe-extract", "Ask local LLM (buffer/selection)")
  map(
    "<leader>aiE",
    "Explain what this code does, concisely.",
    "safe-extract",
    "Explain via local LLM"
  )
  map(
    "<leader>air",
    "Review this code for bugs, edge cases, and smells. Be terse.",
    "safe-extract",
    "Review via local LLM"
  )

  -- :Llm {task}  — works with a range, e.g. :'<,'>Llm refactor this
  vim.api.nvim_create_user_command("Llm", function(opts)
    local l1, l2 = range_or_nil(opts)
    local task = opts.args ~= "" and opts.args or nil
    if task then
      query(task, "safe-extract", l1, l2)
    else
      vim.ui.input({ prompt = "🦙 ai-query task: " }, function(input)
        if input and input ~= "" then
          query(input, "safe-extract", l1, l2)
        end
      end)
    end
  end, { nargs = "*", range = true, desc = "Send buffer/range to local llama.cpp via ai-query" })
end

return M
