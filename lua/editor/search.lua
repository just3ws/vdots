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

function M.setup()
  -- 1. Native Grep Configuration
  if vim.fn.executable "rg" == 1 then
    vim.opt.grepprg = "rg --vimgrep --smart-case"
    vim.opt.grepformat = "%f:%l:%c:%m"
  end

  -- 2. Commands (:Rg, :Ack, :Ag)
  local function grep_cmd(prompt_name)
    return function(opts)
      local query = opts.args ~= "" and opts.args or vim.fn.input(prompt_name .. "> ")
      M.run_grep(query)
    end
  end

  vim.api.nvim_create_user_command("Rg", grep_cmd "Rg", {
    bang = true,
    nargs = "*",
    desc = "Grep text into quickfix (ripgrep)",
  })
  vim.api.nvim_create_user_command("Ack", grep_cmd "Ack", {
    bang = true,
    nargs = "*",
    desc = "Ack/Ripgrep search into quickfix",
  })
  vim.api.nvim_create_user_command("Ag", grep_cmd "Ag", {
    bang = true,
    nargs = "*",
    desc = "SilverSearcher/Ripgrep search into quickfix",
  })
end

return M
