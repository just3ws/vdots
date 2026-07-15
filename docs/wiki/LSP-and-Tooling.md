# LSP and Tooling

Language servers are configured with `vim.lsp.config()` and enabled with `vim.lsp.enable()` (Neovim 0.12 native API). Completion is provided by blink.cmp. Formatting runs on save via conform.nvim; linting triggers on `BufEnter`, `BufWritePost`, and `InsertLeave` via nvim-lint. No Mason — all server binaries resolve from PATH (mise shims / Homebrew); Ruby servers are global gems managed by mise.

## Language Servers

All enabled via `vim.lsp.enable()` in init.lua; binaries come from PATH.

| Server | Language | Notes |
|--------|----------|-------|
| `ruby_lsp` | Ruby | `formatter = "auto"`; inlay hints toggle via `<leader>ih` |
| `standardrb` | Ruby | Runs alongside ruby_lsp |
| `gopls` | Go | `usePlaceholders`, `completeUnimported`, `unusedparams` |
| `lua_ls` | Lua | `globals = {"vim"}`, `checkThirdParty = false` |
| `basedpyright` | Python | Default config |
| `yamlls` | YAML | `keyOrdering = false` |
| `terraformls` | Terraform | Default config |

## Completion

**blink.cmp** (`saghen/blink.cmp`, vim.pack with a `1.*` version range for the prebuilt fuzzy lib) with sources: `lsp`, `path`, `snippets`, `buffer`. blink registers its LSP capabilities automatically.

`completeopt` is set to `menuone,noselect,noinsert`; `omnifunc` falls back to `vim.lsp.omnifunc` for manual `<C-x><C-o>`.

## Embedded Language LSP

**otter.nvim** provides LSP support inside embedded code blocks (e.g., Ruby inside ERB `<% %>` tags). Configured in `lua/plugins.lua`.

## LSP Keymaps (buffer-local, set on LspAttach)

| Key | Action |
|-----|--------|
| `gd` | Definition |
| `K` | Hover |
| `gr` | References |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` / `]d` | Previous / next diagnostic (Neovim default) |
| `<leader>ih` | Toggle inlay hints (ruby_lsp only) |

## Formatters (conform.nvim, on save)

| Filetype | Formatter(s) | Notes |
|----------|-------------|-------|
| Lua | `stylua` | |
| Ruby | `standardrb` → `rubocop` | `stop_after_first` |
| Go | `goimports` then `gofmt` | Both run in sequence |
| JavaScript | `prettierd` → `prettier` | `stop_after_first` |
| TypeScript | `prettierd` → `prettier` | `stop_after_first` |

Format-on-save timeout: 500 ms; LSP fallback enabled.

Format manually: `<leader>f` (any mode).

## Linters (nvim-lint)

| Filetype | Linter(s) |
|----------|----------|
| Lua | `selene` |
| Ruby | `rubocop` |
| Go | `golangcilint` |
| JavaScript | `eslint_d` → `eslint` |
| TypeScript | `eslint_d` → `eslint` |

## CLI Tooling

Formatters, linters, and DAP adapters (`stylua`, `selene`, `goimports`, `golangci-lint`, `debugpy`, …) are installed via mise/Homebrew and resolved from PATH — nothing inside Neovim manages them.

## Runtime Providers

Configured in `lua/editor/options.lua`:

- **Ruby**: `neovim-ruby-host` via mise shims; disabled if not found
- **Python**: `python3` via mise shims (requires `pynvim` or `neovim` module); disabled if absent
- **Node**: disabled (`g.loaded_node_provider = 0`)
- **Perl**: disabled

PATH inside Neovim prepends `~/.local/share/mise/shims` and `/opt/homebrew/opt/openjdk/bin`; `JAVA_HOME` is set if the Homebrew OpenJDK directory exists.
