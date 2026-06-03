# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal Neovim configuration using Lua, organized into modular components with Lazy.nvim for plugin management. Modernized in 2026 for high performance.

## Development Commands

```bash
# Run regression tests
./test/run.sh

# Lint Lua files
luacheck . --config .luacheckrc

# Format Lua files
stylua .

# Check formatting without modifying
stylua --check .

# Validate Lua syntax
luac -p lua/**/*.lua
```

## Architecture

```text
init.lua                    # Bootstrap: leader key (;), Lazy.nvim, module loading
lua/
├── editor/                 # Core editor functionality
│   ├── options.lua         # vim.opt settings
│   ├── keymaps/init.lua    # Global keybindings
│   ├── autocmds.lua        # Autocommands
│   ├── commands.lua        # User commands
│   ├── explorer.lua        # Nvim-tree setup
│   ├── search.lua          # Legacy search utils
│   ├── telescope.lua       # Telescope config (lazy-loaded)
│   └── treesitter.lua      # Treesitter config
├── lsp/init.lua            # Mason + LSP + blink.cmp setup
├── ui/
│   ├── diagnostics.lua     # Diagnostic styling
│   ├── lualine.lua         # Statusline config
│   └── dracula_pro.lua     # Theme setup
└── plugins/                # Lazy.nvim specs
    ├── ai.lua              # CodeCompanion
    ├── core.lua            # tpope stack, diffview
    ├── explorer.lua        # Oil.nvim + Nvim-tree
    ├── formatting.lua      # Conform.nvim
    ├── linting.lua         # Nvim-lint
    ├── lsp.lua             # blink.cmp, lspconfig, fidget
    ├── search.lua          # Telescope (lazy)
    ├── test.lua            # Neotest + DAP
    ├── treesitter.lua      # nvim-treesitter + context
    ├── ui.lua              # snacks.nvim, render-markdown, aerial, dracula-pro
    └── whichkey.lua        # which-key config
```

## Key Patterns & 2026 Standards

**Treesitter**: **Native Neovim 0.12** implementation. `nvim-treesitter` plugin is archived and removed. Highlighting is enabled globally via `lua/editor/treesitter.lua`.

**Completion**: **blink.cmp**
 is the primary engine (Rust-based, fast). Replaces nvim-cmp.

**Fuzzy Finder**: **Snacks.picker** is the default for files/grep/buffers. Telescope is kept for specialized extensions.

**File Explorer**: **Oil.nvim** (`-`) for buffer-based editing, **Nvim-tree** (`<leader>e`) for sidebar.

**Formatting/Linting**: **Conform.nvim** for formatting, **Nvim-lint** for asynchronous linting.

**UI Enhancements**:
- **Snacks.nvim**: Handles dashboard, notifications, gitbrowse, and pickers.
- **render-markdown.nvim**: Automatic beautiful rendering for `.md` and CodeCompanion.
- **Diffview.nvim**: Primary interface for Git diffs (`<leader>gd`).
- **Aerial.nvim**: Code outline/symbols sidebar (`<leader>a`).

**Leader Key**: `;` (also mapped to `<leader>` in some contexts, but primarily `;`).

## Guidelines

- **Performance First**: Favor `blink.cmp` and `snacks.nvim` modules over heavier alternatives.
- **Lazy Loading**: Use `event`, `ft`, or `keys` in plugin specs.
- **Documentation**: Keep `KEYMAPS.md` updated when adding new bindings.
- **Tests**: Run `./test/run.sh` before and after changes.
