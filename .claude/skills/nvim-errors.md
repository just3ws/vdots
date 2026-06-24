---
name: nvim-errors
description: Triage the Neovim error log. Reads ~/.local/state/nvim/errors.jsonl, groups by pattern, surfaces top offenders with diagnostic context. Use when the user says "check errors", "triage errors", "what errors", or "show nvim errors".
---

# nvim-errors — Triage the Neovim error log

## Log location

```bash
~/.local/state/nvim/errors.jsonl   # one JSON object per line
```

Each entry:
```json
{"ts": 1234567890, "lvl": "error", "msg": "...", "ctx": {"ft": "ruby", "lsp": ["ruby_lsp"], "diagnostics": ["ERROR:12 ..."]}}
```

## Steps

### 1. Read and parse

```bash
cat ~/.local/state/nvim/errors.jsonl | jq -s 'sort_by(.ts) | reverse'
```

If the file is missing or empty, say so and stop — no errors logged yet.

### 2. Group by message pattern

Bucket entries by the first ~60 chars of `msg` to find repeating patterns.
Show counts per bucket, most frequent first.

### 3. Surface context

For the top 5 buckets, show:
- Representative message (full)
- Filetypes where it appeared
- LSP clients active at the time
- Any diagnostics present in the buffer

### 4. Classify each bucket

| Class | Meaning |
|-------|---------|
| `omnifunc` | LSP/completion errors during insert mode (the original complaint) |
| `lsp-startup` | Server failed to attach or crashed |
| `plugin` | Error from a specific plugin (grep msg for source) |
| `vim-api` | Neovim API misuse — file:line usually present |
| `noise` | Benign, expected, can be suppressed |

### 5. Output

- Summary table: bucket / count / class / first-seen / last-seen
- For `omnifunc` and `lsp-startup` buckets: recommend next step (see diagnose skill)
- For `noise` buckets: suggest a `vim.notify` filter to silence them
- Total entries, time range covered, unique filetypes affected

## Quick filters (run directly if user asks)

```bash
# only errors, last 24h (ts > now-86400)
jq --argjson since "$(( $(date +%s) - 86400 ))" 'select(.ts > $since and .lvl == "error")' \
  ~/.local/state/nvim/errors.jsonl

# omnifunc hits only
grep -i "omnifunc\|E367\|completion" ~/.local/state/nvim/errors.jsonl | jq .

# by filetype
jq 'select(.ctx.ft == "ruby")' ~/.local/state/nvim/errors.jsonl
```
