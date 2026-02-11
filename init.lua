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
-- ⚙️  Core Editor Modules
-- ============================================================================
require "editor.options" -- General settings (all vim.opt)
require "editor.keymaps" -- Global keybindings
require "editor.autocmds" -- Event hooks
require "editor.commands" -- :Commands
require("editor.search").setup() -- Native grep/quickfix commands
require "editor.healthcheck" -- Log deprecation warnings
-- explorer loaded via plugins/explorer.lua (oil.nvim config)

-- ============================================================================
-- 🧩  Language / LSP / Tooling
-- ============================================================================
-- lsp loaded via plugins/lsp.lua (nvim-lspconfig config)
-- require "editor.linting" -- nvim-lint integration
-- require "editor.formatting" -- conform.nvim setup
require "editor.treesitter" -- syntax / highlighting

-- ============================================================================
-- 🎨  UI & Theming
-- ============================================================================
require("ui.nord").setup() -- Nord color theme (non-italic)
require("ui.diagnostics").setup() -- Diagnostic colors & symbols
-- telescope loaded via plugins/search.lua
require "legacy.fzf_aliases"

-- ============================================================================
-- 🔍  Misc
-- ============================================================================
vim.opt.tags:append ".git/tags"
