-- Leader mappings
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- Detect Homebrew prefix dynamically
local brew_prefix = vim.fn.isdirectory "/opt/homebrew" == 1 and "/opt/homebrew" or "/usr/local"

-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup "plugins"

-- Disable netrw at the very start if using nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Core modules (these should all live in ~/.config/nvim/lua/)
-- require "plugins"
require "options"
require "core.keymaps"
require "core.autocmds"
require "editor.diagnostics"
require "settings"
require "filetypes"
require "lsp"
require "editor.linting"
require "editor.formatting"
require "treesitter"
require "ui.nvimtree"
require "colors.nord"

-- UI and appearance
vim.opt.tags:append ".git/tags"
