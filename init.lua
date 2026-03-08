-- ============================================================================
-- 🧠  Core Initialization
-- ============================================================================

-- Set leader early (must be before any keymap logic)
vim.g.mapleader = ";"
vim.g.maplocalleader = "\\"

-- Ensure PATH exists before plugin bootstrap (mason reads it during setup).
if not vim.env.PATH or vim.env.PATH == "" then
  vim.env.PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
end

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
  rocks = {
    enabled = false,
    hererocks = false,
  },
})

-- ============================================================================
-- ⚙️  Core Editor Modules
-- ============================================================================
require "editor.options" -- General settings (all vim.opt)
require "filetypes" -- Custom filetype mappings
require "editor.keymaps" -- Global keybindings
require "editor.autocmds" -- Event hooks
require "editor.commands" -- :Commands
require("editor.search").setup() -- Native grep/quickfix commands
require "editor.healthcheck" -- Log deprecation warnings
-- explorer loaded via plugins/explorer.lua (NERDTree config)

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
-- ui.nord.setup() called via plugins/ui.lua config (after nord.nvim loads)
require("ui.diagnostics").setup() -- Diagnostic colors & symbols
-- telescope loaded via plugins/search.lua

-- ============================================================================
-- 🔍  Misc
-- ============================================================================
vim.opt.tags:append ".git/tags"
