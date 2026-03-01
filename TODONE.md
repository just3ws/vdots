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

---

## P4 - Best Practices / Optimization (2/5 Complete)

### [x] P4-1: Add signcolumn for stable gutter

**Commit:** `7dcee2d` - 2025-02-04
**File:** `lua/editor/options.lua`
**Change:** Added `vim.opt.signcolumn = "yes"`

### [x] P4-5: Add updatetime for faster CursorHold

**Commit:** `e0975a2` - 2025-02-04
**File:** `lua/editor/options.lua`
**Change:** Added `vim.opt.updatetime = 250`
