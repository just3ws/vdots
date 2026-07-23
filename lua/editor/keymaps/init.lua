local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader key set in init.lua (must be before keymaps)
-- User commands (:Reload, :Vimrc, :Zshenv, etc.) live in editor/commands.lua

-- Searching (recenter + reopen folds on each jump)
map("n", "<CR>", ":nohlsearch<CR><CR>", opts)
map("n", "n", "'Nn'[v:searchforward] . 'zzzv'", { expr = true })
map("n", "N", "'nN'[v:searchforward] . 'zzzv'", { expr = true })

-- Keep cursor centered while scrolling
map("n", "<C-d>", "<C-d>zz", opts)
map("n", "<C-u>", "<C-u>zz", opts)

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

-- Move visually-selected lines up/down (with auto-reindent)
map("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Register-safe paste/delete (don't clobber the unnamed register)
map("x", "p", '"_dP', { desc = "Paste without yanking selection" })
map({ "n", "x" }, "<Leader>D", '"_d', { desc = "Delete to black hole register" })

-- Copy-on-yank model: yanks auto-copy to the clipboard (see autocmds.lua).
-- These make pasting *from* the system clipboard explicit and discoverable.
map({ "n", "x" }, "<Leader>p", '"+p', { desc = "Paste from system clipboard" })
map({ "n", "x" }, "<Leader>P", '"+P', { desc = "Paste from system clipboard (before)" })

-- Quickfix navigation (pairs with <Leader>ff grep → quickfix workflow)
map("n", "]q", "<cmd>cnext<CR>zz", { desc = "Quickfix next" })
map("n", "[q", "<cmd>cprev<CR>zz", { desc = "Quickfix prev" })
map("n", "]Q", "<cmd>clast<CR>zz", { desc = "Quickfix last" })
map("n", "[Q", "<cmd>cfirst<CR>zz", { desc = "Quickfix first" })
map("n", "<Leader>xq", function()
  local open = false
  for _, w in ipairs(vim.fn.getwininfo()) do
    if w.quickfix == 1 then
      open = true
    end
  end
  vim.cmd(open and "cclose" or "copen")
end, { desc = "Toggle quickfix list" })

-- Quick visual select
map("n", "<Leader><Leader>", "V", { noremap = true, silent = true, desc = "Select current line" })

-- Command-line history navigation
map("c", "<C-n>", "<down>", { noremap = true })
map("c", "<C-p>", "<up>", { noremap = true })

local search = require "editor.search"

vim.keymap.set("n", "<Leader>ff", function()
  local query = vim.fn.input "Rg> "
  search.run_grep(query)
end, { desc = "Quickfix: Grep text" })

local ok_builtin, builtin = pcall(require, "telescope.builtin")
if ok_builtin then
  vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Telescope: Find files" })
  vim.keymap.set("n", "<Leader>fF", builtin.live_grep, { desc = "Telescope: Live grep" })
  vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
  vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Telescope: Help tags" })

  -- LazyVim-standard picker set, adapted to leader `;`. Telescope is the primary
  -- picker (it owns the <leader>f* family + editor/telescope.lua config); the
  -- Snacks picker stays for dashboard actions. <leader>ff is already the
  -- grep→quickfix workflow, so find-files lands on the LazyVim <leader><space>.
  vim.keymap.set("n", "<Leader><Space>", builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<Leader>/", builtin.live_grep, { desc = "Grep (live)" })
  vim.keymap.set("n", "<Leader>fg", builtin.live_grep, { desc = "Grep (live)" })
  vim.keymap.set("n", "<Leader>fr", builtin.oldfiles, { desc = "Recent files" })
  vim.keymap.set("n", "<Leader>:", builtin.command_history, { desc = "Command history" })
  vim.keymap.set("n", "<Leader>fc", function()
    builtin.find_files { cwd = vim.fn.stdpath "config" }
  end, { desc = "Find config file" })
end

-- Buffer / window / quit convenience (LazyVim-standard, adapted to leader `;`).
-- Snacks.bufdelete closes the buffer while preserving the window layout.
map("n", "<Leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete buffer" })
map("n", "<Leader>ww", "<C-w>p", { desc = "Other window" })
map("n", "<Leader>wd", "<C-w>c", { desc = "Delete window" })
map("n", "<Leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })
