# Vdots

My Neovim dotfiles.

## Installation

```shell
cd
mkdir -p ~/.local/share/nvim
git clone git@github.com:just3ws/vdots.git ~/.config/nvim
```

## Development

```shell
# Run smoke + unit tests
./test/run.sh

# Lint/format checks
./test/lint.sh

# Apply formatting
stylua .
```

## Keymaps

Leader key is `;`. Because `;` is also mapped to `:` in normal mode,
leader sequences must be typed without delay (or within `timeoutlen`).

**which-key** is active: pause after `;` for ~300 ms and a popup appears showing
all available bindings. Multi-key prefixes are labelled by group:

| Prefix | Group |
| --- | --- |
| `;-` | explorer |
| `;a` | AI |
| `;c` | code |
| `;f` | find |
| `;r` | refactor |

### General

| Key | Action |
| --- | --- |
| `;` | Enter command mode (`:`) |
| `<CR>` | Clear search highlight |
| `n` / `N` | Next / prev match (direction-aware) |
| `j` / `k` | Move by visual line (`gj` / `gk`) |
| `;;` | Select current line (`V`) |
| `Q` | Disabled (prevent accidental Ex mode) |

### Splits & Tabs

| Key | Action |
| --- | --- |
| `<C-h/j/k/l>` | Move between splits |
| `<S-h>` | Previous tab |
| `<S-l>` | Next tab |

### Visual Mode

| Key | Action |
| --- | --- |
| `<` | Indent left, keep selection |
| `>` | Indent right, keep selection |

### Command-line

| Key | Action |
| --- | --- |
| `<C-p>` | Previous history entry |
| `<C-n>` | Next history entry |

### Explorer (NERDTree)

| Key | Action |
| --- | --- |
| `;-e` | Toggle NERDTree |
| `;-ef` | Toggle + reveal current file |
| `;n` | Toggle NERDTree (alias) |
| `;ef` | Toggle + reveal current file (alias) |

### Search & Files

| Key | Action |
| --- | --- |
| `<C-p>` | Telescope: find files |
| `;ff` | Grep prompt → quickfix (ripgrep) |
| `;fF` | Telescope: live grep |
| `;fb` | Telescope: open buffers |
| `;fh` | Telescope: help tags |

### LSP (buffer-local, attached per language server)

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `K` | Hover documentation |
| `gr` | References |
| `;rn` | Rename symbol |
| `;ca` | Code action |
| `[d` / `]d` | Previous / next diagnostic |
| `;e` | Show diagnostic float |
| `;q` | Send diagnostics to location list |

### Completion (nvim-cmp, insert mode)

| Key | Action |
| --- | --- |
| `<C-Space>` | Trigger completion |
| `<CR>` | Confirm selection |
| `<Tab>` | Next item / expand or jump snippet |
| `<S-Tab>` | Previous item / jump back in snippet |
| `<C-b>` / `<C-f>` | Scroll docs up / down |
| `<C-e>` | Abort completion |

### Text Objects

Text objects work in visual mode and with operators (`d`, `c`, `y`, etc.).

#### Ruby files (vim-textobj-rubyblock + vim-textobj-ruby)

| Key | Text object |
| --- | --- |
| `ar` / `ir` | Ruby block (`do…end`, `if…end`, `def…end`, etc.) |
| `af` / `if` | Ruby function |
| `ac` / `ic` | Ruby class |
| `an` / `in` | Ruby name (identifier) |

#### All languages (nvim-treesitter-textobjects)

In Ruby files, `af`/`if` and `ac`/`ic` above take priority.

| Key | Text object |
| --- | --- |
| `af` / `if` | Function outer / inner |
| `ac` / `ic` | Class outer / inner |
| `ab` / `ib` | Block outer / inner |

### Function Navigation (treesitter, normal mode)

| Key | Action |
| --- | --- |
| `]m` | Jump to next function start |
| `]M` | Jump to next function end |
| `[m` | Jump to prev function start |
| `[M` | Jump to prev function end |

### AI

| Key | Action |
| --- | --- |
| `;aa` | CodeCompanion: action menu |
| `;ac` | CodeCompanion: open chat |

### Copilot (insert mode)

| Key | Action |
| --- | --- |
| `<M-CR>` | Accept suggestion |
| `<M-]>` | Next suggestion |
| `<M-[>` | Previous suggestion |
| `<M-\>` | Dismiss suggestion |

### Commands

Config editing shortcuts (all open `$MYVIMRC` or `$ZDOTDIR/.zshenv`):

| Command | Action |
| --- | --- |
| `:Reload` | Re-source `$MYVIMRC` |
| `:Vimrc` / `:Svimrc` / `:Tvimrc` / `:Vvimrc` | Edit / split / tab / vsplit vimrc |
| `:Zshenv` / `:Szshenv` / `:Tzshenv` / `:Vzshenv` | Edit / split / tab / vsplit `.zshenv` |
| `:Rg [query]` | Grep via ripgrep → quickfix |
| `:Ack [query]` | Alias for `:Rg` |
| `:Files` / `:GFiles` | Telescope find files / git files |
| `:Buffers` | Telescope buffer list |
| `:Commits` / `:BCommits` | Telescope git commits / buffer commits |

## Abbreviations

Typo corrections are global (safe in prose). Programming shortcuts are
buffer-local — they only expand in the listed filetypes.

### Typo corrections (all filetypes)

Common misspellings auto-corrected in insert mode: `cant`, `dont`, `wont`,
`teh`, `alos`, `aslo`, `becuase`, `bianry`, `charcter`, `exmaple`, `shoudl`,
`seperate`, `tpyo`, `optino`, `udpate`, `typdef`, `flase`, `taht`, `resposne`.

### Programming shortcuts (filetype-scoped)

| Shortcut | Expands to | Filetypes |
| --- | --- | --- |
| `re` | `return` | Go, Ruby, JavaScript, TypeScript, Lua |
| `fu` | `func` | Go |
| `fun` | `func` | Go |
| `im` | `import` | Go, JavaScript, TypeScript |
| `pa` | `package` | Go |
| `ma` | `main` | Go |
| pu | `public` | Ruby, JavaScript, TypeScript |
| pr | `private` | Ruby, JavaScript, TypeScript |
| it | `it {  }` | Ruby (RSpec) |
| desc | `describe "" do end` | Ruby (RSpec) |
| cont | `context "" do end` | Ruby (RSpec) |

