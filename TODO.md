# Neovim Config Remediation Plan

This file tracks configuration issues identified during audit. Each task should be completed as a separate, atomic git commit for easy revert if needed.

## Working Guidelines

- **One logical change per commit** - Don't bundle unrelated fixes
- **Test after each change** - Restart nvim, verify no errors on startup
- **Commit message format** - `fix(scope): description` or `refactor(scope): description`
- **If unsure, ask** - Some changes affect muscle memory; confirm before changing keymaps

---

## P0 - Potential Data Loss

These should be fixed immediately. Each is a one-line change.

### [ ] P0-1: Enable persistent undo
**File:** `lua/editor/options.lua`
**Change:** Add `vim.opt.undofile = true`
**Why:** `undodir` is configured but undo persistence is never enabled. Undo history lost on buffer close.
**Commit:** `fix(options): enable persistent undo`

### [ ] P0-2: Enable backup files
**File:** `lua/editor/options.lua`
**Change:** Add `vim.opt.backup = true`
**Why:** `backupdir` is configured but backups never enabled. No safety net before file overwrites.
**Commit:** `fix(options): enable backup files`

### [ ] P0-3: Fix BufWritePre whitespace trim timing
**File:** `lua/editor/autocmds.lua` (lines 106-118)
**Change:** Remove `vim.schedule()` wrapper from callback body
**Why:** `vim.schedule()` defers execution until after write completes. Whitespace removal never reaches disk.
**Commit:** `fix(autocmds): run whitespace trim before write, not after`

---

## P1 - Broken Functionality

### [ ] P1-1: Fix keymap collision on `<leader>e`
**Files:** `lua/editor/keymaps/init.lua:28`, `lua/lsp/init.lua:26`
**Problem:** Both NERDTreeToggle and diagnostic float mapped to `<leader>e`. LSP wins, tree toggle broken.
**Fix:** Remove `<leader>e` mapping from keymaps/init.lua (line 28). Use `<leader>n` for tree (already defined in nerdtree.lua).
**Note:** Blocked by P3-2 which handles this more comprehensively.
**Commit:** `fix(keymaps): resolve <leader>e collision between NERDTree and LSP`

### [ ] P1-2: Call ui/diagnostics.lua setup()
**File:** `init.lua:59`
**Change:** `require "ui.diagnostics"` → `require("ui.diagnostics").setup()`
**Why:** Module loaded but setup() never called. Nord diagnostic colors and CursorHold float inactive.
**Commit:** `fix(init): call diagnostics setup function`

### [ ] P1-3: Move build="make" to telescope-fzf-native
**File:** `lua/plugins/init.lua` (lines 98-108)
**Change:**
```lua
-- FROM:
dependencies = {
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope-fzf-native.nvim",
},
build = "make",

-- TO:
dependencies = {
  "nvim-lua/plenary.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
},
```
**Post-fix:** Run `:Lazy build telescope-fzf-native.nvim`
**Why:** `build` command on wrong plugin. FZF native extension not compiled.
**Commit:** `fix(plugins): move build command to telescope-fzf-native`

### [ ] P1-4: Add snippet engine for nvim-cmp
**Files:** `lua/plugins/init.lua`, `lua/lsp/init.lua`
**Why:** No snippet engine means LSP completions with placeholders insert malformed text.
**Change:** Add LuaSnip plugin and configure cmp to use it.
**Commit:** `feat(lsp): add LuaSnip snippet engine for completion`

### [ ] P1-5: Define BadWhitespace highlight group
**File:** `lua/ui/nord.lua` (in setup function)
**Change:** Add `vim.api.nvim_set_hl(0, "BadWhitespace", { bg = "#BF616A" })`
**Why:** `autocmds.lua:99` references undefined highlight group.
**Alternative:** Remove the whitespace highlighting feature entirely (autocmds.lua:92-103).
**Commit:** `fix(ui): define BadWhitespace highlight group`

---

## P2 - Double Execution / Race Conditions

### [ ] P2-1: Remove duplicate module requires
**File:** `init.lua` (lines 45, 50, 60)
**Change:** Remove these requires, let lazy.nvim config functions handle loading:
- Line 45: `require "editor.nerdtree"` (also in plugins/init.lua:94)
- Line 50: `require "lsp"` (also in plugins/init.lua:134)
- Line 60: `require "editor.telescope"` (also in plugins/init.lua:106)

**Why:** Double initialization causes highlight re-application, potential autocmd duplication.
**Commit:** `refactor(init): remove duplicate module requires, defer to lazy.nvim`

