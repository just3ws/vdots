local M = {}

--- The Search Feature
--- Consolidates native grep capabilities and picker configurations.

local function trim(value)
  if type(value) ~= "string" then return nil end
  local cleaned = vim.trim(value)
  return cleaned == "" and nil or cleaned
end

function M.run_grep(query, opts)
  local normalized = trim(query)
  if not normalized then return false end
  
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

  -- 2. Commands
  vim.api.nvim_create_user_command("Rg", function(opts)
    M.run_grep(opts.args ~= "" and opts.args or vim.fn.input "Rg> ")
  end, { nargs = "*" })
end

return M
