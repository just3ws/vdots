local M = {}

--- The Search Feature
--- Consolidates native grep capabilities and picker configurations.

local function trim(value)
  if type(value) ~= "string" then
    return nil
  end
  local cleaned = vim.trim(value)
  -- explicit branch: `cleaned == "" and nil or cleaned` returns "" (and/or trap)
  if cleaned == "" then
    return nil
  end
  return cleaned
end

function M.run_grep(query, opts)
  local normalized = trim(query)
  if not normalized then
    return false
  end

  vim.cmd(("silent grep! %s"):format(vim.fn.shellescape(normalized)))
  if not (opts and opts.open_qf == false) then
    vim.cmd "copen"
  end
  return true
end

function M.run_ack(query, opts)
  opts = opts or {}
  local normalized = trim(query)
  if not normalized then
    return false
  end

  local cmd
  if opts.type then
    cmd = ("silent grep! --type=%s %s"):format(
      vim.fn.shellescape(opts.type),
      vim.fn.shellescape(normalized)
    )
  else
    cmd = ("silent grep! %s"):format(vim.fn.shellescape(normalized))
  end

  vim.cmd(cmd)
  pcall(vim.fn.setqflist, {}, "a", { title = ("ack: %s"):format(normalized) })

  if opts.open_qf ~= false then
    vim.cmd "copen"
  end
  return true
end

function M.run_ack_word(opts)
  local word = vim.fn.expand "<cword>"
  if word and word ~= "" then
    return M.run_ack(word, opts)
  end
  return false
end

function M.run_ack_visual(opts)
  local saved_reg = vim.fn.getreg '"'
  local saved_regtype = vim.fn.getregtype '"'
  vim.cmd 'normal! "vy'
  local selection = vim.fn.getreg '"'
  vim.fn.setreg('"', saved_reg, saved_regtype)
  if selection and selection ~= "" then
    return M.run_ack(selection, opts)
  end
  return false
end

function M.run_ack_trouble(query, opts)
  opts = opts or {}
  local normalized = trim(query)
  if not normalized then
    return false
  end
  local ok = M.run_ack(normalized, vim.tbl_extend("force", opts, { open_qf = false }))
  if ok then
    local ok_tr, _ = pcall(vim.cmd, "Trouble qflist open")
    if not ok_tr then
      vim.cmd "copen"
    end
  end
  return ok
end

function M.setup()
  -- 1. Native Grep Configuration (ack preferred, ripgrep fallback)
  if vim.fn.executable "ack" == 1 then
    vim.opt.grepprg = "ack -H --nogroup --column --smart-case --nocolor --nofilter"
    vim.opt.grepformat = "%f:%l:%c:%m"
    vim.g.ackprg = "ack -H --nogroup --column --smart-case --nocolor --nofilter"
    vim.g.ackhighlight = 1
  elseif vim.fn.executable "rg" == 1 then
    vim.opt.grepprg = "rg --vimgrep --smart-case"
    vim.opt.grepformat = "%f:%l:%c:%m"
  end

  -- 2. User Commands (:Ack, :AckAdd, :AckFile, :AckWord, :AckTrouble, :Rg, :Ag)
  local function ack_cmd(opts)
    local query = opts.args ~= "" and opts.args or vim.fn.input "Ack> "
    M.run_ack(query)
  end

  vim.api.nvim_create_user_command("Ack", ack_cmd, {
    bang = true,
    nargs = "*",
    desc = "Search workspace with ack into quickfix",
  })

  vim.api.nvim_create_user_command("AckAdd", function(opts)
    local query = opts.args ~= "" and opts.args or vim.fn.input "AckAdd> "
    local normalized = trim(query)
    if normalized then
      vim.cmd(("silent grepadd! %s"):format(vim.fn.shellescape(normalized)))
      vim.cmd "copen"
    end
  end, {
    bang = true,
    nargs = "*",
    desc = "Append ack search results to quickfix",
  })

  vim.api.nvim_create_user_command("AckFile", function(opts)
    local query = opts.args ~= "" and opts.args or vim.fn.input "AckFile> "
    local normalized = trim(query)
    if normalized then
      local current_file = vim.fn.expand "%"
      vim.cmd(
        ("silent grep! %s %s"):format(
          vim.fn.shellescape(normalized),
          vim.fn.shellescape(current_file)
        )
      )
      vim.cmd "copen"
    end
  end, {
    bang = true,
    nargs = "*",
    desc = "Search current file with ack into quickfix",
  })

  vim.api.nvim_create_user_command("AckWord", function()
    M.run_ack_word()
  end, {
    desc = "Search word under cursor with ack into quickfix",
  })

  vim.api.nvim_create_user_command("AckTrouble", function(opts)
    local query = opts.args ~= "" and opts.args or vim.fn.input "AckTrouble> "
    M.run_ack_trouble(query)
  end, {
    bang = true,
    nargs = "*",
    complete = "file",
    desc = "Search workspace with ack into Trouble quickfix view",
  })

  vim.api.nvim_create_user_command("Rg", function(opts)
    local query = opts.args ~= "" and opts.args or vim.fn.input "Rg> "
    M.run_grep(query)
  end, {
    bang = true,
    nargs = "*",
    desc = "Grep text into quickfix (ripgrep/native)",
  })

  vim.api.nvim_create_user_command("Ag", function(opts)
    local query = opts.args ~= "" and opts.args or vim.fn.input "Ag> "
    M.run_grep(query)
  end, {
    bang = true,
    nargs = "*",
    desc = "SilverSearcher/grep search into quickfix",
  })
end

return M
