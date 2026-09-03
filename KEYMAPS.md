# Neovim Keybindings Reference (2026 Edition)

This document tracks the most important keybindings, focusing on new performance-oriented additions and critical tools for Ruby, Go, and JS development.

## 🚀 Pickers & Convenience (Telescope / Snacks)
*Fast pickers for files, text, buffers, and session helpers.*

| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader><space>` / `<C-p>` | **Find Files** | Fast file search (Telescope) |
| `<leader>,` / `<leader>fb` | **Buffers** | Instant switch between open buffers (Telescope) |
| `<leader>/` / `<leader>fg` | **Live Grep** | Highly optimized project-wide search (Telescope) |
| `<leader>ff` | **Grep → Quickfix** | Native `rg` grep populated into quickfix (`:Ack`, `:Ag`, `:Rg`) |
| `<leader>fr` | **Recent Files** | Browse recently opened files (Telescope) |
| `<leader>fc` | **Find Config** | Find files within `~/.config/nvim` (Telescope) |
| `<leader>:` | **Command History** | Search and re-run recent commands (Telescope) |
| `<leader>gB` | **Git Browse** | Open current line/file in GitHub/GitLab (Snacks) |
| `<leader>n` | **Notifications** | View notification history (Snacks) |
| `<leader>un` | **Dismiss All** | Clear all active notifications (Snacks) |
| `<leader>bd` | **Delete Buffer** | Cleanly close current buffer preserving layout (Snacks) |

## 🛠️ Essential Development Tools

### AI & Code Intelligence
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>aia` | **AI Actions** | CodeCompanion context-aware actions |
| `<leader>aic` | **AI Chat** | CodeCompanion chat (local llama.cpp adapter) |
| `<leader>aiq` | **Ask Local LLM** | Pipe buffer/selection to `ai-query` (injection-safe) |
| `<leader>aiE` | **Explain (Local)** | Explain buffer/selection with the local LLM |
| `<leader>air` | **Review (Local)** | Review buffer/selection for bugs & smells (local) |
| `:Llm {task}` | **Local LLM (range)** | Send buffer/range to local LLM, e.g. `:'<,'>Llm refactor` |
| `Tab` | **Accept** | Accept completion in **Blink.cmp** |
| `C-n` / `C-p` | **Navigate** | Navigate completion list |

> The local LLM is llama.cpp (`http://127.0.0.1:11500`, model alias `local`).
> `<leader>aiq`/`:Llm` route buffer content through `ai-query` in safe-extract
> mode, so untrusted file content can't hijack the prompt. Output opens in a
> floating markdown window (`q`/`<Esc>` to close).

