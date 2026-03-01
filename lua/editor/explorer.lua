local M = {}

---@return integer|nil win  Window ID of the NERDTree split, or nil if not open
local function find_nerdtree_window()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "nerdtree" then
      return win
    end
  end

  return nil
end

---Set NERDTree global variables before the plugin loads.
function M.setup_globals()
  vim.g.NERDTreeShowHidden = 1
  vim.g.NERDTreeMinimalUI = 1
  vim.g.NERDTreeDirArrows = 1
  vim.g.NERDTreeWinSize = 36
  vim.g.NERDTreeQuitOnOpen = 0
  vim.g.NERDTreeRespectWildIgnore = 1
  vim.g.NERDTreeHijackNetrw = 0
  vim.g.NERDTreeAutoDeleteBuffer = 1
  vim.g.NERDTreeIgnore = { "^\\.DS_Store$" }
end

---Toggle NERDTree open/closed.
function M.toggle()
  vim.cmd "NERDTreeToggle"
end

---Toggle NERDTree; reveal the current file when opening, close if already open.
function M.toggle_find()
  if find_nerdtree_window() then
    vim.cmd "NERDTreeClose"
    return
  end

  local current_file = vim.fn.expand "%:p"
  if current_file ~= "" and vim.fn.filereadable(current_file) == 1 then
    vim.cmd "NERDTreeFind"
    return
  end

  vim.cmd "NERDTreeToggle"
end

local function ensure_target_window_for_open()
  if vim.fn.winnr "$" ~= 1 then
    return
  end

  vim.cmd "rightbelow vnew"
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.buflisted = false
  vim.bo.swapfile = false
  vim.cmd "wincmd h"
end

function M.setup()
  vim.keymap.set("n", "<leader>-e", M.toggle, { silent = true, desc = "NERDTree toggle" })
  vim.keymap.set(
    "n",
    "<leader>-ef",
    M.toggle_find,
    { silent = true, desc = "NERDTree toggle + find" }
  )

  -- Compatibility aliases with prior explorer mappings.
  vim.keymap.set("n", "<leader>n", M.toggle, { silent = true, desc = "NERDTree toggle" })
  vim.keymap.set(
    "n",
    "<leader>ef",
    M.toggle_find,
    { silent = true, desc = "NERDTree toggle + find" }
  )

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "nerdtree",
    callback = ensure_target_window_for_open,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "NERD_tree_*",
    callback = function()
      if vim.fn.winnr "$" == 1 then
        vim.cmd "quit"
      end
    end,
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      if vim.fn.argc() ~= 1 then
        return
      end

      local arg = vim.fn.argv(0)
      if vim.fn.isdirectory(arg) ~= 1 then
        return
      end

      local dir = vim.fn.fnamemodify(arg, ":p")
      vim.cmd("NERDTree " .. vim.fn.fnameescape(dir))
      vim.cmd "wincmd p"
    end,
  })
end

return M
