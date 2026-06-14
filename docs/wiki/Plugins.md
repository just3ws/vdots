# Plugins

All plugins are declared via `vim.pack.add()` in `init.lua`. Configuration lives in `lua/plugins/` or inline in `init.lua`. The lock file is `nvim-pack-lock.json`.

## UI & Theme

| Plugin | Role |
|--------|------|
| `dracula/vim` | Dracula colour scheme (OSS version, active in `init.lua`) |
| `dracula-pro` | Dracula Pro (local path `~/github.com/dracula/Dracula Pro/themes/vim`); provides the lualine palette |
| `nvim-lualine/lualine.nvim` | Status line — dracula-pro themed, shows mode/branch/diff/diagnostics/filename/rails env/location |
| `nvim-tree/nvim-web-devicons` | File-type icons (dependency) |
| `echasnovski/mini.nvim` | `mini.statusline` + `mini.pick` used; provides mini.icons for nvim-tree |
| `folke/snacks.nvim` | Dashboard, picker, notifier, git-browse, words, scope, quickfile, statuscolumn, bigfile, image, scroll, input; priority 1000, never lazy |
| `lukas-reineke/indent-blankline.nvim` | Indent guides (present in `vim.pack.add` but config is commented out) |
| `j-hui/fidget.nvim` | LSP progress spinner (avoids overlapping nvim-tree) |
| `MeanderingProgrammer/render-markdown.nvim` | Renders markdown and CodeCompanion buffers in-editor |
| `folke/which-key.nvim` | Keymap popup after 300 ms delay on `<leader>` |
| `folke/trouble.nvim` | Diagnostics panel, quickfix, loclist |
| `lewis6991/gitsigns.nvim` | Inline blame, hunk navigation/staging |
| `stevearc/aerial.nvim` | Code-outline sidebar |

## Navigation & Files

| Plugin | Role |
|--------|------|
| `stevearc/oil.nvim` | Directory-as-buffer editor; `-` to open parent |
| `nvim-tree/nvim-tree.lua` | File explorer sidebar (width 36, left) |
| `nvim-telescope/telescope.nvim` + `telescope-fzf-native.nvim` | Fuzzy finder with fzf sorter |
| `folke/flash.nvim` | Character-label jump (`s` normal/visual/op, `S` treesitter) |
| `folke/todo-comments.nvim` | TODO/FIXME highlights + Telescope search |

## Editing Primitives (tpope + utilities)

| Plugin | Role |
|--------|------|
| `tpope/vim-surround` | Surround text objects |
| `tpope/vim-commentary` | `gc` comment operator |
| `tpope/vim-repeat` | Repeat plugin maps with `.` |
| `tpope/vim-abolish` | Case-aware substitute + abbreviation |
| `tpope/vim-eunuch` | Shell commands (`:Rename`, `:Move`, `:SudoWrite`, etc.) |
| `wellle/targets.vim` | Extended text objects |
| `vim-scripts/align` | Column alignment |
| `pbrisbin/vim-mkdir` | Auto-create parent dirs on save |

## Treesitter

| Plugin | Role |
|--------|------|
| `nvim-treesitter/nvim-treesitter` | Core parser (`:TSUpdate`); ensures yaml, css, html, js, ts, tsx, svelte, vue, scss, latex, norg, typst, regex |
| `nvim-treesitter/nvim-treesitter-context` | Sticky context header (max 2 lines) |
| `nvim-treesitter/nvim-treesitter-textobjects` | `af`/`if`, `ac`/`ic`, `ab`/`ib`, `]m`/`[m` motions |
| `windwp/nvim-ts-autotag` | Auto-close/rename HTML/JSX tags |
| `JoosepAlviste/nvim-ts-context-commentstring` | Context-aware `gc` in JSX/TSX/Vue |

## Ruby & Rails

| Plugin | Role |
|--------|------|
| `vim-ruby/vim-ruby` | Ruby syntax + indent |
| `tpope/vim-endwise` | Auto-insert `end` |
| `tpope/vim-bundler` | Bundler integration (`:Bundle`) |
| `tpope/vim-rails` | Rails navigation (`:Emodel`, `:Econtroller`, alternate files) |

## LSP & Completion

| Plugin | Role |
|--------|------|
| `neovim/nvim-lspconfig` | LSP server configuration |
| `williamboman/mason.nvim` | LSP/tool installer |
| `williamboman/mason-lspconfig.nvim` | Bridges mason ↔ lspconfig; auto-enables installed servers |
| `WhoIsSethDaniel/mason-tool-installer.nvim` | Ensures non-LSP tools: `debugpy`, `stylua`, `selene`, `goimports`, `golangci-lint` |
| `saghen/blink.cmp` + `rafamaduri/friendly-snippets` | Completion engine (sources: lsp, path, snippets, buffer) |
| `folke/lazydev.nvim` | Neovim API type annotations for Lua files |
| `jmbuhr/otter.nvim` | Embedded language LSP (e.g., Ruby inside ERB `<% %>`) |

## Git

| Plugin | Role |
|--------|------|
| `tpope/vim-fugitive` | Git porcelain (`:Git`, `:Gdiffsplit`, `:Gblame`) |
| `sindrets/diffview.nvim` | Side-by-side diff and file history |
| `tpope/vim-rhubarb` | GitHub integration for fugitive (`:GBrowse`) |

## Testing

| Plugin | Role |
|--------|------|
| `nvim-neotest/neotest` | Test runner framework |
| `olimorris/neotest-rspec` | RSpec adapter (runs via `bundle exec rspec`) |
| `nvim-neotest/neotest-go` | Go adapter (race detection, test tables) |
| `nvim-neotest/nvim-nio` | Async I/O library (neotest dependency) |
| `antoinemadec/FixCursorHold.nvim` | CursorHold performance fix |

## Debugging (DAP)

| Plugin | Role |
|--------|------|
| `mfussenegger/nvim-dap` | Debug Adapter Protocol core |
| `rcarriga/nvim-dap-ui` | DAP UI panels (auto-open on session start) |
| `leoluz/nvim-dap-go` | Go debugger adapter |
| `suketa/nvim-dap-ruby` | Ruby debugger adapter |

## AI

| Plugin | Role |
|--------|------|
| `olimorris/codecompanion.nvim` | AI chat + actions; custom `zdots` chat variable hydrates context from the [zdots Knowledge Layer](https://github.com/just3ws/zdots/wiki/AI-and-Knowledge-Layer) |

## Utilities

| Plugin | Role |
|--------|------|
| `nvim-lua/plenary.nvim` | Lua utility library (shared dependency) |
