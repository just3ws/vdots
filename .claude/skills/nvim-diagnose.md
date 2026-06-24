---
name: nvim-diagnose
description: Full diagnose loop for Neovim issues — omnifunc freakouts, LSP crashes, plugin errors. Reads errors.jsonl for context, then runs structured diagnosis. Use when the user says "diagnose", "debug nvim", "why does X error", or after nvim-errors surfaces a recurring bucket.
---

# nvim-diagnose — Neovim issue diagnosis

Follows the same discipline as `/diagnose` but scoped to vdots. Always start
from the error log; never guess the cause before reading evidence.

## Phase 0 — Load evidence

Run `/nvim-errors` first (or read errors.jsonl directly) to get the error
bucket you're diagnosing. If no log entry exists for the symptom, ask the
user to reproduce while the log is active.

## Phase 1 — Classify the error source

Determine which layer produced the error:

| Layer | Signals |
|-------|---------|
| **LSP server** | msg contains server name (`ruby_lsp`, `gopls`); ctx.lsp non-empty |
| **blink.cmp / completion** | msg mentions `omnifunc`, `complete`, `E367`, `E363` |
| **Plugin Lua** | stack trace with `lua/plugins/` path |
| **Neovim core** | `E` error codes (E486, E37…), vim.api stack |
| **editor/ module** | stack trace with `lua/editor/` path |

## Phase 2 — Build a feedback loop

For LSP/omnifunc errors:
```bash
# Check LSP log for the server in question
cat ~/.local/state/nvim/lsp.log | grep -i "error\|warn" | tail -50

# Check server health
nvim --headless -c "checkhealth ruby_lsp" -c "silent! write! /tmp/health.txt" -c "qa!" 2>&1
cat /tmp/health.txt
```

For plugin Lua errors — reproduce headlessly:
```bash
timeout 30 nvim --headless -u init.lua \
  -c "edit /tmp/test.rb" \
  -c "lua vim.lsp.buf.hover()" \
  -c "qa!" 2>&1
```

For blink.cmp / omnifunc specifically:
```bash
# Confirm omnifunc is NOT set to lsp.omnifunc (blink owns completion)
nvim --headless -u init.lua \
  -c "edit /tmp/test.rb" \
  -c "lua print(vim.bo.omnifunc)" \
  -c "qa!" 2>&1
```

## Phase 3 — Narrow to a file:line

1. If a Lua stack trace is present in the error message, go directly to that file.
2. If not, grep for the error string across lua/:
   ```bash
   grep -r "ERROR_PATTERN" /Users/mike.hall/.config/nvim/lua/
   ```
3. Check the `ctx.diagnostics` field from the log — active diagnostics at error
   time often point at the root cause (e.g. a syntax error in the file being edited).

## Phase 4 — Fix

- **LSP crash**: restart with `:LspRestart`, check server binary version, check
  root_dir detection.
- **omnifunc conflict**: if `vim.bo.omnifunc` is set to `v:lua.vim.lsp.omnifunc`
  somewhere, remove it — blink.cmp manages completion.
- **Plugin Lua error**: fix the Lua bug; wrap in `pcall` only if the call site
  is inherently fallible (network, file I/O).
- **Noise / benign**: add a filter in `errors.lua`:
  ```lua
  -- in errors.lua setup(), before the io.open write:
  if msg:find("PATTERN_TO_SUPPRESS") then return _orig_notify(msg, level, opts) end
  ```

## Phase 5 — Verify

```bash
# Clear the log, reproduce, check count dropped to 0
echo -n "" > ~/.local/state/nvim/errors.jsonl
# ... reproduce the scenario ...
wc -l ~/.local/state/nvim/errors.jsonl
```

## Checklist for omnifunc specifically

- [ ] `vim.bo.omnifunc` is empty or `""` in Ruby/Go buffers (blink handles it)
- [ ] No `vim.opt.omnifunc` set globally
- [ ] No `after/ftplugin/*.vim` setting `omnifunc`
- [ ] `ruby_lsp` attaches cleanly (`checkhealth ruby_lsp` green)
- [ ] blink.cmp sources list does not include a broken custom source
