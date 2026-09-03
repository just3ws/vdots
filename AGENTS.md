<!-- ═══════════════════════════════════════════════════════════════════════
     CURRENT FOCUS  —  last updated 2026-09-02
     Cold-start resume state, canonical for every agent tool. Whoever closes
     a session rewrites this block in place — step one, before the wrap-up.
     git log is truth for exact SHAs; if this contradicts it, trust git.

       In flight: branch `feat/vdots-shim-readaloud` (not merged, not pushed).
       (1) `vdots` control-plane shim (bin/vdots → vdots-<noun>, matching
       zdots/phx) + bin/vdots-ctl/-doctor bug fixes. (2) Read-aloud plugin
       `lua/vdots/readaloud/`: two-pane rendered preview + synced cursor,
       line-anchored playback (pause / jump / resume-from-block), macOS `say`
       with warm|clarity voice tone, `pace` presets (follow/relaxed/natural)
       that insert `[[slnc]]` beats between paragraphs + sections, tech-
       pronunciation map, hardware media keys via a compiled Swift Now-Playing
       helper (best-effort) and a SwiftBar remote, `:checkhealth
       vdots.readaloud`, `:help vdots-readaloud`. (3) `:VdotsReadPublish[!]` /
       `vdots-listen` — clean doc + recorded read-through + readability report
       (bin/vdots-readability, Flesch/grade) + verbatim timed transcript
       (.vtt + .cues.json) into ~/ai/outbox/listen; self-contained article page
       plays audio while the transcript highlights + auto-scrolls; catalog
       auto-synced by Google Drive desktop; same-day re-publish refused unless
       `!`/`--force`. (4) Enhanced read-aloud docs — a YAML frontmatter contract
       (lua/vdots/readaloud/frontmatter.lua): `format: …read-aloud` or the
       pronunciation+sections+spoken_minutes triple → per-doc lexicon (audio
       only), plain-spoken headings, one cue/line per sentence, m4a chapters
       (ffmpeg re-mux, AAC), `generated_at` freshness skip. First real publish:
       ~/ai/outbox/listen/2026-09-02-interview-prep-pack-senior-software-engineer-basis-platform.
       (5) Dashboard Recent Files + Recent Markdown sections
       (lua/editor/mdfiles.lua; shada '1000). Tests green (57 smoke + 30 unit).
       Blocked on human: merge decision for the branch. Operator picked
       `Zoe (Premium)` (downloaded, auto-resolves). PATH for ~/.config/nvim/bin
       is interim via zdots .zshrc.local; zdots request Z-337 tracks the
       native env.sh pickup.
       Deep handoff: none (committed on the branch, not mid-task).

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
  bridge: script/transcript/vtt/cues/chapters/meta/info), `vdots-listen-catalog.py`,
  `vdots-readability`, `vdots-mediakey-helper.swift`, `vdots-readaloud-swiftbar`.
  Each is standalone; the shim just dispatches. `vdots-publish` = pre-flight
  report + `vdots-listen publish`.
- `test/`: regression suite (`test/regression.lua`), Busted specs (`test/unit/`), runner (`test/run.sh`).

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
