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
**Test:**
1. Open a file, make edits, save (`:w`), quit (`:q`)
2. Reopen the same file
3. Press `u` to undo
4. **Expected:** Undo works across sessions, changes revert

### [ ] P0-2: Enable backup files
**File:** `lua/editor/options.lua`
**Change:** Add `vim.opt.backup = true`
**Why:** `backupdir` is configured but backups never enabled. No safety net before file overwrites.
**Commit:** `fix(options): enable backup files`
**Test:**
1. Open an existing file, make edits, save
2. Run: `ls ~/.local/share/nvim/backup/`
3. **Expected:** Backup file exists with `.bak` extension

### [ ] P0-3: Fix BufWritePre whitespace trim timing
**File:** `lua/editor/autocmds.lua` (lines 106-118)
**Change:** Remove `vim.schedule()` wrapper from callback body
**Why:** `vim.schedule()` defers execution until after write completes. Whitespace removal never reaches disk.
**Commit:** `fix(autocmds): run whitespace trim before write, not after`
**Test:**
1. Open a file, add trailing spaces to a line: `hello   ` (with spaces)
2. Save (`:w`)
3. Quit and reopen the file (or `:e %`)
4. **Expected:** Trailing spaces are gone

---

## P1 - Broken Functionality

### [ ] P1-1: Fix keymap collision on `<leader>e`
**Files:** `lua/editor/keymaps/init.lua:28`, `lua/lsp/init.lua:26`
**Problem:** Both NERDTreeToggle and diagnostic float mapped to `<leader>e`. LSP wins, tree toggle broken.
**Fix:** Remove `<leader>e` mapping from keymaps/init.lua (line 28). Use `<leader>n` for tree (already defined in nerdtree.lua).
**Note:** Blocked by P3-2 which handles this more comprehensively.
**Commit:** `fix(keymaps): resolve <leader>e collision between NERDTree and LSP`
**Test:**
1. Open any file
2. Press `<leader>e` (`;e`)
3. **Expected:** NERDTree toggles (not diagnostic float)
4. Verify: `:verbose nmap <leader>e` shows single mapping

### [ ] P1-2: Call ui/diagnostics.lua setup()
**File:** `init.lua:59`
**Change:** `require "ui.diagnostics"` → `require("ui.diagnostics").setup()`
**Why:** Module loaded but setup() never called. Nord diagnostic colors and CursorHold float inactive.
**Commit:** `fix(init): call diagnostics setup function`
**Test:**
1. Open a Lua file with an error (e.g., `local x =` incomplete)
2. Check sign column for diagnostic icon
3. **Expected:** Sign uses Nord red (`#BF616A`), not default red
4. Hover cursor on error line, wait ~1 second
5. **Expected:** Diagnostic float appears automatically (CursorHold)

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
**Test:**
1. Run `:Lazy build telescope-fzf-native.nvim`
2. Press `<C-p>` to open file finder
3. Type a fuzzy query like `plnit` (for `plugins/init`)
4. **Expected:** Matches out-of-order characters (fuzzy), results appear fast
5. Verify: `:Telescope` then check fzf extension loaded (no errors)

### [ ] P1-4: Add snippet engine for nvim-cmp
**Files:** `lua/plugins/init.lua`, `lua/lsp/init.lua`
**Why:** No snippet engine means LSP completions with placeholders insert malformed text.
**Change:** Add LuaSnip plugin and configure cmp to use it.
**Commit:** `feat(lsp): add LuaSnip snippet engine for completion`
**Test:**
1. Open a Go or Lua file
2. Trigger completion for a function (e.g., type `fmt.Print` in Go)
3. Accept a completion that has placeholders (like `Printf`)
4. **Expected:** Snippet expands with placeholders, Tab moves between them
5. If no snippets available: `:LuaSnip` command exists, no errors

### [ ] P1-5: Define BadWhitespace highlight group
**File:** `lua/ui/nord.lua` (in setup function)
**Change:** Add `vim.api.nvim_set_hl(0, "BadWhitespace", { bg = "#BF616A" })`
**Why:** `autocmds.lua:99` references undefined highlight group.
**Alternative:** Remove the whitespace highlighting feature entirely (autocmds.lua:92-103).
**Commit:** `fix(ui): define BadWhitespace highlight group`
**Test:**
1. Open a `.py` or `.c` file
2. Add trailing whitespace to a line
3. **Expected:** Trailing whitespace highlighted with red background
4. Verify: `:hi BadWhitespace` shows the highlight definition

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
**Test:**
1. Restart nvim
2. Run `:messages`
3. **Expected:** No duplicate setup messages, clean startup
4. NERDTree, LSP, Telescope all still work
5. `:autocmd vimrc` shows no duplicate autocmds

