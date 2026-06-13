local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key set in init.lua (must be before keymaps)
-- User commands (:Reload, :Vimrc, :Zshenv, etc.) live in editor/commands.lua

-- Searching
map("n", "<CR>", ":nohlsearch<CR><CR>", opts)
map("n", "n", "'Nn'[v:searchforward]", { expr = true })
map("n", "N", "'nN'[v:searchforward]", { expr = true })

-- Navigation between splits
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Tab navigation
map("n", "<S-h>", "gT", opts)
map("n", "<S-l>", "gt", opts)

-- Explorer keymaps in editor/explorer.lua (<leader>-e toggle, <leader>-ef find)

-- Movement
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)

-- Prevent accidental Ex mode
map("n", "Q", "<nop>", opts)

-- Visual mode indentation
map("x", "<", "<gv", opts)
map("x", ">", ">gv", opts)

-- Quick visual select
map("n", "<Leader><Leader>", "V", { noremap = true, silent = true, desc = "Select current line" })

-- Command-line history navigation
map("c", "<C-n>", "<down>", { noremap = true })
map("c", "<C-p>", "<up>", { noremap = true })

local search = require "features.search"

vim.keymap.set("n", "<Leader>ff", function()
  -- Using the new features.search.run_grep wrapper which supports prompting
  local query = vim.fn.input("Rg> ")
  search.run_grep(query)
end, { desc = "Quickfix: Grep text" })

local ok_builtin, builtin = pcall(require, "telescope.builtin")
if ok_builtin then
  vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope: Find files" })
  vim.keymap.set("n", "<Leader>fF", builtin.live_grep, { desc = "Telescope: Live grep" })
  vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
  vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Telescope: Help tags" })
end
