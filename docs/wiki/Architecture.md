# Architecture

vdots is a single-repo Lua configuration for Neovim 0.12+. All modules live under `lua/`; the entrypoint is `init.lua`. Plugins are managed by the native `vim.pack` API introduced in Neovim 0.12 — no lazy.nvim or packer at runtime (a `lazy-lock.json` and `nvim-pack-lock.json` are both present as historical artefacts from a prior lazy.nvim setup).

## Entrypoint

`init.lua` runs in this order:

1. **Global options** — `vim.opt` and `vim.g` settings (leader, mouse, tabs, search, clipboard, undo)
2. **PATH setup** — prepends mise shims so editor-invoked tools resolve correctly
3. **Plugin declarations** — `vim.pack.add({...})` — all plugins declared in one block
4. **Module requires** — `editor.*`, `features.search`, then plugin setup calls
5. **LSP wiring** — `LspAttach` autocmd, per-server `vim.lsp.config()`, then `vim.lsp.enable()`
6. **Completion** — native `InsertCharPre` omnifunc trigger; `completeopt` set
7. **User commands** — `:PackSync`, `:Reload vimrc` keymaps

## Module Layout

```
init.lua                    Entrypoint; plugin declarations + top-level wiring
lua/
  editor/
    options.lua             vim.opt + vim.g (split off from init.lua for clarity)
    keymaps/init.lua        All non-plugin keymaps (module dir; require "editor.keymaps")
    autocmds.lua            Autocommands: resize, cursor restore, filetype overrides, whitespace cleanup
    commands.lua            User commands: :Reload, :Vimrc*, :Zshenv*, :ZdotsIngest, :ZdotsStatus
    explorer.lua            nvim-tree + Oil setup helpers
    telescope.lua           Telescope defaults, fzf extension load
    treesitter.lua          (referenced; treesitter module)
    healthcheck.lua         :checkhealth entry
  features/
    search/init.lua         Snacks.picker / ripgrep search (module dir; require("features.search").setup())
  filetypes.lua             vim.filetype.add() — custom extensions/filenames
  lsp/
    init.lua                Mason bootstrap, mason-tool-installer, LspAttach keymaps, server configs
  plugins/
    ai.lua                  CodeCompanion
    ai_erb.lua              ERB/Otter AI integration
    core.lua                flash, tpope suite, Ruby ecosystem, git, misc
    dap.lua                 nvim-dap + dap-ui + adapters (Go, Ruby)
    explorer.lua            oil.nvim + nvim-tree
    formatting.lua          conform.nvim formatters
    linting.lua             nvim-lint linters
    lsp.lua                 lazydev, blink.cmp, fidget, nvim-lspconfig
    search.lua              telescope.nvim
    test.lua                neotest + adapters
    treesitter.lua          nvim-treesitter + context, textobjects, autotag, commentstring
    ui.lua                  gitsigns, trouble, todo-comments, dracula-pro, lualine, aerial, snacks, render-markdown
    whichkey.lua            which-key group labels
  ui/
    diagnostics.lua         Diagnostic display config
    dracula_pro.lua         Dracula Pro theme + palette definition
    lualine.lua             lualine theme (dracula-pro colours) + rails_env component
  zdots/
    init.lua                Lua bridge to the zdots shell platform (zdots-ctx, ztask, pi-ctx-*)
    plugin_configs.lua      Additional zdots-aware plugin configuration
after/
  ftplugin/                 Per-filetype overrides: go, javascript, lua, ruby, typescript, vim
  plugin/
    abbreviations.lua       Global iabbrev typo corrections + filetype-scoped snippets
```

## Plugin Manager

`vim.pack` (native, Neovim 0.12). All plugins are declared with `vim.pack.add()` in `init.lua`. The `:PackSync` user command calls `vim.pack.update()`. Lock files (`lazy-lock.json`, `nvim-pack-lock.json`) are retained from a prior lazy.nvim setup but are not actively used.

## zdots Integration (`lua/zdots/`)

`lua/zdots/init.lua` is the Lua bridge to the [zdots](https://github.com/just3ws/zdots/wiki) shell platform. It shells out to `~/.config/zsh/bin/` commands:

| Function | Shell command | Purpose |
|----------|--------------|---------|
| `M.get_status()` | `pi-ctx-status` | Platform status for `:ZdotsStatus` float |
| `M.ztask(subcmd)` | `ztask <subcmd> --json` | Task list for `<leader>zt` picker |
| `M.hydrate_context(file)` | `pi-ctx-hydrate --file --brief` | Context blob injected into CodeCompanion chat |
| `M.ingest_buffer(bufnr)` | `zdots-ctx capture --file` | Feed current buffer into the Knowledge Layer |

## Health CLI

`bin/vdots-doctor` delegates to `bin/vdots-ctl check --json` and exits 1 on failures. Mirrors the `zdots-doctor` pattern from [zdots](https://github.com/just3ws/zdots/wiki).
