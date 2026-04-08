# Neovim Keybindings Reference (2026 Edition)

This document tracks the most important keybindings, focusing on new performance-oriented additions and critical tools for Ruby, Go, and JS development.

## 🚀 New High-Performance Pickers (Snacks.nvim)
*Faster alternatives to Telescope for daily tasks.*

| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader><space>` | **Smart Find** | Intelligently finds files (replaces `<C-p>`) |
| `<leader>,` | **Buffers** | Instant switch between open files |
| `<leader>/` | **Live Grep** | Highly optimized project-wide search |
| `<leader>:` | **Command History** | Search and re-run recent commands |
| `<leader>n` | **Notifications** | View notification history |
| `<leader>un` | **Dismiss All** | Clear all active notifications |
| `<leader>bd` | **Delete Buffer** | Cleanly close current buffer (keeps layout) |

## 🛠️ Essential Development Tools

### AI & Code Intelligence
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>aia` | **AI Actions** | CodeCompanion context-aware actions |
| `<leader>aic` | **AI Chat** | Open a chat interface with Claude/GPT |
| `Tab` | **Accept** | Accept completion in **Blink.cmp** |
| `C-n` / `C-p` | **Navigate** | Navigate completion list |

### Git & Diffing
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>gd` | **Diffview Open** | Powerful side-by-side diffing interface |
| `<leader>gD` | **Diffview Close** | Exit diffview mode |
| `<leader>gh` | **File History** | View Git history for the current file |
| `<leader>gB` | **Git Browse** | Open current line/file in GitHub/GitLab |
| `]h` / `[h` | **Next/Prev Hunk** | Jump between Git changes (Gitsigns) |
| `<leader>hp` | **Preview Hunk** | Floating window with hunk diff |

### Navigation & UI
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>a` | **Aerial Toggle** | Code outline (Table of Contents) |
| `s` | **Flash Jump** | Teleport to any visible character |
| `-` | **Oil.nvim** | Open parent directory as a buffer |
| `<leader>e` | **Nvim-Tree** | Toggle file explorer sidebar |
| `<leader>xx` | **Trouble** | Toggle project diagnostics list |

### Testing & Debugging
| Key | Action | Description |
| :--- | :--- | :--- |
| `<leader>tr` | **Run Nearest** | Run test at cursor (Neotest) |
| `<leader>tf` | **Run File** | Run all tests in the current file |
| `<leader>tl` | **Run Last** | Re-run the last test execution |
| `<leader>ts` | **Test Summary** | Toggle visual test status sidebar |
| `<leader>to` | **Test Output** | Open full test output (floating) |
| `<leader>tO` | **Output Panel** | Toggle persistent output panel |
| `<leader>db` | **Breakpoint** | Toggle DAP breakpoint |
| `<leader>dc` | **Continue** | Start/Continue debugging session |

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
