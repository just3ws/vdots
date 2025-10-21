local map = vim.keymap.set
local cmd = vim.api.nvim_create_user_command
local opts = { noremap = true, silent = true }

-- Leader mappings
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- Command mode convenience
map("n", ";", ":", { noremap = true })

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

-- nvim-tree
map("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
map("n", "<leader>ef", ":NvimTreeFindFile<CR>", { silent = true })

-- Movement
map("n", "j", "gj", opts)
map("n", "k", "gk", opts)

-- Prevent accidental Ex mode
map("n", "Q", "<nop>", opts)

-- Visual mode indentation
map("x", "<", "<gv", opts)
map("x", ">", ">gv", opts)

-- Quick visual select
map("n", "<Leader><Leader>", "V", opts)

-- Command-line history navigation
map("c", "<C-n>", "<down>", { noremap = true })
map("c", "<C-p>", "<up>", { noremap = true })

-- Reload config
cmd("Reload", "source $MYVIMRC", {})
cmd("Vimrc", "edit $MYVIMRC", {})
cmd("Svimrc", "split $MYVIMRC", {})
cmd("Tvimrc", "tabedit $MYVIMRC", {})
cmd("Vvimrc", "vsplit $MYVIMRC", {})
cmd("Zshenv", "edit $ZDOTDIR/.zshenv", {})
cmd("Szshenv", "split $ZDOTDIR/.zshenv", {})
cmd("Tzshenv", "tabedit $ZDOTDIR/.zshenv", {})
cmd("Vzshenv", "vsplit $ZDOTDIR/.zshenv", {})

-- Telescope
local builtin = require "telescope.builtin"

vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope: Find files" })
vim.keymap.set("n", "<Leader>ff", builtin.live_grep, { desc = "Telescope: Grep text" })
vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Telescope: Help tags" })
