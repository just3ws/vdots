-- editor/errors.lua — all-errors log with diagnostic context
-- Wraps vim.notify to capture ERROR/WARN to stdpath("state")/errors.jsonl.
-- Each entry includes the active buffer's filetype, LSP clients, and
-- diagnostics so omnifunc/LSP errors carry enough context to analyse.
-- :NvimErrors   opens the log in a scratch buffer (most-recent first)

local M = {}

local LOG_LEVELS = { [vim.log.levels.ERROR] = "error", [vim.log.levels.WARN] = "warn" }

local function logfile()
  return vim.fn.stdpath "state" .. "/errors.jsonl"
end

local function diag_context()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  local clients = vim.tbl_map(function(c)
    return c.name
  end, vim.lsp.get_clients { bufnr = bufnr })

  local diags = vim.diagnostic.get(bufnr)
  local diag_summary = {}
  for _, d in ipairs(diags) do
    local sev = vim.diagnostic.severity[d.severity] or "?"
    diag_summary[#diag_summary + 1] = string.format("%s:%d %s", sev, d.lnum + 1, d.message)
  end

  return { ft = ft, lsp = clients, diagnostics = diag_summary }
end

local _orig_notify = vim.notify

function M.setup()
  vim.notify = function(msg, level, opts)
    if LOG_LEVELS[level] then
      local ok, ctx = pcall(diag_context)
      local entry = vim.json.encode {
        ts = os.time(),
        lvl = LOG_LEVELS[level],
        msg = tostring(msg),
        ctx = ok and ctx or {},
      }
      local f = io.open(logfile(), "a")
      if f then
        f:write(entry .. "\n")
        f:close()
      end
    end
    return _orig_notify(msg, level, opts)
  end

  vim.api.nvim_create_user_command("NvimErrors", function(cmd_opts)
    local lines = {}
    local f = io.open(logfile(), "r")
    if f then
      for line in f:lines() do
        lines[#lines + 1] = line
      end
      f:close()
    end

    if #lines == 0 then
      vim.notify("No errors logged yet.", vim.log.levels.INFO)
      return
    end

    -- most-recent first; optionally filter by arg (grep on raw JSON)
    local filter = cmd_opts.args ~= "" and cmd_opts.args or nil
    local out = {}
    for i = #lines, 1, -1 do
      if not filter or lines[i]:find(filter, 1, true) then
        out[#out + 1] = lines[i]
      end
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, out)
    vim.bo[buf].filetype = "json"
    vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = math.min(160, vim.o.columns - 4),
      height = math.min(30, #out),
      col = 2,
      row = 2,
      style = "minimal",
      border = "rounded",
      title = " nvim errors (q to close) ",
    })
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true })
  end, { nargs = "?", desc = "Browse error log (optional filter string)" })
end

return M
