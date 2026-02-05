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
│   ├── options.lua         # vim.opt settings (tabs=2, numbering, clipboard)
│   ├── keymaps/init.lua    # Global keybindings
│   ├── autocmds.lua        # Autocommands (augroup "vimrc")
│   ├── settings.lua        # Backup/undo paths, language providers
│   ├── telescope.lua       # Fuzzy finder config
│   ├── nerdtree.lua        # File tree with Nord colors
│   └── treesitter.lua      # Syntax highlighting
├── lsp/init.lua            # Mason + LSP + nvim-cmp setup
├── ui/
│   ├── nord.lua            # Theme + exported color palette
│   └── diagnostics.lua     # Diagnostic styling
└── plugins/
    ├── init.lua            # Lazy.nvim plugin specs (47 plugins)
    └── ale.lua             # ALE linter/fixer configuration
after/
├── ftplugin/               # Filetype-specific overrides
└── plugin/abbreviations.lua # Typo fixes, snippets
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
