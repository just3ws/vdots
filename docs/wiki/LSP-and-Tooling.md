# LSP and Tooling

Language servers are configured with `vim.lsp.config()` and enabled with `vim.lsp.enable()` (Neovim 0.12 native API). Completion is provided by blink.cmp. Formatting runs on save via conform.nvim; linting triggers on `BufEnter`, `BufWritePost`, and `InsertLeave` via nvim-lint. Mason manages non-Ruby tooling; Ruby servers are global gems managed by mise.

## Language Servers

| Server | Language | Manager | Notes |
|--------|----------|---------|-------|
| `ruby_lsp` | Ruby | global gem (mise) | `formatter = "auto"`; inlay hints toggle via `<leader>ih` |
| `standardrb` | Ruby | global gem (mise) | Runs alongside ruby_lsp |
| `gopls` | Go | Mason auto-enable | `usePlaceholders`, `completeUnimported`, `unusedparams` |
| `lua_ls` | Lua | Mason (`ensure_installed`) | `globals = {"vim"}`, `checkThirdParty = false` |
| `vimls` | Vimscript | Mason (`ensure_installed`) | Default config |
| `stylelint_lsp` | CSS/SCSS | Mason (`ensure_installed`) | Default config |
| `basedpyright` | Python | `vim.lsp.enable()` in init.lua | Default config |
| `yamlls` | YAML | `vim.lsp.enable()` in init.lua | `keyOrdering = false` |
| `terraformls` | Terraform | `vim.lsp.enable()` in init.lua | Default config |

Ruby servers (`ruby_lsp`, `standardrb`) are intentionally excluded from Mason — they are installed as global gems via mise post-install hooks. If they were previously installed via Mason, run `:MasonUninstall ruby-lsp standardrb` to remove the stale binaries.

## Completion

**blink.cmp** (`saghen/blink.cmp`) with sources: `lsp`, `path`, `snippets`, `buffer`. Snippet corpus from `friendly-snippets`. Capabilities are registered globally via `vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })`.

`completeopt` is set to `menuone,noselect,noinsert`. A native `InsertCharPre` autocmd triggers omnifunc (`<C-x><C-o>`) when typing word characters, `.`, or `/` outside an active menu.

## Embedded Language LSP

**otter.nvim** provides LSP support inside embedded code blocks (e.g., Ruby inside ERB `<% %>` tags). Configured in `lua/plugins/ai_erb.lua`.

## LSP Keymaps (buffer-local, set on LspAttach)

| Key | Action |
|-----|--------|
| `gd` | Definition |
| `K` | Hover |
| `gr` | References |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>d` | Diagnostic float |
| `<leader>q` | Diagnostics → location list |
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

## Mason-managed Tools

Mason (`mason-tool-installer`) ensures these non-LSP binaries are installed and kept current:

| Tool | Purpose |
|------|---------|
| `debugpy` | Python DAP adapter |
| `stylua` | Lua formatter |
| `selene` | Lua linter |
| `goimports` | Go import organiser + formatter |
| `golangci-lint` | Go lint aggregator |

## Runtime Providers

Configured in `lua/editor/options.lua`:

- **Ruby**: `neovim-ruby-host` via mise shims; disabled if not found
- **Python**: `python3` via mise shims (requires `pynvim` or `neovim` module); disabled if absent
- **Node**: disabled (`g.loaded_node_provider = 0`)
- **Perl**: disabled

PATH inside Neovim prepends `~/.local/share/mise/shims` and `/opt/homebrew/opt/openjdk/bin`; `JAVA_HOME` is set if the Homebrew OpenJDK directory exists.
