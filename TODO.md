# Neovim Config Remediation Plan

Remaining tasks for the configuration audit. Completed tasks are in [TODONE.md](TODONE.md).

## Working Guidelines

- **One logical change per commit** - Don't bundle unrelated fixes
- **Test after each change** - Run `./test/run.sh`, restart nvim, verify no errors
- **Commit message format** - `fix(scope): description` or `refactor(scope): description`
- **If unsure, ask** - Some changes affect muscle memory; confirm before changing keymaps
- **When done** - Move task to TODONE.md with commit hash

---

## P4 - Best Practices / Optimization

### [ ] P4-2: Make abbreviations filetype-specific
**File:** `after/plugin/abbreviations.lua` (lines 45-57)
**Why:** Short abbrevs (`re`, `im`, `fu`) fire unexpectedly in prose.
**Options:**
1. Remove programming abbreviations entirely
2. Move to `after/ftplugin/<lang>.lua` with `<buffer>` flag
3. Replace with snippets (LuaSnip now available)

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
3. Verify no features broken by removal

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

---

## Summary

| Priority | Status | Remaining |
|----------|--------|-----------|
| P0 - Data Loss | ✓ Complete | 0 |
| P1 - Broken Functionality | ✓ Complete | 0 |
| P2 - Double Execution | ✓ Complete | 0 |
| P3 - Redundancy | ✓ Complete | 0 |
| P4 - Best Practices | 2/5 done | 3 |
| P5 - Tooling | ✓ Complete | 0 |
| Ad-hoc (2026-02-28 audit) | ✓ Complete | 0 |

**Total: 24 completed, 3 remaining**
