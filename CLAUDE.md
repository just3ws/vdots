# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal Neovim configuration using Lua, built on native Neovim 0.12 features: `vim.pack` for plugin management, `vim.lsp.config`/`vim.lsp.enable` for LSP, native treesitter. No Lazy.nvim, no Mason.

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
init.lua                    # Leader key (;), vim.pack.add, module loading, LSP wiring
lua/
├── plugins.lua             # setup_all(): every plugin's setup() + its keymaps
├── filetypes.lua           # vim.filetype.add overrides
├── editor/                 # Core editor functionality
│   ├── options.lua         # ALL vim.opt/vim.g settings (never set options in init.lua)
│   ├── keymaps/init.lua    # Global non-plugin keybindings
│   ├── autocmds.lua        # Autocommands
│   ├── commands.lua        # User commands (:Reload, :Zdots*)
│   ├── explorer.lua        # Nvim-tree NERDTree-style mappings
│   ├── search.lua          # Native rg grep → quickfix (:Rg, <leader>ff)
│   ├── telescope.lua       # Telescope defaults
│   ├── treesitter.lua      # Native TS highlighting + textobjects
│   ├── llm.lua             # Local llama.cpp integration (ai-query)
│   ├── claude.lua          # Claude Code session pulse + :ClaudeDiff
│   ├── usage.lua           # Friction telemetry → :NvimUsage
│   ├── errors.lua          # Error log → :NvimErrors
│   └── healthcheck.lua     # Deprecation-warning filter/log
├── ui/
│   ├── diagnostics.lua     # vim.diagnostic.config styling
│   ├── lualine.lua         # Statusline config
│   └── kanagawa_wave.lua   # Wave palette + highlight overrides (colorscheme itself is "kanagawa-wave")
└── zdots/init.lua          # Bridge to the zdots shell platform (~/.config/zsh/bin)
```

Load order in init.lua: leader → `vim.pack.add` → `editor.*` modules → snacks → theme (`kanagawa-wave` + kanagawa_wave overrides, lualine, diagnostics, treesitter) → `require("plugins").setup_all()` → LSP wiring.

## Key Patterns & 2026 Standards

**Plugin management**: Native **`vim.pack`** (declared in init.lua, `:PackSync` to update, `nvim-pack-lock.json` is the lockfile). Plugin *setup* lives in `lua/plugins.lua` — add new plugins in both places.

**Treesitter**: Native Neovim 0.12 (`vim.treesitter.start` via FileType autocmd in `lua/editor/treesitter.lua`).

**Completion**: **blink.cmp** (Rust-based; installed via vim.pack with a `1.*` version range so the prebuilt fuzzy lib is used).

**LSP**: Native `vim.lsp.config()` + `vim.lsp.enable()` in init.lua. Servers resolve from PATH (mise shims / Homebrew) — no Mason.

**Fuzzy Finder**: **Telescope** bound to `<C-p>`/`<leader>f*`; **Snacks.picker** drives the dashboard.

**File Explorer**: **Oil.nvim** (`-`) for buffer-based editing, **Nvim-tree** (`<leader>e`) for sidebar.

**Formatting/Linting**: **Conform.nvim** on save, **Nvim-lint** async.

**UI Enhancements**:
- **Snacks.nvim**: dashboard, notifications, gitbrowse, statuscolumn.
- **render-markdown.nvim**: renders `.md` and CodeCompanion buffers.
- **Diffview.nvim**: Git diffs (`<leader>gd`), Claude last-change diff (`<leader>gC`).
- **Aerial.nvim**: code outline (`<leader>a`).

**Leader Key**: `;`

## Guidelines

- **Options live in `lua/editor/options.lua`** — init.lua sets only the leader.
- **Ponytail rules**: prefer deletion, stdlib, and native platform features; mark deliberate shortcuts with `-- ponytail:` comments.
- **Documentation**: Keep `KEYMAPS.md` updated when adding new bindings.
- **Tests**: Run `./test/run.sh` before and after changes.
