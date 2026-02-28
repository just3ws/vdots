# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Personal Neovim configuration using Lua, organized into modular components with Lazy.nvim for plugin management.

## Development Commands

```bash
# Run regression tests (MUST pass before any change)
./test/run.sh

# Lint Lua files
luacheck . --config .luacheckrc

# Format Lua files
stylua .

# Check formatting without modifying
stylua --check .

# Validate Lua syntax
luac -p lua/**/*.lua

# Validate Vimscript syntax
nvim --headless -c 'quit'
```

Pre-commit hooks run automatically: trailing whitespace removal, EOF newline, Lua/Vim syntax validation.

**Test-driven workflow:**
1. Run `./test/run.sh` before making changes (baseline)
2. Make change
3. Run `./test/run.sh` after change
4. If tests fail, **STOP** - investigate before proceeding
5. Commit only if tests pass

## Architecture

```
init.lua                    # Bootstrap: leader key (;), Lazy.nvim, module loading
lua/
├── editor/                 # Core editor functionality
│   ├── options.lua         # vim.opt settings (tabs=2, numbering, clipboard, providers)
│   ├── keymaps/init.lua    # Global keybindings
│   ├── autocmds.lua        # Autocommands (augroup "vimrc")
│   ├── commands.lua        # User commands
│   ├── explorer.lua        # NERDTree config + keymaps
│   ├── healthcheck.lua     # Deprecation filter (logs to stdpath/logs/)
│   ├── search.lua          # :Rg/:Ack native grep → quickfix
│   ├── telescope.lua       # Fuzzy finder config
│   └── treesitter.lua      # Syntax highlighting + Nord overrides
├── legacy/
│   └── fzf_aliases.lua     # FZF-style command aliases via Telescope
├── lsp/init.lua            # Mason + LSP (vim.lsp.config API) + nvim-cmp setup
├── ui/
│   ├── diagnostics.lua     # Diagnostic styling (Nord colors, CursorHold float)
│   ├── lualine.lua         # (unused — lualine configured in plugins/ui.lua)
│   └── nord.lua            # Theme setup + exported color palette
├── utils/
│   └── safe_require.lua    # (stub)
├── filetypes.lua           # (stub — filetype overrides live in autocmds.lua)
└── plugins/                # Lazy.nvim specs, one file per concern (~40 plugins)
    ├── ai.lua              # Copilot + CodeCompanion
    ├── ale.lua             # ALE linter/fixer configuration
    ├── core.lua            # tpope stack, text objects, Ruby, Git, misc
    ├── explorer.lua        # NERDTree + devicons + git status
    ├── lsp.lua             # lazydev, nvim-lspconfig, nvim-cmp, LuaSnip
    ├── search.lua          # Telescope + fzf-native
    ├── treesitter.lua      # nvim-treesitter, textobjects, autotag, commentstring
    └── ui.lua              # nvim-web-devicons, Nord theme, lualine
after/
├── ftplugin/               # Filetype-specific overrides (vim.lua)
└── plugin/abbreviations.lua # Typo fixes, math constants, language shortcuts
```

## Key Patterns

**Shared Color Palette**: `lua/ui/nord.lua` exports Nord colors used by treesitter, diagnostics, and NERDTree for consistency.

**LSP Servers** (via Mason): ruby_lsp, gopls, lua_ls, vimls. Buffer-local keymaps attached on `on_attach`.

**ALE Linters/Fixers**: Ruby (rubocop), JS/TS (eslint/prettier), Go (golangci-lint/gofmt), Lua (luacheck/stylua), YAML (yamllint/prettier).

**Leader Key**: `;` — used for all custom mappings (`;e` NERDTree, `;ff` grep, `;rn` rename, etc.)

## Configuration Files

- `.luacheckrc` — Neovim-specific globals, ignored rules
- `.stylua.toml` — 100 col, 2-space indent
- `.pre-commit-config.yaml` — Lint hooks
- `.github/workflows/lint.yml` — CI runs luacheck + stylua
- `TODO.md` — Tracked remediation tasks with priority and commit guidance

## Working Guidelines

This is a daily-driver config. Changes must be safe and revertable.

**Before making changes:**
1. Read `TODO.md` for tracked issues and their priorities
2. Understand the change's scope — keymaps affect muscle memory
3. Ask before changing keybindings or removing features

**Making changes:**
- One logical change per commit (easy revert via `git revert`)
- Run `stylua .` before committing
- Test: restart nvim, check `:messages` for errors
- Commit format: `fix(scope): description` or `refactor(scope): description`

**After changes:**
- Mark task complete in `TODO.md` with date and commit hash
- If change affects keymaps, note the new binding in commit message

**Do not:**
- Bundle unrelated fixes in one commit
- Change keybindings without confirming with user
- Remove plugins/features without asking (may be used in workflows not visible in config)
- Skip the verification step — a broken config blocks all work
