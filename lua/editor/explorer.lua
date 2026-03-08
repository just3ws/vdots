local M = {}

---Toggle the sidebar explorer.
function M.toggle()
  require("nvim-tree.api").tree.toggle()
end

---Find the current file in the sidebar explorer.
function M.toggle_find()
  require("nvim-tree.api").tree.find_file { open = true, focus = true }
end

function M.setup()
  -- Use <leader>n to toggle NvimTree
  vim.keymap.set("n", "<leader>n", M.toggle, { silent = true, desc = "Explorer toggle" })

  -- Use <leader>ef to find current file in NvimTree
  vim.keymap.set(
    "n",
    "<leader>ef",
    M.toggle_find,
    { silent = true, desc = "Explorer toggle + find" }
  )

  -- Sync with window closing
  vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
      if #vim.api.nvim_list_wins() == 1 and require("nvim-tree.utils").is_nvim_tree_buf() then
        vim.cmd "quit"
      end
    end,
  })
end

return M
