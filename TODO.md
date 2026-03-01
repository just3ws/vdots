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
| -------- | ------ | --------- |
| P0 - Data Loss | ✓ Complete | 0 |
| P1 - Broken Functionality | ✓ Complete | 0 |
| P2 - Double Execution | ✓ Complete | 0 |
| P3 - Redundancy | ✓ Complete | 0 |
| P4 - Best Practices | 4/5 done | 1 |
| P5 - Tooling | ✓ Complete | 0 |
| Ad-hoc (2026-02-28 audit) | ✓ Complete | 0 |

Total: 29 completed, 1 remaining
