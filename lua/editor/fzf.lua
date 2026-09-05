local M = {}

--- Fzf-Lua & Ack Integration
--- Provides ultra-fast interactive fuzzy search using fzf and ack,
--- maintaining 1:1 parity with the shell's `fack` and `fackf` tools.

function M.get_ack_cmd()
  if vim.fn.executable "ack" == 1 then
    return "ack -H --nogroup --column --smart-case --nocolor --nofilter"
  end
  return nil
end

local function copy_path(selected)
  if selected and #selected > 0 then
    local entry = selected[1]
    local path = entry:match "^([^:]+)" or entry
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path, vim.log.levels.INFO, { title = "fzf-ack" })
  end
end

function M.setup()
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    return false
  end

  local ack_cmd = M.get_ack_cmd()
  local actions = fzf.actions

  fzf.setup {
    winopts = {
      height = 0.85,
      width = 0.85,
      row = 0.35,
      col = 0.50,
      preview = {
        layout = "flex",
        flip_columns = 120,
      },
    },
    keymap = {
      builtin = {
        ["<C-d>"] = "preview-page-down",
        ["<C-u>"] = "preview-page-up",
      },
      fzf = {
        ["ctrl-z"] = "abort",
        ["ctrl-u"] = "unix-line-discard",
        ["ctrl-a"] = "beginning-of-line",
        ["ctrl-e"] = "end-of-line",
      },
    },
    actions = {
      files = {
        ["default"] = actions.file_edit_or_qf,
        ["ctrl-s"] = actions.file_split,
        ["ctrl-v"] = actions.file_vsplit,
        ["ctrl-t"] = actions.file_tabedit,
        ["ctrl-q"] = actions.file_sel_to_qf,
        ["ctrl-y"] = copy_path,
      },
    },
    files = {
      prompt = "ack-files> ",
      multiprocess = true,
      cmd = vim.fn.executable "ack" == 1 and "ack -f" or nil,
    },
    grep = {
      prompt = "ack> ",
      cmd = ack_cmd,
    },
  }

  -- User commands with 1:1 shell parity (:Fack == `fack`, :Fackf == `fackf`)
  local function fack_cmd(opts)
    local query = opts.args ~= "" and opts.args or nil
    M.ack(query)
  end

  vim.api.nvim_create_user_command("Fack", fack_cmd, {
    nargs = "*",
    desc = "Live interactive search via Fzf and Ack (shell fack parity)",
  })

  vim.api.nvim_create_user_command("FzfAck", fack_cmd, {
    nargs = "*",
    desc = "Live interactive search via Fzf and Ack (alias to :Fack)",
  })

  local function fackf_cmd()
    M.files()
  end

  vim.api.nvim_create_user_command("Fackf", fackf_cmd, {
    desc = "Find files indexed by Ack (.ackrc) via Fzf (shell fackf parity)",
  })

  vim.api.nvim_create_user_command("FzfAckFiles", fackf_cmd, {
    desc = "Find files indexed by Ack (.ackrc) via Fzf (alias to :Fackf)",
  })

  vim.api.nvim_create_user_command("FackWord", function()
    M.ack_word()
  end, {
    desc = "Live Ack search for word under cursor via Fzf",
  })

  return true
end

function M.ack(query)
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    return false
  end
  local ack_cmd = M.get_ack_cmd()
  if ack_cmd then
    fzf.live_grep {
      cmd = ack_cmd,
      search = query,
      prompt = "ack> ",
    }
  else
    fzf.live_grep { search = query, prompt = "grep> " }
  end
  return true
end

function M.ack_word()
  local word = vim.fn.expand "<cword>"
  if word and word ~= "" then
    return M.ack(word)
  end
  return M.ack()
end

function M.ack_visual()
  local saved_reg = vim.fn.getreg '"'
  local saved_regtype = vim.fn.getregtype '"'
  vim.cmd 'normal! "vy'
  local selection = vim.fn.getreg '"'
  vim.fn.setreg('"', saved_reg, saved_regtype)
  if selection and selection ~= "" then
    return M.ack(selection)
  end
  return M.ack()
end

function M.files()
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    return false
  end
  if vim.fn.executable "ack" == 1 then
    fzf.files {
      cmd = "ack -f",
      prompt = "ack-files> ",
    }
  else
    fzf.files()
  end
  return true
end

return M