### [ ] P2-2: Consolidate diagnostic configuration
**Depends on:** P1-2
**Files:** `lua/lsp/init.lua` (lines 76-94), `lua/ui/diagnostics.lua`
**Change:** Remove diagnostic config from lsp/init.lua. Keep ui/diagnostics.lua as single source.
**Why:** Config set twice with conflicts. lsp/init.lua uses deprecated `vim.fn.sign_define`.
**Commit:** `refactor(diagnostics): consolidate config into ui/diagnostics.lua`
**Test:**
1. Run `:lua print(vim.inspect(vim.diagnostic.config()))`
2. **Expected:** Single consistent config, virtual_text.prefix is "●"
3. No deprecation warnings in `:messages` about sign_define
4. Diagnostic signs still appear with correct icons

### [ ] P2-3: Remove duplicate vim-scripts/align plugin
**File:** `lua/plugins/init.lua`
**Change:** Delete line 185 (`"vim-scripts/align"` under Misc section)
**Why:** Same plugin listed at line 148 and line 185.
**Commit:** `fix(plugins): remove duplicate align plugin entry`
**Test:**
1. Run `:Lazy`
2. Search for "align"
3. **Expected:** Only one entry for align plugin
4. `:Align` command still works

---

## P3 - Redundancy / Cleanup

### [ ] P3-1: Consolidate options.lua and settings.lua
**Files:** `lua/editor/options.lua`, `lua/editor/settings.lua`, `init.lua`
**Why:** Many options set in both files (mouse, tabstop, splitbelow, etc.)
**Change:** Merge unique settings.lua content into options.lua, delete settings.lua, update init.lua.
**Commit:** `refactor(editor): consolidate options.lua and settings.lua`
**Test:**
1. Run: `grep -c "tabstop" lua/editor/*.lua`
2. **Expected:** Only appears in options.lua (count of 1 file)
3. Restart nvim, verify settings work:
   - `:set tabstop?` → 2
   - `:set splitbelow?` → splitbelow
   - `:set clipboard?` → includes unnamedplus
4. No startup errors

### [ ] P3-2: Remove duplicate NERDTree keymaps
**Resolves:** P1-1
**File:** `lua/editor/keymaps/init.lua` (lines 27-29)
**Change:** Remove NERDTree mappings from keymaps/init.lua. Keep nerdtree.lua as single source.
**Why:** `<leader>e` and `<leader>ef` defined in both files. Creates collision with LSP.
**Commit:** `refactor(keymaps): centralize NERDTree mappings in nerdtree.lua`
**Test:**
1. Run `:verbose nmap <leader>n`
2. **Expected:** Shows single definition from nerdtree.lua
3. Run `:verbose nmap <leader>ef`
4. **Expected:** Shows single definition from nerdtree.lua
5. `<leader>e` now only maps to LSP diagnostic (no collision)

### [ ] P3-3: Fix comment about nvim-tree vs NERDTree
**File:** `init.lua:31`
**Change:** `-- handled by nvim-tree` → `-- handled by NERDTree`
**Why:** Comment mentions wrong plugin.
**Commit:** `docs(init): fix comment to reference NERDTree not nvim-tree`
**Test:**
1. Read init.lua line 31
2. **Expected:** Comment says "NERDTree" not "nvim-tree"

### [ ] P3-4: Remove duplicate mapleader setting
**File:** `lua/editor/keymaps/init.lua` (lines 6-7)
**Change:** Remove `vim.g.mapleader` and `vim.g.maplocalleader` lines.
**Why:** Already set in init.lua:6-7. Must be set before keymaps, init.lua is correct location.
**Commit:** `refactor(keymaps): remove redundant mapleader setting`
**Test:**
1. Run: `grep -r "mapleader" lua/`
2. **Expected:** No results (only in init.lua, not in lua/)
3. `:echo mapleader` → `;`
4. Leader-based mappings still work

---

## P4 - Best Practices / Optimization

