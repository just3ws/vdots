# Completed Tasks

Tasks completed during the Neovim config remediation. Each entry includes the commit hash for easy revert if needed.

---

## P0 - Potential Data Loss (3/3 Complete)

### [x] P0-1: Enable persistent undo

**Commit:** `e1b06be` - 2025-02-04
**File:** `lua/editor/options.lua`
**Change:** Added `vim.opt.undofile = true`

### [x] P0-2: Enable backup files

**Commit:** `82e9116` - 2025-02-04
**File:** `lua/editor/options.lua`
**Change:** Added `vim.opt.backup = true`

### [x] P0-3: Fix BufWritePre whitespace trim timing

**Commit:** `34c6e22` - 2025-02-04
**File:** `lua/editor/autocmds.lua`
**Change:** Removed `vim.schedule()` wrapper so whitespace trim runs before write

---

## P1 - Broken Functionality (5/5 Complete)

### [x] P1-1: Fix keymap collision on `<leader>e`

**Commit:** `d7731f0` - 2025-02-04 (resolved by P3-2)
**Result:** `<leader>e` now maps to LSP diagnostic, `<leader>n` for NERDTree

### [x] P1-2: Call ui/diagnostics.lua setup()

**Commit:** `fbc88eb` - 2025-02-04
**File:** `init.lua`
**Change:** `require "ui.diagnostics"` → `require("ui.diagnostics").setup()`

### [x] P1-3: Move build="make" to telescope-fzf-native

**Commit:** `9270c5f` - 2025-02-04
**File:** `lua/plugins/init.lua`
**Change:** Moved `build = "make"` into the telescope-fzf-native dependency spec

### [x] P1-4: Add snippet engine for nvim-cmp

**Commit:** `02c389f` - 2025-02-04
**Files:** `lua/plugins/init.lua`, `lua/lsp/init.lua`
**Change:** Added LuaSnip and cmp_luasnip, configured Tab/S-Tab for snippet navigation

### [x] P1-5: Define BadWhitespace highlight group

**Commit:** `31f443b` - 2025-02-04
**File:** `lua/ui/nord.lua`
**Change:** Added `vim.api.nvim_set_hl(0, "BadWhitespace", { bg = "#BF616A" })`

---

## P2 - Double Execution / Race Conditions (3/3 Complete)

### [x] P2-1: Remove duplicate module requires

**Commit:** `ffddb18` - 2025-02-04
**File:** `init.lua`
**Change:** Removed duplicate requires for nerdtree, lsp, telescope (now loaded via lazy.nvim)

### [x] P2-2: Consolidate diagnostic configuration

**Commit:** `2919135` - 2025-02-04
**Files:** `lua/lsp/init.lua`, `lua/ui/diagnostics.lua`
**Change:** Removed diagnostic config from lsp/init.lua, kept ui/diagnostics.lua as single source

### [x] P2-3: Remove duplicate vim-scripts/align plugin

**Commit:** `ef501c8` - 2025-02-04
**File:** `lua/plugins/init.lua`
**Change:** Removed duplicate align plugin entry

---

## P3 - Redundancy / Cleanup (4/4 Complete)

### [x] P3-1: Consolidate options.lua and settings.lua

**Commit:** `a65e5a6` - 2025-02-04
**Files:** `lua/editor/options.lua`, `lua/editor/settings.lua`, `init.lua`
**Change:** Merged all settings into options.lua, deleted settings.lua

### [x] P3-2: Remove duplicate NERDTree keymaps

**Commit:** `d7731f0` - 2025-02-04
**File:** `lua/editor/keymaps/init.lua`
**Change:** Removed NERDTree mappings, centralized in nerdtree.lua

### [x] P3-3: Fix comment about nvim-tree vs NERDTree

**Commit:** `607e5fd` - 2025-02-04
**File:** `init.lua`
**Change:** Fixed comment to say "NERDTree" instead of "nvim-tree"

### [x] P3-4: Remove duplicate mapleader setting

**Commit:** `b2c206a` - 2025-02-04
**File:** `lua/editor/keymaps/init.lua`
**Change:** Removed redundant mapleader setting (already in init.lua)

---

## P5 - Tooling (1/1 Complete)

### [x] P5-1: Fix pre-commit trim-trailing-whitespace hook

**Commit:** `8c029e0` - 2026-02-26
**File:** `.pre-commit-config.yaml`
**Change:** Added `--` argument anchor so `$@` expands to filenames instead of sed reading from stdin

---

## Ad-hoc Fixes (discovered during 2026-02-28 audit)

