# LSP and Tooling

Language servers are configured with `vim.lsp.config()` and enabled with `vim.lsp.enable()` (Neovim 0.12 native API). Completion is provided by blink.cmp. Formatting runs on save via conform.nvim; linting triggers on `BufEnter`, `BufWritePost`, and `InsertLeave` via nvim-lint.

## Tool sources — one per tool

| Source | Owns | Why |
|---|---|---|
| **Mason** (`lua/editor/mason.lua`) | LSP servers: `lua-language-server`, `gopls`, `basedpyright`, `yaml-language-server`, `terraform-ls`, `marksman`, `vtsls`, `sqls`; DAP adapter: `js-debug-adapter` | used *only* inside Neovim |
| **zdots Brewfile** (`Brewfile.common`) | `stylua`, `selene`, `luacheck`, `shellcheck`, `shfmt`, `prettier(d)`, `rubocop`, `standardrb`, `ffmpeg`, `rubberband` | the shell and CI run these too |
| **mise / bundler** | `ruby-lsp`, `standardrb` (per-project gems), runtime hosts | project-scoped versions |

Don't add a lint/format tool to Mason, and don't add an LSP server to the
Brewfile. `require("editor.mason").setup()` runs before `vim.lsp.enable()` and
prepends `mason/bin` to PATH; it is **skipped entirely under `$CI` / headless**
so it never triggers downloads on a throwaway runner. First install on a new
machine needs one Neovim restart for the servers to attach.

## Language Servers

All enabled via `vim.lsp.enable()` in init.lua. Mason keeps the binaries
installed; `ruby_lsp` / `standardrb` come from the project bundle.

| Server | Language | Notes |
|--------|----------|-------|
| `vtsls` | TypeScript / JavaScript | `autoUseWorkspaceTsdk = true` for monorepo path aliases; inlay hints (param names, var types, return types) |
| `ruby_lsp` | Ruby | `formatter = "auto"` |
| `standardrb` | Ruby | Runs alongside ruby_lsp |
| `gopls` | Go | `usePlaceholders`, `completeUnimported`, `unusedparams` |
| `lua_ls` | Lua | `globals = {"vim"}`, `checkThirdParty = false` |
| `basedpyright` | Python | Default config |
| `yamlls` | YAML | `keyOrdering = false` |
| `terraformls` | Terraform | Default config |
| `sqls` | SQL | Connects to `phalanxduel_dev` postgres (127.0.0.1:5432); useful for Drizzle migrations |

### Monorepo note (vtsls)

Open Neovim from the monorepo root so `autoUseWorkspaceTsdk` resolves to the
workspace `tsconfig.base.json`. The `@phalanxduel/shared` and `@phalanxduel/engine`
path aliases then work without extra config.

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
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>cd` | Diagnostic float (current line) |
| `<leader>ih` | Toggle inlay hints (any LSP supporting `textDocument/inlayHint`: vtsls, gopls, ruby_lsp …) |

## Formatters (conform.nvim, on save)

| Filetype | Formatter(s) | Notes |
|----------|-------------|-------|
| Lua | `stylua` | |
| Ruby | `standardrb` → `rubocop` | `stop_after_first` |
| Go | `goimports` then `gofmt` | Both run in sequence |
| JavaScript | `prettierd` → `prettier` | `stop_after_first` |
| TypeScript | `prettierd` → `prettier` | `stop_after_first` |
| JavaScriptReact | `prettierd` → `prettier` | `stop_after_first` |
| TypeScriptReact | `prettierd` → `prettier` | `stop_after_first` |
| JSON | `prettierd` → `prettier` | `stop_after_first` |
| JSONC | `prettierd` → `prettier` | `stop_after_first` |
| YAML | `prettierd` → `prettier` | `stop_after_first` |

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
| JavaScriptReact | `eslint_d` |
| TypeScriptReact | `eslint_d` |

## Debugging (DAP)

| Language | Adapter | Configs |
|----------|---------|---------|
| Go | `nvim-dap-go` (delve) | default |
| Ruby | `nvim-dap-ruby` | default |
| JS / TS / JSX / TSX | `nvim-dap-vscode-js` + `js-debug-adapter` (Mason) | tsx server launch, process attach, Vitest debug |

JS/TS DAP configs are registered for `javascript`, `typescript`, `javascriptreact`, `typescriptreact`. On `<leader>dc` a picker lists the three configs. The adapter binary is installed by Mason at `~/.local/share/nvim/mason/packages/js-debug-adapter/`.

## CLI Tooling

Formatters, linters, and DAP adapters (`stylua`, `selene`, `goimports`, `golangci-lint`, `debugpy`, …) come from the zdots Brewfile / mise and resolve from PATH — Neovim (nvim-lint, conform) invokes them but does not manage them. `test/lint.sh` runs `luacheck` + `stylua --check` + `selene` (config: `selene.toml` + `vim.yml` std lib) and is what CI (`.github/workflows/lint.yml`) and `.pre-commit-config.yaml` enforce.

## vdots CLI tooling

The `bin/vdots-*` scripts (shim, read-aloud, doctor, update) are on PATH via the zdots shell (`~/.config/zsh/.zshrc.local`, interim — zdots Z-337 tracks native pickup). That file also wires `man/` onto `MANPATH` and registers `completions/_vdots`. See [Read-Aloud](Read-Aloud.md) for the read-aloud toolchain.

## Runtime Providers

Configured in `lua/editor/options.lua`:

- **Ruby**: `neovim-ruby-host` via mise shims; disabled if not found
- **Python**: `python3` via mise shims (requires `pynvim` or `neovim` module); disabled if absent
- **Node**: disabled (`g.loaded_node_provider = 0`)
- **Perl**: disabled

PATH inside Neovim prepends `~/.local/share/mise/shims` and `/opt/homebrew/opt/openjdk/bin`; `JAVA_HOME` is set if the Homebrew OpenJDK directory exists.
