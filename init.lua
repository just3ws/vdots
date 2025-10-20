-- ============================================================================
-- 🧠  Core Initialization
-- ============================================================================

-- Set leader early (must be before any keymap logic)
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"

-- ============================================================================
-- 📦  Bootstrap Lazy.nvim
-- ============================================================================
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Load plugin definitions (lazy.nvim reads from lua/plugins/)
require("lazy").setup("plugins", {
  change_detection = { notify = false },
  ui = { border = "rounded" },
})

-- ============================================================================
-- 🚫  Disable legacy netrw (handled by nvim-tree)
-- ============================================================================
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ============================================================================
-- ⚙️  Core Editor Modules
-- ============================================================================
require "editor.options" -- General settings (indentation, etc.)
require "editor.keymaps" -- Global keybindings
require "editor.autocmds" -- Event hooks
require "editor.settings" -- Misc low-level tweaks

-- ============================================================================
-- 🧩  Language / LSP / Tooling
-- ============================================================================
require "lsp" -- LSP setup via mason + native APIs
require "editor.linting" -- nvim-lint integration
require "editor.formatting" -- conform.nvim setup
require "editor.treesitter" -- syntax / highlighting

-- ============================================================================
-- 🎨  UI & Theming
-- ============================================================================
require("ui.nord").setup() -- Nord color theme (non-italic)
require "ui.diagnostics" -- Diagnostic colors & symbols
require "ui.nvimtree" -- File explorer

-- ============================================================================
-- 🔍  Misc
-- ============================================================================
vim.opt.tags:append ".git/tags"