### [ ] P4-1: Add signcolumn for stable gutter
**File:** `lua/editor/options.lua`
**Change:** Add `vim.opt.signcolumn = "yes"`
**Why:** Prevents gutter jumping when diagnostics/signs appear. Important for AI-assisted coding.
**Commit:** `feat(options): add fixed signcolumn for stable gutter`
**Test:**
1. Open a file with no diagnostics
2. Note the gutter width
3. Add an error (e.g., syntax error in Lua)
4. **Expected:** Gutter does NOT jump/shift when diagnostic sign appears
5. `:set signcolumn?` → yes

### [ ] P4-2: Make abbreviations filetype-specific
**File:** `after/plugin/abbreviations.lua` (lines 45-57)
**Why:** Short abbrevs (`re`, `im`, `fu`) fire unexpectedly in prose.
**Options:**
1. Remove programming abbreviations entirely
2. Move to `after/ftplugin/<lang>.lua` with `<buffer>` flag
3. Replace with snippets (requires P1-4)

**Commit:** `refactor(abbrev): scope programming abbreviations to relevant filetypes`
**Test:**
1. Open a markdown file
2. Type "remark" in insert mode
3. **Expected:** "remark" stays as-is (no "returnmark" flash)
4. Open a Go file
5. Type "re " (re + space)
6. **Expected (if kept):** Expands to "return " in Go files only

### [ ] P4-3: Audit potentially obsolete plugins
**File:** `lua/plugins/init.lua`
**Review:**
- `ack.vim` - Telescope provides `:Rg`, may be unused
- `vim-textobj-ruby` - Overlaps with `vim-textobj-rubyblock`

**Action:** Check personal usage, remove unused.
**Commit:** `chore(plugins): remove unused plugin X`
**Test:**
1. Run `:Lazy profile`
2. **Expected:** Removed plugins no longer appear
3. Verify no features broken by removal (test `:Ack` if kept, Ruby text objects if kept)

### [ ] P4-4: Consider enabling which-key
**File:** `lua/plugins/init.lua` (lines 54-70)
**Why:** With `;` as leader and many keymaps, discovery popup helps.
**Action:** Uncomment and configure. Add `desc` to all keymaps.
**Commit:** `feat(plugins): enable which-key for keymap discovery`
**Test:**
1. Press `<leader>` (`;`) and wait 500ms
2. **Expected:** Popup appears showing available mappings (e, n, ff, fb, etc.)
3. Press a key shown in popup
4. **Expected:** Mapping executes correctly

### [ ] P4-5: Add updatetime for faster CursorHold
**File:** `lua/editor/options.lua`
**Change:** Add `vim.opt.updatetime = 250`
**Why:** Default 4000ms makes diagnostic float feel sluggish.
**Commit:** `feat(options): reduce updatetime for faster CursorHold`
**Test:**
1. Open file with LSP diagnostics
2. Move cursor to line with error, stop moving
3. Count seconds until diagnostic float appears
4. **Expected:** Float appears in ~0.25 seconds (not 4 seconds)
5. `:set updatetime?` → 250

---

## P5 - Tooling Issues

### [ ] P5-1: Fix pre-commit trim-trailing-whitespace hook
**File:** `.pre-commit-config.yaml`
**Problem:** Hook fails with `sed: -I or -i may not be used with stdin` on non-Lua files.
**Impact:** Must use `--no-verify` for JSON, gitignore commits.
**Fix:** Update hook config or use a different trailing whitespace trimmer.
**Commit:** `fix(pre-commit): use compatible trailing whitespace hook`
**Test:**
1. Modify `.gitignore` or `lazy-lock.json`
2. Run `git add <file> && git commit -m "test"`
3. **Expected:** Pre-commit hooks pass without sed error
4. No need for `--no-verify`

---

## Smoke Test Script

Run after any change to verify overall health:

```bash
# Startup without errors
nvim --headless -c 'if v:errmsg != "" | cq | endif' -c 'qa'
echo "Startup: OK"

# Verify critical options (after P0 fixes)
nvim --headless -c 'lua if not vim.o.undofile then os.exit(1) end' -c 'qa' && echo "undofile: OK"
nvim --headless -c 'lua if not vim.o.backup then os.exit(1) end' -c 'qa' && echo "backup: OK"
nvim --headless -c 'lua if vim.o.signcolumn ~= "yes" then os.exit(1) end' -c 'qa' && echo "signcolumn: OK"
```

---

## Completion Log

Track completed tasks here with date and commit hash:

```
# [x] P0-1 - 2024-01-15 - abc1234
```
