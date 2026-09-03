<!-- ═══════════════════════════════════════════════════════════════════════
     CURRENT FOCUS  —  last updated 2026-09-03
     Cold-start resume state, canonical for every agent tool. Whoever closes
     a session rewrites this block in place — step one, before the wrap-up.
     git log is truth for exact SHAs; if this contradicts it, trust git.

       MERGED + PUSHED 2026-09-03 (`feat/vdots-shim-readaloud`, 27 commits, via
       `--no-ff`). The vdots control-plane shim + read-aloud plugin +
       `vdots-listen` publish pipeline + enhanced-doc frontmatter contract +
       Mason + dashboard Recent-Markdown are on `main`, tested + documented.

       Post-merge on `main` (2026-09-03, still local — commit + push):
       - `readalong.mp4` — `vdots-readalong` renders one SVG frame per cue
         (scrolling transcript window, active sentence highlighted, chapter
         header, progress bar) via rsvg-convert, stitches to the narration with
         ffmpeg. **This is the Drive read-along** — Drive's HTML preview runs no
         JS so article.html can't sync there; a video needs nothing but a
         player. ~1 MB/spoken-min, 1280×720 h264+aac.
       - `brief.md` — self-contained analysis brief (what this is, chapters,
         "how to help me" tailored to the doc's kind/format, full transcript
         inline). Open in Gemini straight from Drive.
       - `manifest.md` (kind: interview-prep only) — a research kit: a MAP of
         every relevant file (this package + the wwworkremote source pack +
         `$VDOTS_RESUME_URL`/`$VDOTS_PORTFOLIO_URL` public links) + a research
         brief, for any AI chat to research the job independently.
       - all linked from index.md + article.html; meta.json gains
         video/brief/manifest; vdots-doctor / :checkhealth report rsvg-convert.
       - publish now removes a superseded same-slug session under an old date.
       - pace.lua M.cues scales modelled pauses by 1/stretch (the [[slnc]]
         pauses get stretched too) — cuts the read-along drift. The deeper fix
         (measure per-sentence say durations, or AVSpeech willSpeakRange
         callbacks — both deterministic; whisper was rejected as non-det) is
         NOT built yet.

       Latest session (2026-09-03):
       - audio: `.mp3` is primary (Drive/Android plays it inline; transcript
         embedded as a clean-ID3 lyrics frame); `.m4a` kept for chapters +
         faststart. rubberband (R3) time-stretch for a measured pace, ffmpeg
         atempo fallback. Per-word `[[slnc]]` removed (flash-card effect);
         pace.lua = punctuation/paragraph beats + whole-file stretch (follow:
         168wpm × 0.90 ≈ 10:57 for the basis pack).
       - role-named session files + `index.md` catalog as the phone surface.
         article.html read-along wiring verified (highlights, auto-scroll, list
         items). **KNOWN: the article.html <audio> player does not work in
         Google Drive's preview — Drive sandboxes JS + media. `index.md` +
         opening `audio.mp3` directly is the Drive path.** Could not verify
         real playback (automation Chrome can't load <audio> at all).
       - selene wired (vim.yml std lib; CI installs it + mandoc + zsh;
         pre-commit runs it). Mason owns editor-only LSP servers
         (lua/editor/mason.lua); brew owns shell/CI tools. Brewfile.common
         (zdots main): + rubberband, + selene, − lua-language-server.
       - Full doc pass: 8 man pages (man/man1/), completions/_vdots,
         docs/wiki/Read-Aloud.md + 5 mermaid diagrams, .claude/skills/
         read-aloud.md, README + wiki + :help synced. .zshrc.local (zdots,
         gitignored) wires PATH + MANPATH + the completion.

       Blocked on human: nothing. (zdots `main` also pushed: Z-338 fix + 2×
       Brewfile + a `.claude/settings.json` permission tidy.)

       NEXT (recommended, deferred — its own focused pass): rewrite
       lua/vdots/readaloud/parse.lua from regex to vim.treesitter (markdown +
       markdown_inline). 331 lines, 43 tests to keep green, must still work in
       the headless `nvim -l` CLI path. Plan: walk atx_heading / paragraph /
       list_item / fenced_code_block / block_quote / pipe_table, map node
       ranges → block s/e, keep parse.document as entry, add parser-availability
       to readaloud/health.lua.

       Zoe (Premium) is the picked voice (auto-resolves). PATH for
       ~/.config/nvim/bin: interim via zdots .zshrc.local; zdots Z-337 tracks
       the native env.sh pickup, Z-338 (FIXED this session) was the chpwd hook
       evicting it.
       Deep handoff: ~/.config/adots/handoffs/2026-09-03-2.md

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
  bridge: script/transcript/vtt/cues/chapters/meta/info/pace), `vdots-listen-catalog.py`,
  `vdots-readalong` (scrolling read-along video: SVG frames → rsvg-convert →
  ffmpeg), `vdots-readability`, `vdots-mediakey-helper.swift`, `vdots-readaloud-swiftbar`.
  Each is standalone; the shim just dispatches. `vdots-publish` = pre-flight
  report + `vdots-listen publish`.
- `man/man1/*.1`: mandoc for every `vdots*` command. `completions/_vdots`: zsh
  completion. Both wired by the zdots shell (`~/.config/zsh/.zshrc.local`,
  interim — Z-337). `test/lint.sh` lints them (`mandoc -W error`, `zsh -n`).
- `test/`: regression suite (`test/regression.lua`), Busted specs (`test/unit/`), runner (`test/run.sh`).

**Doc surfaces (keep in sync on any command / vocabulary / contract change):**
`README.md`, `AGENTS.md` (this file + the CURRENT FOCUS block), `doc/vdots-readaloud.txt`
(`:help`), `docs/wiki/` (`Read-Aloud.md`, `LSP-and-Tooling.md`, `Architecture.md`),
`man/man1/*.1`, `completions/_vdots`, `.claude/skills/read-aloud.md`, per-command
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