### Git & Diffing
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>gd` | **Diffview Open** | Powerful side-by-side diffing interface |
| `<leader>gD` | **Diffview Close** | Exit diffview mode |
| `<leader>gh` | **File History** | View Git history for the current file |
| `<leader>gC` | **Diff Claude's Change** | Diffview the file Claude Code last touched (`:ClaudeDiff`) |
| `<leader>gB` | **Git Browse** | Open current line/file in GitHub/GitLab |
| `]h` / `[h` | **Next/Prev Hunk** | Jump between Git changes (Gitsigns) |
| `<leader>hs` | **Stage Hunk** | Stage git hunk at cursor (Gitsigns) |
| `<leader>hr` | **Reset Hunk** | Reset git hunk at cursor (Gitsigns) |
| `<leader>hp` | **Preview Hunk** | Floating window with hunk diff (Gitsigns) |

### Navigation & UI
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>a` | **Aerial Toggle** | Code outline (Table of Contents) |
| `s` | **Flash Jump** | Teleport to any visible character |
| `-` | **Oil.nvim** | Open parent directory as a buffer |
| `<leader>e` | **Nvim-Tree** | Toggle file explorer sidebar |
| `<leader>cd` | **Diagnostic Float** | Show diagnostic detail for current line |
| `]d` / `[d` | **Next/Prev Diagnostic** | Jump between diagnostic warnings/errors |
| `<leader>xx` | **Trouble** | Toggle project diagnostics list |
| `<leader>xX` | **Buffer Diagnostics** | Toggle buffer diagnostics in Trouble |

### Testing & Debugging
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>tr` | **Run Nearest** | Run test at cursor (Neotest) |
| `<leader>tf` | **Run File** | Run all tests in the current file |
| `<leader>tl` | **Run Last** | Re-run the last test execution |
| `<leader>ts` | **Test Summary** | Toggle visual test status sidebar |
| `<leader>to` | **Test Output** | Open full test output (floating) |
| `<leader>tO` | **Output Panel** | Toggle persistent output panel |
| `<leader>tS` | **Stop Test** | Cancel running tests |
| `<leader>db` | **Breakpoint** | Toggle DAP breakpoint |
| `<leader>dc` | **Continue** | Start/Continue debugging session |
| `<leader>di` | **Step Into** | Step into function |
| `<leader>do` | **Step Over** | Step over statement |
| `<leader>du` | **Toggle UI** | Toggle DAP UI windows |
| `<leader>dr` | **Open REPL** | Open DAP interactive REPL |
| `<leader>dt` | **Terminate** | Terminate DAP debug session |

### Plugin & Package Management (`vim.pack`)
| Key / Command | Action | Description |
| :--- | :--- | :--- |
| `<leader>L` / `<leader>Pu` | **PackUpdate** | Interactive update with visual changelog review buffer (`:PackUpdate`) |
| `<leader>Ps` | **PackSync** | Synchronize plugins to lockfile revisions (`:PackSync`) |
| `<leader>Pc` | **PackClean** | Prune unmanaged/inactive plugins from disk (`:PackClean`) |
| `<leader>PS` | **PackStatus** | View active plugin count and status overview (`:PackStatus`) |
| `./bin/vdots-update` | **CLI Updater** | Headless update, prune unmanaged, run tests, show diff |
| `./bin/vdots-update -c` | **Update & Commit** | Update, verify tests, and auto-commit `nvim-pack-lock.json` |

### Read Markdown Aloud (`markdown` + preview pane)
*Two-pane reader, macOS `say`. `:help vdots-readaloud`, `:checkhealth vdots.readaloud`.*
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>rr` | **Play from cursor** | Opens the rendered preview vsplit; reads from the block at the cursor |
| `<leader>rp` | **Pause / Resume** | Toggle; resumes by re-reading the block at the cursor |
| `<leader>r]` / `<leader>r[` | **Next / Prev block** | Jump a block and re-read it from the start |
| `<leader>rs` | **Stop** | Halt the voice, keep the panes |
| `<leader>rq` | **Close** | Close the preview pane and tear down |
| `<leader>rf` | **Refresh** | Re-render the preview from the source |
| `<leader>ri` | **Info** | Parse / frontmatter interpretation, chapters, estimate vs `spoken_minutes`, drift |
| `<leader>rx` | **Quick export** | Throwaway `.m4a` of the buffer/range + open player |
| `<leader>rP` | **Publish** | Add doc + read-through to `~/ai/outbox/listen` (`:VdotsReadPublish!` re-records) |

### Editing & Clipboard
*Copy-on-yank model: yanks auto-copy to the system clipboard; deletes never clobber it.*
| Key | Action | Description |
| :--- | :--- | :--- |
| `y` / `yy` | **Copy** | Yanks mirror to the macOS clipboard automatically |
| `<leader>p` / `<leader>P` | **Paste (clipboard)** | Paste from the system clipboard (after/before) |
| `<leader>D` | **Black-hole Delete** | Delete without touching any register |
| `p` *(visual)* | **Paste over** | Replace selection without losing the yank |
| `J` | **Join Lines** | Join lines with next while preserving cursor position (or selection in visual mode) |
| `<A-j>` / `<A-k>` | **Move Lines** | Move line or visual selection down/up with reindent |
| `<C-d>` / `<C-u>` | **Half-page + center** | Scroll keeping the cursor centered |
| `n` / `N` | **Search + center** | Next/prev match, recentered with folds opened |
| `]q` / `[q` | **Quickfix Next/Prev** | Navigate the quickfix list (recentered) |
| `]Q` / `[Q` | **Quickfix Last/First** | Jump to ends of the quickfix list |
| `<leader>xq` | **Toggle Quickfix** | Open/close the quickfix window |

### Claude Code Integration
*Live awareness of a Claude Code session running in this repo.*
| Key / Trigger | Action | Description |
| :--- | :--- | :--- |
| *(automatic)* | **Auto-reload** | Buffers reload when Claude edits them on disk (toast + gitsigns refresh) |
| *(statusline)* | **Session pulse** | `󰭹 claude` pulses while a Claude session is active |
| `<leader>gC` | **Diff last change** | Open Diffview on the file Claude last touched |
| `:NvimUsage` | **Friction report** | Usage/rage telemetry → keymap recommendations |
| `:NvimUsageReset` | **Clear log** | Wipe the local usage log |

### Nvim-Tree (NERDTree compatibility)
*NERDTree muscle memory layered on top of nvim-tree's defaults. These work inside the tree buffer.*

| Key | Action | Notes |
| :--- | :--- | :--- |
| `<leader>ef` | **Reveal current file** | Open tree + focus the current buffer's file (`:NERDTreeFind`) |
| `<leader>er` | **Collapse to current file** | Collapse the tree, then re-reveal the current file |
| `r` | **Refresh tree** | *Override* — NERDTree `r`; rename moved to `<F2>` |
| `<F2>` | **Rename** | Relocated from `r` (`e`=rename basename, `u`=full path still work) |
| `t` | **Open in new tab** | |
| `T` | **Open in tab, stay** | Opens in background tab, keeps cursor in tree |
| `i` | **Open in split** | Horizontal split |
| `go` | **Open, keep cursor** | Opens file but keeps focus in the tree |
| `gi` / `gs` | **Split, keep cursor** | Horizontal / vertical split, focus stays in tree |
| `X` | **Close child nodes** | Collapse all |
| `A` | **Zoom tree** | Toggle wide/normal tree width |
| `?` | **Toggle help** | (nvim-tree's own help is also on `g?`) |
| `o` `<CR>` `q` `K` `J` `P` `R` | *(already match NERDTree)* | Open, close, first/last child, parent, refresh |

**NERDTree-style behaviors (automatic):**
- **Follow** — the tree auto-reveals/highlights the active file as you switch buffers (`update_focused_file`).
- **Directory launch** — `nvim .` (or any dir) cd's there and opens the tree focused.
- **Auto-close** — vim closes if the tree is the last window left.

**NERDTree keys that nvim-tree uses differently** (left as nvim-tree defaults — use the equivalent):
`s`→`<C-v>` or `gs` (vsplit; `s` = system-open) · `p`→`P` (parent; `p` = paste) · `x`→`<BS>` (close dir; `x` = cut) · `I`→`H` (hidden; `I` = git-ignore) · `C`→`<C-]>` (cd; `C` = git-clean filter) · `u`→`-` (up dir) · `O`→`E` (recursive open) · `m`→`a`/`d`/`r`/`c`/`x` (no menu; per-op keys)

## 💎 Ruby & Rails (Chicago-school)
*Optimized for the tightest possible feedback loop.*

### RSpec & Rails Navigation
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>rr` | **A (Alternate)** | Toggle between source and spec |
| `<leader>rv` | **AV (Split)** | Vertical split source and spec |
| `<leader>rc` | **Controller** | Jump to any Rails controller |
| `<leader>rm` | **Model** | Jump to any Rails model |
| `<leader>bi` | **Bundle** | Run `bundle install` |

### Surgical Editing (Tree-sitter)
*Works with operators like `d`, `c`, `y`.*
| Key | Object | Description |
| :--- | :--- | :--- |
| `ib` / `ab` | **Block** | Inner / Around `do...end` or `{...}` |
| `if` / `af` | **Method** | Inner / Around `def...end` |
| `ic` / `ac` | **Class** | Inner / Around `class...end` |
| `]m` / `[m` | **Jump** | Jump to Next / Prev Method |

### ERB & LSP
| Key | Action | Description |
| :--- | :--- | :--- |
| `gd` | **Definition** | Now works **inside gems** and **ERB tags** |
| `<leader>ih` | **Inlay Hints** | Toggle parameter/type hints (Ruby-LSP) |

## 💡 Pro-Tips (Easy to Forget)
*   **ERB Intelligence:** `otter.nvim` provides full LSP support inside `<% ... %>` blocks.
*   **Automatic Tools:** Missing gems like `ruby-lsp` or `standardrb` install on start.
*   **RSpec Macros:** In insert mode, use `desc`, `cont`, and `it` for quick snippets.
*   **Markdown Rendering:** `render-markdown.nvim` is automatic! Just open any `.md` file to see headers, tables, and code blocks rendered beautifully.
