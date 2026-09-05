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

-- Keep cursor position when joining lines in normal mode
map("n", "J", "mzJ`z", { desc = "Join lines" })

-- Move lines up/down (with auto-reindent)
map("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move line up" })
map("x", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("x", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

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

local fzf_mod = require "editor.fzf"

vim.keymap.set("n", "<Leader>a", function()
  if not fzf_mod.ack() then
    local query = vim.fn.input "Ack> "
    search.run_ack(query)
  end
end, { desc = "Fack: Live Ack search (Fzf)" })

vim.keymap.set("n", "<Leader>fa", function()
  if not fzf_mod.ack() then
    local query = vim.fn.input "Ack> "
    search.run_ack(query)
  end
end, { desc = "Fack: Live Ack search (Fzf, shell parity)" })

vim.keymap.set("n", "<Leader>ff", function()
  if not fzf_mod.files() then
    local prompt = vim.fn.executable "ack" == 1 and "Ack> " or "Rg> "
    local query = vim.fn.input(prompt)
    search.run_ack(query)
  end
end, { desc = "Fackf: Ack files finder (Fzf, shell parity)" })

vim.keymap.set("n", "<Leader>aw", function()
  if not fzf_mod.ack_word() then
    search.run_ack_word()
  end
end, { desc = "Fack: Word under cursor into live Ack" })

vim.keymap.set("x", "<Leader>a", function()
  if not fzf_mod.ack_visual() then
    search.run_ack_visual()
  end
end, { desc = "Fack: Visual selection into live Ack" })

vim.keymap.set("n", "<Leader>at", function()
  local query = vim.fn.input "AckTrouble> "
  search.run_ack_trouble(query)
end, { desc = "Ack: Search workspace into Trouble view" })

vim.keymap.set("n", "<Leader>fA", function()
  local query = vim.fn.input "Quickfix Ack> "
  search.run_ack(query)
end, { desc = "Quickfix: Ack text directly into quickfix" })

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
  vim.keymap.set("n", "<Leader>,", builtin.buffers, { desc = "Buffers" })
  vim.keymap.set("n", "<Leader><Space>", builtin.find_files, { desc = "Find files" })
  vim.keymap.set("n", "<Leader>/", builtin.live_grep, { desc = "Grep (live)" })
  vim.keymap.set("n", "<Leader>fg", builtin.live_grep, { desc = "Grep (live)" })
  vim.keymap.set("n", "<Leader>fr", builtin.oldfiles, { desc = "Recent files" })
  vim.keymap.set("n", "<Leader>:", builtin.command_history, { desc = "Command history" })
  vim.keymap.set("n", "<Leader>fc", function()
    builtin.find_files { cwd = vim.fn.stdpath "config" }
  end, { desc = "Find config file" })
end

local ok_fzf, fzf = pcall(require, "fzf-lua")
if ok_fzf then
  vim.keymap.set("n", "<Leader>za", fzf_mod.ack, { desc = "Fzf: Live Ack search" })
  vim.keymap.set("n", "<Leader>zf", fzf_mod.files, { desc = "Fzf: Ack files finder" })
  vim.keymap.set("n", "<Leader>zb", fzf.buffers, { desc = "Fzf: Buffers" })
  vim.keymap.set("n", "<Leader>zg", fzf.live_grep, { desc = "Fzf: Live grep" })
  vim.keymap.set("n", "<Leader>zh", fzf.help_tags, { desc = "Fzf: Help tags" })
  vim.keymap.set("n", "<Leader>zq", fzf.quickfix, { desc = "Fzf: Quickfix list" })
end

-- Buffer / window / quit / snacks convenience (adapted to leader `;`).
-- Snacks.bufdelete closes the buffer while preserving the window layout.
map("n", "<Leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete buffer" })
map("n", "<Leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git browse" })
map("n", "<Leader>n", function()
  Snacks.notifier.show_history()
end, { desc = "Notification history" })
map("n", "<Leader>un", function()
  Snacks.notifier.hide()
end, { desc = "Dismiss notifications" })
map("n", "<Leader>ww", "<C-w>p", { desc = "Other window" })
map("n", "<Leader>wd", "<C-w>c", { desc = "Delete window" })
map("n", "<Leader>qq", "<cmd>qa<CR>", { desc = "Quit all" })

-- Package management keymaps (vim.pack)
map("n", "<Leader>L", "<cmd>PackUpdate<CR>", { desc = "PackUpdate (interactive)" })
map("n", "<Leader>Pu", "<cmd>PackUpdate<CR>", { desc = "Plugin: Update (interactive)" })
map("n", "<Leader>Ps", "<cmd>PackSync<CR>", { desc = "Plugin: Sync to lockfile" })
map("n", "<Leader>Pc", "<cmd>PackClean<CR>", { desc = "Plugin: Clean unmanaged" })
map("n", "<Leader>PS", "<cmd>PackStatus<CR>", { desc = "Plugin: Status" })
