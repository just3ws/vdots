# Neovim Config Remediation Plan

Remaining tasks for the configuration audit. Completed tasks are in [TODONE.md](TODONE.md).

## Working Guidelines

- **One logical change per commit** - Don't bundle unrelated fixes
- **Test after each change** - Run `./test/run.sh`, restart nvim, verify no errors
- **Commit message format** - `fix(scope): description` or `refactor(scope): description`
- **If unsure, ask** - Some changes affect muscle memory; confirm before changing keymaps
- **When done** - Move task to TODONE.md with commit hash

---

## Expert Audit (2026-02-28) — Bugs / Defects

### [ ] B-1: Fix orphaned lua/ui/lualine.lua

**File:** `lua/ui/lualine.lua`, `lua/plugins/ui.lua`
**Why:** `lua/plugins/ui.lua` configures lualine inline with minimal options. `lua/ui/lualine.lua`
sets `section_separators = ""` and `component_separators = ""` but is never required anywhere —
it's dead code. The separator config is silently not applied.
**Fix:** Wire `lua/plugins/ui.lua` lualine config to `require("ui.lualine")`, which replaces
the inline setup call.
**Commit:** `fix(ui): wire lualine.lua into plugin config`

### [ ] B-2: Fix ALE + LSP duplicate linting