### [x] Fix treesitter config broken by post-rewrite API change

**Commit:** `1c983b4` - 2026-02-28
**Files:** `lua/editor/treesitter.lua`, `lua/plugins/treesitter.lua`, `test/regression.lua`
**Change:** `nvim-treesitter.configs` was removed in the nvim-treesitter rewrite; the entire
setup was silently no-oping via pcall. Updated to `require("nvim-treesitter").setup()`,
moved `nvim-ts-autotag` to its own config block, fixed regression test.

### [x] Fix Copilot accept/next keymap collision

**Commit:** `be803fc` - 2026-02-28
**File:** `lua/plugins/ai.lua`
**Change:** `accept` and `next` were both bound to `<M-]>`. Fixed `accept` to `<M-CR>`.

### [x] Update CLAUDE.md architecture to match current structure

**Commit:** `390541b` - 2026-02-28
**File:** `CLAUDE.md`
**Change:** Rewrote architecture tree; `settings.lua` → `options.lua`, `nerdtree.lua` →
`explorer.lua`, single `plugins/init.lua` → per-concern files, added missing modules.

### [x] Fix markdownlint errors in skill files

**Commit:** `94e0930` - 2026-02-28
**Files:** `.claude/skills/*.md`
**Change:** Resolved MD022/MD031/MD032 (missing blank lines around headings, fences,
list items) and MD029 (inconsistent ordered list prefix) across all six skill files.

### [x] Add EmmyLua/LuaLS annotations to public module functions

**Commit:** `1cf11eb` - 2026-02-28
**Files:** `lua/editor/search.lua`, `lua/editor/explorer.lua`, `lua/ui/nord.lua`,
`lua/editor/treesitter.lua`
**Change:** Added `---@param`, `---@return`, `---@class`, `---@type` annotations to
public API functions. Read by `lua_ls` (Mason) for hover docs and type checking.

### [x] Fix Nord double-call on startup

**Commit:** `1dfa93e` - 2026-02-28
**Files:** `lua/plugins/ui.lua`, `lua/ui/nord.lua`, `init.lua`
**Change:** `nord.set()` was firing twice: once in the lazy plugin config (before
`vim.g.nord_*` vars were set) and again via `require("ui.nord").setup()` in `init.lua`.
Fixed by moving globals into the plugin's `init` hook, calling `M.setup()` from `config`,
and removing the duplicate call from `init.lua`.

---

## P4 - Best Practices / Optimization (2/5 Complete)

### [x] P4-1: Add signcolumn for stable gutter

**Commit:** `7dcee2d` - 2025-02-04
**File:** `lua/editor/options.lua`
**Change:** Added `vim.opt.signcolumn = "yes"`

### [x] P4-2: Make abbreviations filetype-specific

**Commit:** `39b2fce` - 2026-02-28
**Files:** `after/plugin/abbreviations.lua`, `after/ftplugin/go.lua`,
`after/ftplugin/ruby.lua`, `after/ftplugin/javascript.lua`,
`after/ftplugin/typescript.lua`, `after/ftplugin/lua.lua`
**Change:** Removed global `shortcuts` table (re, fu, fun, im, pa, ma, pu, pr).
Replaced with buffer-local `iabbrev <buffer>` in per-language ftplugin files.
Typo-correction and constant abbreviations remain global.

### [x] P4-4: Enable which-key for keymap discovery

**Commit:** `fbc989e` - 2026-02-28
**File:** `lua/plugins/whichkey.lua` (new), `lua/editor/keymaps/init.lua`
**Change:** Added `folke/which-key.nvim` with 300 ms delay and rounded border.
Registered group labels for leader prefixes: `-` explorer, `a` AI, `c` code,
`f` find, `r` refactor. Added missing `desc` to `<Leader><Leader>`.

### [x] P4-3: Audit and remove obsolete plugins

**Commit:** `69c34b2` - 2026-02-28
**Files:** `lua/plugins/core.lua`, `lua/plugins/treesitter.lua`
**Change:** Full plugin audit. Removed three unused plugins:
`vitalk/vim-shebang` (unmaintained, niche), `windwp/nvim-ts-autotag` and
`JoosepAlviste/nvim-ts-context-commentstring` (web-dev only, no HTML/JSX work).
`ack.vim` was already absent; `vim-textobj-ruby` overlap resolved in prior session.

### [x] P4-5: Add updatetime for faster CursorHold

**Commit:** `e0975a2` - 2025-02-04
**File:** `lua/editor/options.lua`
**Change:** Added `vim.opt.updatetime = 250`
