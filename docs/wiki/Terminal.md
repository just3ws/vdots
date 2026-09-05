# Terminal

vdots ships an ergonomic terminal layer built on top of `Snacks.terminal`
(`folke/snacks.nvim`). The goal: a terminal that behaves like a normal split,
where you never have to remember a modal escape chord.

Source: [`lua/editor/terminal.lua`](../../lua/editor/terminal.lua)  
Loaded from: `init.lua` via `require("editor.terminal").setup()`

---

## Quick Reference

| Key | Mode | Action |
|-----|------|--------|
| `<C-/>` | normal, terminal | Toggle main terminal (same key opens and hides) |
| `<C-1>` | normal, terminal | Toggle terminal slot 1 (alias for main) |
| `<C-2>` | normal, terminal | Toggle terminal slot 2 |
| `<C-3>` | normal, terminal | Toggle terminal slot 3 |
| `<Esc><Esc>` | terminal | Exit terminal mode → normal mode |
| `<C-h>` | terminal | Move focus to the split on the left |
| `<C-j>` | terminal | Move focus to the split below |
| `<C-k>` | terminal | Move focus to the split above |
| `<C-l>` | terminal | Move focus to the split on the right |

---

## Named Slots

The three slots (`<C-1>` / `<C-2>` / `<C-3>`) are fully independent terminals.
Each has a persistent shell session: toggling one closed does not kill its
process; reopening it reconnects to the same shell.

Suggested workflow for a pnpm monorepo:

| Slot | Suggested use |
|------|--------------|
| 1 (`<C-/>` or `<C-1>`) | General / ad-hoc shell |
| 2 (`<C-2>`) | `pnpm dev:server` |
| 3 (`<C-3>`) | `pnpm dev:client` |

---

## Window Style

Terminals open as a **bottom split**, 35 % of screen height, with a rounded
border and a `NormalFloat` background. Window-local options that Neovim normally
shows (line numbers, sign column, status column, winbar) are suppressed so the
terminal surface stays clean.

To change the height, edit `TERM_WIN.height` in `lua/editor/terminal.lua`.

---

## Auto-insert

When you switch focus into any terminal buffer — whether via `<C-j/k>` or a
mouse click — Neovim automatically enters insert (terminal) mode. You can start
typing immediately without pressing `i`.

This is implemented via a `BufEnter` / `WinEnter` autocmd on `term://*` in the
`vimrc_terminal` augroup.

---

## `<C-/>` Doesn't Work?

Some terminal emulators (e.g. older versions of iTerm2, Alacritty with certain
configs) send `<C-_>` instead of `<C-/>`. If toggling doesn't respond:

1. Run `:verbose map <C-/>` — if the map is missing, your emulator is sending a
   different chord.
2. Change both occurrences of `"<C-/>"` in `lua/editor/terminal.lua` to
   `"<C-_>"`.

---

## Integration with DAP

The DAP UI (`:DapToggleUI` / `<leader>du`) opens its own terminal-like panels
using `nvim-dap-ui`. The `TermOpen` autocmd in `terminal.lua` also applies to
those panels, suppressing line numbers and the sign column there too.

---

## All Terminal Buffers (not just Snacks)

The `TermOpen` autocmd fires for **every** `:terminal` buffer Neovim creates,
including raw `:split | terminal`, the DAP console, and neotest output. This
means you get the clean window-option treatment everywhere, not just in the
Snacks-managed slots.