**Files:** `lua/plugins/ale.lua`
**Why:** `ruby_lsp` runs RuboCop internally. ALE also runs `rubocop`. `lua_ls` covers Lua
diagnostics. ALE also runs `luacheck`. This causes double diagnostics in the gutter and
double tool execution on every save.
**Fix:** Remove `ruby = { "rubocop" }` and `lua = { "luacheck" }` from `ale_linters`.
Keep `go = { "golangci-lint" }` (gopls doesn't run golangci-lint). Keep all others.
**Commit:** `fix(ale): remove linters already covered by LSP`

### [ ] B-3: Fix double trailing-whitespace removal

**Files:** `lua/plugins/ale.lua`, `lua/editor/autocmds.lua`
**Why:** `autocmds.lua` BufWritePre runs `silent! %s/\s\+$//e`. ALE's global fixers also
include `trim_whitespace`. Both fire on every save — redundant and can cause cursor jumps.
**Fix:** Remove `trim_whitespace` from `ale_fixers["*"]`. Keep `remove_trailing_lines`
(autocmds.lua does not remove trailing blank lines at EOF).
**Commit:** `fix(ale): remove trim_whitespace fixer, covered by BufWritePre autocmd`

### [ ] B-4: Fix maplocalleader collision with mapleader

**File:** `init.lua`
**Why:** Both `mapleader` and `maplocalleader` are set to `";"`. Filetype plugins
(`vim-ruby`, `vim-rails`) bind `<localleader>` maps, which silently collide with the
regular leader namespace. The conventional localleader is `\`.
**Fix:** Change `vim.g.maplocalleader = ";"` to `vim.g.maplocalleader = "\\"`
**Commit:** `fix(init): set maplocalleader to backslash to avoid leader collision`

### [ ] B-5: LuaSnip has no snippets configured

**Files:** `lua/plugins/lsp.lua`, `lua/editor/snippets.lua`
**Why:** `L3MON4D3/LuaSnip` is installed and wired into nvim-cmp, but `lua/editor/snippets.lua`
is empty. The snippet engine runs but has nothing to expand — Tab in insert mode falls through
to indentation rather than expanding anything useful.
**Fix:** Add `rafamans2/friendly-snippets` as a LuaSnip dependency and configure lazy-loading
in `lua/editor/snippets.lua` via `luasnip.loaders.from_vscode`.
**Commit:** `feat(snippets): add friendly-snippets and configure LuaSnip loading`

### [ ] B-6: Delete or populate empty stub files

**Files:** `lua/editor/commands.lua`, `lua/editor/snippets.lua`, `lua/utils/safe_require.lua`
**Why:** Three files exist but contain only a newline. They create the impression of structure
that doesn't exist. `commands.lua` is loaded in `init.lua` but does nothing — user commands
(`:Reload`, `:Vimrc`, etc.) are still defined in `keymaps/init.lua`.
**Fix:**

- Move user commands from `keymaps/init.lua` into `commands.lua`
- `snippets.lua` filled by B-5
- Delete `utils/safe_require.lua` (no consumers, no planned use)
**Commit:** `refactor(editor): move user commands to commands.lua; delete empty stubs`

---

## Expert Audit (2026-02-28) — High Impact

### [ ] H-1: Add terminal integration

**Why:** No terminal keymaps exist. Neovim has a built-in terminal but there is no way to
open one, no `<Esc>` to exit terminal mode. A daily-driver config needs this.
**Options:** `akinsho/toggleterm.nvim` (floating + split + persistent) or manual keymaps.
**Commit:** `feat(terminal): add terminal keymaps and toggleterm`

### [ ] H-2: Add gitsigns.nvim

**Why:** No inline git sign column (added/changed/removed lines). No hunk operations (stage,
reset, preview). No inline blame. Fugitive handles repo-level git; gitsigns handles
line-level — they are complementary, not overlapping.
**Plugin:** `lewis6991/gitsigns.nvim`
**Commit:** `feat(git): add gitsigns for inline hunk signs and blame`

### [ ] H-3: Manage treesitter parsers

**Why:** The post-rewrite `nvim-treesitter` removed `ensure_installed` from `setup()`.
Parsers must now be installed manually. On a fresh clone, syntax highlighting silently
degrades. The parsers for primary languages need to be documented or auto-installed.
**Fix:** Add a `build` hook or document `:TSInstall lua ruby go javascript typescript yaml`
in the README post-install steps.
**Commit:** `feat(treesitter): document/automate parser installation`

### [ ] H-4: Remove CursorHold auto-diagnostic float

**File:** `lua/ui/diagnostics.lua`
**Why:** Opening a float on every `CursorHold` (every 250 ms of idle) causes constant popup
flicker while reading code. The explicit `<leader>e` binding is sufficient.
**Fix:** Remove the `CursorHold` autocmd from `diagnostics.lua`.
**Commit:** `fix(diagnostics): remove CursorHold auto-float; use explicit leader-e`

### [ ] H-5: Enable LSP inlay hints

**File:** `lua/lsp/init.lua`
**Why:** Neovim 0.10+ supports native inlay hints. `gopls` and `lua_ls` both provide them.
Inline type annotations and parameter names significantly reduce context-switching.
**Fix:** Add `vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })` in `on_attach` guarded
by `client.supports_method("textDocument/inlayHint")`.
**Commit:** `feat(lsp): enable inlay hints for supporting servers`

### [ ] H-6: Richer lualine statusline

**File:** `lua/ui/lualine.lua`
**Why:** Current statusline shows filename, mode, location. Missing: LSP server name,
diagnostic counts, git branch (fugitive available), ALE lint status.
**Fix:** Configure lualine sections with LSP client, diagnostics component, and
`FugitiveHead()` for git branch.
**Commit:** `feat(ui): add LSP, diagnostics, and git branch to lualine`

---

## Expert Audit (2026-02-28) — Medium Impact

### [ ] M-1: Migrate nvim-cmp → blink.cmp

**Why:** `hrsh7th/nvim-cmp` is effectively unmaintained. `Saghen/blink.cmp` is the active
successor, written in Rust, significantly faster, and drop-in compatible.
**Commit:** `feat(completion): migrate from nvim-cmp to blink.cmp`

### [ ] M-2: Replace vim-surround with nvim-surround

**Why:** `kylechui/nvim-surround` is the Lua rewrite with treesitter integration and better
dot-repeat. Keymaps (`cs`, `ds`, `ys`) are identical — migration is transparent.
**Commit:** `feat(plugins): replace vim-surround with nvim-surround`

### [ ] M-3: Add flash.nvim for jump navigation

**Why:** No EasyMotion/Sneak-style jump-to-position. `folke/flash.nvim` provides `s`/`S`
jumps, treesitter-aware selection, and search labels. High productivity gain.
**Commit:** `feat(navigation): add flash.nvim for jump navigation`

### [ ] M-4: Add nvim-autopairs

**Why:** No automatic bracket/quote pairing. `windwp/nvim-autopairs` integrates with
nvim-cmp/blink.cmp to prevent double-closing-bracket on completion confirm.
**Commit:** `feat(editing): add nvim-autopairs`

### [ ] M-5: Narrow ALE to non-LSP tools only; add conform.nvim for formatting

**Why:** ALE currently handles both linting and formatting for languages where LSP already
formats. `conform.nvim` provides a cleaner formatting pipeline with LSP fallback and
format-on-save. ALE should only lint tools without LSP servers (yamllint, slimlint,
pyinilint, markdownlint).
**Commit:** `feat(formatting): add conform.nvim; remove ALE fixers for LSP-covered types`

### [ ] M-6: Set timeoutlen explicitly

**File:** `lua/editor/options.lua`
**Why:** With `;` as leader and which-key at 300 ms, the default `timeoutlen = 1000` means
a 1-second wait before `; → :` fires. `timeoutlen = 400` is a better balance.
**Commit:** `fix(options): set timeoutlen = 400 for snappier leader key fallback`

### [ ] M-7: Use vim.filetype.add() for filetype overrides

**File:** `lua/editor/autocmds.lua`
**Why:** 14 filetype patterns are set via BufRead/BufNewFile autocmds. Neovim has
`vim.filetype.add()` specifically for this — it runs at detection time, before autocmds.
**Commit:** `refactor(autocmds): convert filetype_overrides to vim.filetype.add()`

### [ ] M-8: Add session management

**Why:** No session save/restore. A daily-driver config benefits enormously from
`folke/persistence.nvim` — transparent and minimal.
**Commit:** `feat(session): add persistence.nvim for session restore`

---

## Expert Audit (2026-02-28) — Long Term / Architectural

### [ ] L-1: Use global vim.lsp.config("*") for shared on_attach

**File:** `lua/lsp/init.lua`
**Why:** All four servers repeat identical `on_attach` and `capabilities`. Neovim 0.11
supports `vim.lsp.config("*", { on_attach = ..., capabilities = ... })` to set these once.
**Commit:** `refactor(lsp): use global lsp config for shared on_attach and capabilities`

### [ ] L-2: Remove vim.deprecate monkey-patch in healthcheck.lua

**File:** `lua/editor/healthcheck.lua`
**Why:** Monkey-patching a core Neovim API at every startup is fragile and runs
unconditionally. The `sign_define` warnings it suppresses are already fixed upstream.
**Commit:** `fix(healthcheck): remove vim.deprecate monkey-patch`

### [ ] L-3: Evaluate nvim-tree.lua as NERDTree replacement

**Why:** NERDTree is unmaintained (last significant commit 2022). `nvim-tree/nvim-tree.lua`
provides the same workflow with LSP file operations, async git status, and active
maintenance. This is a muscle-memory migration — plan carefully.
**Commit:** `feat(explorer): migrate from NERDTree to nvim-tree`

### [ ] L-4: Add nvim-dap for debugging

**Why:** No debugging support for any language. `mfussenegger/nvim-dap` with `nvim-dap-ui`
and language-specific adapters (ruby, go) provides full DAP debugging inside Neovim.
**Commit:** `feat(debug): add nvim-dap with ruby and go adapters`

---

## Summary

| Priority | Status | Count |
| -------- | ------ | ----- |
| Original remediation (P0–P5) | ✓ Complete | 30 |
| B - Bugs / Defects | 0/6 done | 6 remaining |
| H - High Impact | 0/6 done | 6 remaining |
| M - Medium Impact | 0/8 done | 8 remaining |
| L - Long Term | 0/4 done | 4 remaining |

Total from expert audit: 0 completed, 24 remaining
