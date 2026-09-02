<!-- ═══════════════════════════════════════════════════════════════════════
     CURRENT FOCUS  —  last updated 2026-09-02
     Cold-start resume state, canonical for every agent tool. Whoever closes
     a session rewrites this block in place — step one, before the wrap-up.
     git log is truth for exact SHAs; if this contradicts it, trust git.

       In flight: branch `feat/vdots-shim-readaloud` (not merged, not pushed) —
       adds the `vdots` control-plane shim (bin/vdots → vdots-<noun>, matching
       zdots/phx), fixes bin/vdots-ctl (unset SCRIPT_DIR) + bin/vdots-doctor
       (cwd-bound ./bin path), and ships a Markdown read-aloud feature
       (lua/editor/readaloud.lua, `;r` keymaps, :VdotsRead*, bin/vdots-read,
       macOS `say`). Dashboard gained inline Recent Files + Recent Markdown
       sections (lua/editor/mdfiles.lua; shada '1000). Tests green (57 smoke +
       9 unit).
       Blocked on human: merge decision for the branch. PATH for
       ~/.config/nvim/bin is interim-only via zdots ~/.config/zsh/.zshrc.local;
       zdots request Z-337 tracks the native env.sh pickup.
       Deep handoff: none (work is committed on the branch, not mid-task).

     Close ritual: rewrite this block + commit; write a deep handoff only if
     work is genuinely unfinished. Reference impl: wwworkremote/core's
     docs/agents/session-handoff.md.
     ═══════════════════════════════════════════════════════════════════════ -->

# Repository Guidelines

## Project Structure & Module Organization

This repository is a Lua-based Neovim configuration.

- `init.lua`: bootstrap entrypoint (leader key, `vim.pack.add`, module loading, native LSP wiring).
- `lua/`: main modules by concern:
  - `lua/editor/` for options, keymaps, commands, autocmds, Telescope, Treesitter, search,
    `readaloud.lua` (Markdown text-to-speech), `mdfiles.lua` (Markdown-file predicate).
  - `lua/plugins.lua` for all plugin `setup()` calls and their keymaps.
  - `lua/ui/` for colors and diagnostics display.
  - `lua/zdots/` for the zdots shell-platform bridge.
- `after/`: filetype and late-loading overrides (`after/ftplugin/markdown.lua` = `;r` read-aloud keys).
- `bin/`: the `vdots` control-plane shim (`vdots <noun>` → `vdots-<noun>`) plus
  `vdots-{ctl,doctor,update,read}`. Each is standalone; the shim just dispatches.
- `test/`: regression suite (`test/regression.lua`), Busted specs (`test/unit/`), runner (`test/run.sh`).

## Build, Test, and Development Commands

Use these from repo root:

- `./test/run.sh`: run the full headless regression suite (required before/after changes).
- `./bin/vdots-update`: update plugins via `vim.pack`, prune inactive packages, run tests, show diff.
- `luacheck . --config .luacheckrc`: static lint for Lua.
- `stylua --check .`: formatting check (CI matches this).
- `stylua .`: apply formatting.
- `nvim --headless -u init.lua -c 'quit'`: quick startup sanity check.

## Coding Style & Naming Conventions

- Indentation: 2 spaces (`.editorconfig`, `.stylua.toml`).
- Prefer small, focused modules and `require(...)` by domain (`editor.*`, `plugins.*`, `ui.*`).
- File names: lowercase snake_case (for example `healthcheck.lua`).
- Keep comments brief and intent-focused; avoid restating obvious Lua syntax.
- Run `stylua .` and `luacheck` before committing.

## Testing Guidelines

- Primary framework: custom Neovim regression tests in `test/regression.lua`.
- Add tests when changing options, keymaps, commands, plugin wiring, or autocmd behavior.
- Test names should describe observable behavior (example: `"Leader key is semicolon"`).
- Execute with `./test/run.sh` and require a clean pass (`exit 0`).

## Commit & Pull Request Guidelines

- Follow Conventional Commit style seen in history:
  `feat(scope): ...`, `fix(scope): ...`, `refactor(scope): ...`, `docs(scope): ...`.
- Keep commits scoped to one logical change.
- PRs should include:
  - a short problem/solution summary,
  - linked issue/task when applicable,
  - commands run and results (`./test/run.sh`, `luacheck`, `stylua --check .`),
  - notes on user-visible behavior changes (keymaps/commands/UI highlights).

## Security & Configuration Notes

- Do not commit machine-local secrets or tokens.
- Treat `nvim-pack-lock.json` updates as intentional dependency changes; mention plugin bumps in the PR.