### [ ] P2-2: Consolidate diagnostic configuration
**Depends on:** P1-2
**Files:** `lua/lsp/init.lua` (lines 76-94), `lua/ui/diagnostics.lua`
**Change:** Remove diagnostic config from lsp/init.lua. Keep ui/diagnostics.lua as single source.
**Why:** Config set twice with conflicts. lsp/init.lua uses deprecated `vim.fn.sign_define`.
**Commit:** `refactor(diagnostics): consolidate config into ui/diagnostics.lua`

### [ ] P2-3: Remove duplicate vim-scripts/align plugin
**File:** `lua/plugins/init.lua`
**Change:** Delete line 185 (`"vim-scripts/align"` under Misc section)
**Why:** Same plugin listed at line 148 and line 185.
**Commit:** `fix(plugins): remove duplicate align plugin entry`

---

## P3 - Redundancy / Cleanup

### [ ] P3-1: Consolidate options.lua and settings.lua
**Files:** `lua/editor/options.lua`, `lua/editor/settings.lua`, `init.lua`
**Why:** Many options set in both files (mouse, tabstop, splitbelow, etc.)
**Change:** Merge unique settings.lua content into options.lua, delete settings.lua, update init.lua.
**Commit:** `refactor(editor): consolidate options.lua and settings.lua`

### [ ] P3-2: Remove duplicate NERDTree keymaps
**Resolves:** P1-1
**File:** `lua/editor/keymaps/init.lua` (lines 27-29)
**Change:** Remove NERDTree mappings from keymaps/init.lua. Keep nerdtree.lua as single source.
**Why:** `<leader>e` and `<leader>ef` defined in both files. Creates collision with LSP.
**Commit:** `refactor(keymaps): centralize NERDTree mappings in nerdtree.lua`

### [ ] P3-3: Fix comment about nvim-tree vs NERDTree
**File:** `init.lua:31`
**Change:** `-- handled by nvim-tree` → `-- handled by NERDTree`
**Why:** Comment mentions wrong plugin.
**Commit:** `docs(init): fix comment to reference NERDTree not nvim-tree`

### [ ] P3-4: Remove duplicate mapleader setting
**File:** `lua/editor/keymaps/init.lua` (lines 6-7)
**Change:** Remove `vim.g.mapleader` and `vim.g.maplocalleader` lines.
**Why:** Already set in init.lua:6-7. Must be set before keymaps, init.lua is correct location.
**Commit:** `refactor(keymaps): remove redundant mapleader setting`

---

## P4 - Best Practices / Optimization

### [ ] P4-1: Add signcolumn for stable gutter
**File:** `lua/editor/options.lua`
**Change:** Add `vim.opt.signcolumn = "yes"`
**Why:** Prevents gutter jumping when diagnostics/signs appear. Important for AI-assisted coding.
**Commit:** `feat(options): add fixed signcolumn for stable gutter`

### [ ] P4-2: Make abbreviations filetype-specific
**File:** `after/plugin/abbreviations.lua` (lines 45-57)
**Why:** Short abbrevs (`re`, `im`, `fu`) fire unexpectedly in prose.
**Options:**
1. Remove programming abbreviations entirely
2. Move to `after/ftplugin/<lang>.lua` with `<buffer>` flag
3. Replace with snippets (requires P1-4)

**Commit:** `refactor(abbrev): scope programming abbreviations to relevant filetypes`

### [ ] P4-3: Audit potentially obsolete plugins
**File:** `lua/plugins/init.lua`
**Review:**
- `ack.vim` - Telescope provides `:Rg`, may be unused
- `vim-textobj-ruby` - Overlaps with `vim-textobj-rubyblock`

**Action:** Check personal usage, remove unused.
**Commit:** `chore(plugins): remove unused plugin X`

### [ ] P4-4: Consider enabling which-key
**File:** `lua/plugins/init.lua` (lines 54-70)
**Why:** With `;` as leader and many keymaps, discovery popup helps.
**Action:** Uncomment and configure. Add `desc` to all keymaps.
**Commit:** `feat(plugins): enable which-key for keymap discovery`

### [ ] P4-5: Add updatetime for faster CursorHold
**File:** `lua/editor/options.lua`
**Change:** Add `vim.opt.updatetime = 250`
**Why:** Default 4000ms makes diagnostic float feel sluggish.
**Commit:** `feat(options): reduce updatetime for faster CursorHold`

---

## Completion Log

Track completed tasks here with date and commit hash:

```
# Example:
# [x] P0-1 - 2024-01-15 - abc1234
```
