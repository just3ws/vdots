# Keymaps

Leader key is `;`. In normal mode `;` is also mapped to `:` (enter command mode), so leader sequences must be typed within `timeoutlen`. Pause after `;` for ~300 ms and which-key shows available bindings grouped by prefix.

## which-key Groups

| Prefix | Group |
|--------|-------|
| `<leader>ai` | AI |
| `<leader>b` | buffer |
| `<leader>c` | code |
| `<leader>d` | debug |
| `<leader>e` | explorer |
| `<leader>f` | find / format |
| `<leader>g` | git |
| `<leader>h` | git hunks |
| `<leader>n` | notifications |
| `<leader>P` | plugins |
| `<leader>s` | search |
| `<leader>t` | test |
| `<leader>u` | ui / toggle |
| `<leader>w` | window |
| `<leader>q` | quit |
| `<leader>x` | diagnostics (Trouble) |

## General

| Key | Action |
|-----|--------|
| `;` | Enter command mode (`:`) |
| `<CR>` | Clear search highlight |
| `n` / `N` | Next / prev match (direction-aware) |
| `j` / `k` | Move by visual line (`gj` / `gk`) |
| `;;` | Select current line (`V`) |
| `Q` | Disabled (prevents accidental Ex mode) |

## Splits & Tabs

| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move between splits |
| `<S-h>` | Previous tab |
| `<S-l>` | Next tab |

## Visual Mode

| Key | Action |
|-----|--------|
| `<` | Indent left, keep selection |
| `>` | Indent right, keep selection |

## Config Shortcuts

| Key | Action |
|-----|--------|
| `<leader>vr` | Reload config (`:source $MYVIMRC`) |
| `<leader>ve` | Edit config (`:edit $MYVIMRC`) |

## Navigation

| Key | Action |
|-----|--------|
| `s` | Flash jump (any visible char, normal/visual/op) |
| `S` | Flash treesitter jump |
| `-` | Open parent directory (Oil) |
| `<leader>e` | Toggle nvim-tree sidebar |
| `<leader>a` | Toggle Aerial (code outline) |

## Search & Pickers (Snacks)

| Key | Action |
|-----|--------|
| `<leader><space>` | Smart find files |
| `<leader>,` | Buffer list |
| `<leader>/` | Live grep |
| `<leader>:` | Command history |
| `<leader>n` | Notification history |
| `<leader>un` | Dismiss all notifications |
| `<leader>bd` | Delete buffer (keeps layout) |

## Search (Telescope)

| Key | Action |
|-----|--------|
| `<C-p>` | Find files |
| `<leader>ff` | Grep → quickfix (ripgrep) |
| `<leader>fF` | Live grep |
| `<leader>fb` | Open buffers |
| `<leader>fh` | Help tags |

## Git

| Key | Action |
|-----|--------|
| `<leader>gd` | Diffview open |
| `<leader>gD` | Diffview close |
| `<leader>gh` | File history (Diffview) |
| `<leader>gC` | Diff file Claude Code last touched (`:ClaudeDiff`) |
| `<leader>gB` | Git browse (open in GitHub) |
| `]h` / `[h` | Next / prev hunk (Gitsigns) |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hp` | Preview hunk |

## LSP (buffer-local, set on LspAttach)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `gr` | References |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>cd` | Diagnostic float (current line) |
| `<leader>ih` | Toggle inlay hints (ruby_lsp only) |

## Plugin & Package Management (`vim.pack`)

| Key / Command | Action |
|---------------|--------|
| `<leader>L` / `<leader>Pu` | Interactive plugin update review buffer (`:PackUpdate`) |
| `<leader>Ps` | Sync plugins to lockfile (`:PackSync`) |
| `<leader>Pc` | Prune unmanaged/inactive plugins from disk (`:PackClean`) |
| `<leader>PS` | Active plugin status toast (`:PackStatus`) |
| `./bin/vdots-update` | CLI script: update, clean, test, diff |
| `./bin/vdots-update -c` | CLI script: update, test, and auto-commit |

## Formatting & Diagnostics

| Key | Action |
|-----|--------|
| `<leader>f` | Format buffer (conform.nvim, any mode) |
| `<leader>xx` | Trouble diagnostics toggle |
| `<leader>xX` | Trouble buffer diagnostics |
| `<leader>cs` | Trouble symbols |
| `<leader>cl` | Trouble LSP definitions/references |
| `<leader>xL` | Trouble location list |
| `<leader>xQ` | Trouble quickfix |

## Testing (Neotest)

| Key | Action |
|-----|--------|
| `<leader>tr` | Run nearest test |
| `<leader>tf` | Run all tests in file |
| `<leader>tl` | Re-run last test |
| `<leader>ts` | Toggle test summary sidebar |
| `<leader>to` | Show test output (float) |
| `<leader>tO` | Toggle persistent output panel |
| `<leader>tS` | Stop test run |

## Debugging (DAP)

| Key | Action |
|-----|--------|
| `<leader>db` | Toggle breakpoint |
| `<leader>dc` | Continue |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>du` | Toggle DAP UI |
| `<leader>dr` | Open REPL |
| `<leader>dt` | Terminate session |

## AI & Local LLM

| Key | Action |
|-----|--------|
| `<leader>aia` | CodeCompanion action menu |
| `<leader>aic` | CodeCompanion chat |
| `<leader>aiq` | Local LLM query on buffer / selection |
| `<leader>aiE` | Local LLM explain buffer / selection |
| `<leader>air` | Local LLM review buffer / selection |
| `:Llm {task}` | Local LLM command |

## zdots Platform Integration

| Key / Command | Action |
|---------------|--------|
| `<leader>zi` | Ingest current buffer into zdots context engine |
| `<leader>zt` | Open interactive task picker (ztask) |
| `:ZdotsIngest` | Same as `<leader>zi` |
| `:ZdotsStatus` | zdots platform status in a floating window |

## Todo Comments

| Key | Action |
|-----|--------|
| `]t` | Next todo comment |
| `[t` | Previous todo comment |
| `<leader>st` | Search todos (Telescope) |

## Treesitter Text Objects

| Key | Object |
|-----|--------|
| `af` / `if` | Function outer / inner |
| `ac` / `ic` | Class outer / inner |
| `ab` / `ib` | Block outer / inner |
| `]m` / `[m` | Jump to next / prev function start |
| `]M` / `[M` | Jump to next / prev function end |

## Commands

| Command | Action |
|---------|--------|
| `:Ack [query]` | Ripgrep search into quickfix list |
| `:Ag [query]` | Ripgrep search into quickfix list |
| `:Rg [query]` | Ripgrep search into quickfix list |
| `:PackUpdate` | Interactive plugin update review buffer |
| `:PackSync` | Sync plugins to lockfile revisions |
| `:PackClean` | Prune unmanaged plugins from disk |
| `:PackStatus` | Display active plugin summary toast |
| `:ClaudeDiff` | Diff the file Claude Code last touched |
| `:NvimUsage` | Display typing telemetry & friction report |
| `:NvimErrors` | Open recent error log with diagnostic context |
| `:Reload` | Re-source `$MYVIMRC` |
| `:Vimrc` / `:Svimrc` / `:Tvimrc` / `:Vvimrc` | Edit / split / tab / vsplit vimrc |
| `:Zshenv` / `:Szshenv` / `:Tzshenv` / `:Vzshenv` | Edit / split / tab / vsplit `.zshenv` |
| `:ZdotsIngest` | Ingest current buffer into zdots |
| `:ZdotsStatus` | Platform status float |
| `:ConformInfo` | Show conform.nvim formatter info |
