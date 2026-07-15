# Architecture

vdots is a single-repo Lua configuration for Neovim 0.12+. All modules live under `lua/`; the entrypoint is `init.lua`. Plugins are managed by the native `vim.pack` API introduced in Neovim 0.12 — no lazy.nvim or packer at runtime (`nvim-pack-lock.json` is the lockfile).

## Entrypoint

`init.lua` runs in this order:

1. **Leader key** — `;` (all other options live in `lua/editor/options.lua`)
2. **Plugin declarations** — `vim.pack.add({...})` — all plugins declared in one block
3. **Module requires** — `editor.*` (options, keymaps, autocmds, commands, llm, claude, usage, errors, search, healthcheck)
4. **Snacks + theme** — snacks setup, `colorscheme dracula`, dracula_pro highlight overrides, lualine, diagnostics, native treesitter
5. **Plugin setup** — `require("plugins").setup_all()` configures every vim.pack plugin and binds its keymaps
6. **LSP wiring** — `LspAttach` autocmd, per-server `vim.lsp.config()`, then `vim.lsp.enable()`
7. **User commands** — `:PackSync`

## Module Layout

```
init.lua                    Entrypoint; plugin declarations + top-level wiring
lua/
  plugins.lua               setup_all(): every plugin's setup() + its keymaps
  filetypes.lua             vim.filetype.add() — custom extensions/filenames/patterns
  editor/
    options.lua             ALL vim.opt + vim.g (init.lua sets only the leader)
    keymaps/init.lua        All non-plugin keymaps (module dir; require "editor.keymaps")
    autocmds.lua            Autocommands: resize, cursor restore, whitespace cleanup, yank mirror
    commands.lua            User commands: :Reload, :Vimrc*, :Zshenv*, :ZdotsIngest, :ZdotsStatus
    explorer.lua            nvim-tree NERDTree-style mappings
    search.lua              Native rg grep → quickfix (:Rg, <leader>ff)
    telescope.lua           Telescope defaults
    treesitter.lua          Native TS highlighting (vim.treesitter.start) + textobjects
    llm.lua                 Local llama.cpp integration (ai-query)
    claude.lua              Claude Code session pulse + :ClaudeDiff
    usage.lua               Friction telemetry → :NvimUsage
    errors.lua              Error log → :NvimErrors
    healthcheck.lua         Deprecation-warning filter/log
  ui/
    diagnostics.lua         Diagnostic display config
    dracula_pro.lua         Dracula PRO palette + highlight overrides (colorscheme is "dracula")
    lualine.lua             lualine theme (dracula-pro colours) + rails_env component
  zdots/
    init.lua                Lua bridge to the zdots shell platform (zdots-ctx, ztask, pi-ctx-*)
after/
  ftplugin/                 Per-filetype overrides: go, javascript, lua, ruby, typescript, vim
  plugin/
    abbreviations.lua       Global iabbrev typo corrections + filetype-scoped snippets
```

## Plugin Manager

`vim.pack` (native, Neovim 0.12). All plugins are declared with `vim.pack.add()` in `init.lua` and configured in `lua/plugins.lua`. The `:PackSync` user command calls `vim.pack.update()`; `nvim-pack-lock.json` is the lockfile.

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
