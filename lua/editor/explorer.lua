local M = {}

local function open_sidebar(path)
  vim.cmd "topleft vsplit"
  vim.cmd "vertical resize 36"
  require("oil").open(path)
end

local function find_oil_window()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "oil" then
      return win
    end
  end
  return nil
end

function M.toggle()
  local oil_win = find_oil_window()
  if oil_win then
    vim.api.nvim_win_close(oil_win, true)
    return
  end
  open_sidebar()
end

function M.reveal_current_file()
  local path = vim.fn.expand "%:p:h"
  if path == "" then
    path = vim.fn.getcwd()
  end
  local oil_win = find_oil_window()
  if oil_win then
    vim.api.nvim_set_current_win(oil_win)
    require("oil").open(path)
    return
  end
  open_sidebar(path)
end

function M.setup()
  local oil = require "oil"

  oil.setup {
    default_file_explorer = true,
    columns = { "icon" },
    view_options = {
      show_hidden = true,
      natural_order = true,
    },
    keymaps = {
      ["<C-s>"] = false,
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["q"] = "actions.close",
    },
  }

  vim.keymap.set("n", "<leader>n", M.toggle, { silent = true, desc = "Explorer toggle" })
  vim.keymap.set(
    "n",
    "<leader>ef",
    M.reveal_current_file,
    { silent = true, desc = "Explorer reveal file" }
  )

  -- Compatibility aliases while migrating away from NERDTree
  vim.api.nvim_create_user_command("NERDTreeToggle", M.toggle, {})
  vim.api.nvim_create_user_command("NERDTreeFind", M.reveal_current_file, {})
  vim.api.nvim_create_user_command("NERDTree", function(opts)
    if opts.args ~= "" then
      open_sidebar(opts.args)
      return
    end
    M.toggle()
  end, { nargs = "?" })

  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      if vim.fn.argc() ~= 1 then
        return
      end
      local arg = vim.fn.argv(0)
      if vim.fn.isdirectory(arg) ~= 1 then
        return
      end
      open_sidebar(vim.fn.fnamemodify(arg, ":p"))
      vim.cmd "wincmd p"
    end,
  })
end

return M
