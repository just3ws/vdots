local M = {}

local function trim(value)
  if type(value) ~= "string" then
    return nil
  end
  local cleaned = vim.trim(value)
  if cleaned == "" then
    return nil
  end
  return cleaned
end

function M.normalize_query(value)
  return trim(value)
end

function M.build_grep_cmd(query)
  return ("silent grep! %s"):format(vim.fn.shellescape(query))
end

function M.run_grep(query, opts)
  local normalized = M.normalize_query(query)
  if not normalized then
    return false
  end

  vim.cmd(M.build_grep_cmd(normalized))
  if not (opts and opts.open_qf == false) then
    vim.cmd "copen"
  end

  return true
end

function M.prompt_and_grep(prompt)
  local query = vim.fn.input(prompt or "Grep> ")
  return M.run_grep(query)
end

function M.setup()
  if vim.fn.executable "rg" == 1 then
    vim.opt.grepprg = "rg --vimgrep --smart-case"
    vim.opt.grepformat = "%f:%l:%c:%m"
  end

  vim.api.nvim_create_user_command("Rg", function(opts)
    local query = opts.args
    if query == "" then
      M.prompt_and_grep "Rg> "
      return
    end
    M.run_grep(query)
  end, { nargs = "*" })

  vim.api.nvim_create_user_command("Ack", function(opts)
    local query = opts.args
    if query == "" then
      M.prompt_and_grep "Ack> "
      return
    end
    M.run_grep(query)
  end, { nargs = "*" })
end

return M
