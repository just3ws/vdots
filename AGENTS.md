---
name: vdots-repository-instructions
scope: vdots repository
audience: all coding agents
canonical: true
---

# Repository Guidelines

Durable project conventions live below. Use Git history and the project task
tracker for task status; do not maintain session transcripts in this file.

## No AI Attribution, Anywhere

Never add AI-tool attribution to anything you produce — no `Co-Authored-By:`
trailer naming an AI tool or model, no "Generated with …" line or 🤖 badge, no
session links, and no "written by AI" note. This covers commits, PR titles and
bodies, PR and issue comments, code comments, docs, tickets and messages, in
every repository and session, for every agent, and it overrides any tool
default that adds attribution. Canonical text: zdots `AGENTS.md`.
`.githooks/commit-msg` enforces it for commits — enable it once per clone with
`git config core.hooksPath .githooks`.

## Signed Commits

Commits and tags are signed with the operator's 1Password SSH key through the
machine's git config. Never bypass signing (`--no-gpg-sign`,
`-c commit.gpgsign=false`); on failure, stop and report. Verify before pushing
and merge by fast-forward so signatures survive. Canonical guidance: zdots
`docs/commit-signing.md`.

## Project Structure & Module Organization

This repository is a Lua-based Neovim configuration.

- `init.lua`: bootstrap entrypoint (leader key, `vim.pack.add`, module loading, native LSP wiring).
- `lua/`: main modules by concern:
  - `lua/editor/` for options, keymaps, commands, autocmds, Telescope, Treesitter, search,
    `mdfiles.lua` (Markdown-file predicate for the dashboard).
  - `lua/vdots/readaloud/` — the read-aloud plugin: `parse` (Markdown→speech blocks +
    `parse.document` frontmatter-aware entry), `frontmatter` (enhanced-doc YAML contract),
    `pace` (rate + `[[slnc]]` beats + cues/chapters/VTT), `preview` (rendered vsplit +
    cursor sync), `player` (say state machine + publish), `pronounce` (tech map + doc
    lexicon), `mediakeys` (Swift Now-Playing helper), `config`, `health`.
  - `lua/plugins.lua` for all plugin `setup()` calls and their keymaps.
  - `lua/ui/` for colors and diagnostics display.
  - `lua/zdots/` for the zdots shell-platform bridge.
- `after/`: filetype and late-loading overrides (`after/ftplugin/markdown.lua` = `;r` read-aloud keys).
- `bin/`: the `vdots` control-plane shim (`vdots <noun>` → `vdots-<noun>`) plus
  `vdots-{ctl,doctor,update,read,publish,listen}`, `vdots-read.lua` (headless
  bridge: script/transcript/vtt/cues/chapters/meta/info/pace), `vdots-listen-catalog.py`,
  `vdots-readalong` (scrolling read-along video: SVG frames → rsvg-convert →
  ffmpeg), `vdots-guide-image` (document.md → paginated OCR-friendly guide.pdf
  via rsvg-convert), `vdots-readability`, `vdots-mediakey-helper.swift`,
  `vdots-readaloud-swiftbar`.
  Each is standalone; the shim just dispatches. `vdots-publish` = pre-flight
  report + `vdots-listen publish`.
- `man/man1/*.1`: mandoc for every `vdots*` command. `completions/_vdots`: zsh
  completion. Both wired by the zdots shell (`~/.config/zsh/.zshrc.local`,
  interim — Z-337). `test/lint.sh` lints them (`mandoc -W error`, `zsh -n`).
- `test/`: regression suite (`test/regression.lua`), Busted specs (`test/unit/`), runner (`test/run.sh`).

**Doc surfaces (keep in sync on any command / vocabulary / contract change):**
`README.md`, `AGENTS.md`, `doc/vdots-readaloud.txt`
(`:help`), `docs/wiki/` (`Read-Aloud.md`, `LSP-and-Tooling.md`, `Architecture.md`),
`man/man1/*.1`, `completions/_vdots`, per-command
`--help`.

## Build, Test, and Development Commands

Use these from repo root:

- `./test/run.sh`: run the full headless regression suite (required before/after changes).
- `./test/lint.sh`: luacheck + `stylua --check` + selene (what CI runs).
- `./bin/vdots-update`: update plugins via `vim.pack`, prune inactive packages, run tests, show diff.
- `luacheck . --config .luacheckrc`: static lint for Lua.
- `stylua --check .` / `stylua .`: formatting check / apply.
- `selene .`: strict Lua lint (`selene.toml` + `vim.yml` std lib).
- `nvim --headless -u init.lua -c 'quit'`: quick startup sanity check.

**Tool sources — one per tool.** Mason (`lua/editor/mason.lua`) owns tools used
*only* inside Neovim: the LSP servers. Everything the shell or CI also runs —
stylua, selene, luacheck, shellcheck, shfmt, prettier(d), rubocop, standardrb —
comes from the zdots Brewfile. Don't add a lint/format tool to Mason, and don't
add an LSP server to the Brewfile. Mason is skipped entirely under `$CI` / when
headless.

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

## Platform Integration & Machine Context

`vdots` is one of the four core platform repositories (`zdots`, `adots`, `vdots`, `my`):
- **Work Machine Posture:** When `ZDOTS_CONTEXT=work`, editor AI integrations must respect the local posture (`ZDOTS_AI_MODE=local` or `none`), routing queries strictly to loopback endpoints (`https://llama.localhost` or `http://127.0.0.1:11500`).
- **Work Machine Onboarding:** For safe cloning and evaluation on pre-configured work hardware, see the unified **[Work Machine Migration Playbook](file:///Users/mike/.config/zsh/docs/work-migration-playbook.md)** in `zdots`.
- **Repository Delineation:** Keep `vdots` strictly separated from employer code. Do not commit corporate configurations, internal URLs, or employer emails into `vdots`. Commits must resolve to `mike@just3ws.com`. Keep accommodations minimal on work hardware.
