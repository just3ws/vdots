<!-- ═══════════════════════════════════════════════════════════════════════
     CURRENT FOCUS  —  last updated 2026-09-03
     Cold-start resume state, canonical for every agent tool. Whoever closes
     a session rewrites this block in place — step one, before the wrap-up.
     git log is truth for exact SHAs; if this contradicts it, trust git.

       In flight: branch `feat/vdots-shim-readaloud` (NOT merged, NOT pushed —
       ~15 commits). The vdots control-plane shim + read-aloud plugin +
       `vdots-listen` publish pipeline + enhanced-doc frontmatter contract +
       dashboard Recent-Markdown are all built, tested, and working end to end.

       Latest session (2026-09-03) hardened the publish → Google Drive path:
       - audio: `.mp3` is primary (Drive/Android plays it inline; transcript
         embedded as an id3 lyrics frame); `.m4a` kept for chapters + faststart
         (Apple Music/VLC). rubberband (R3) time-stretch for a measured spoken
         pace, ffmpeg atempo fallback. Per-word `[[slnc]]` was removed — it
         sounded like flash cards; pace.lua now = punctuation/paragraph beats
         + whole-file stretch (follow: 168wpm × 0.90 ≈ 10:57 for the basis pack).
       - session dir uses role-named files (audio.mp3, document.md, report.md,
         transcript.txt, captions.vtt, article.html, meta.json + assets/); the
         `index.md` catalog is the phone surface (Drive renders it; the HTML
         player only works in a real browser). article.html read-along verified
         in-browser: transcript highlights + auto-scrolls, list items tracked.
       - `-v`/`--verbose` on vdots-publish/vdots-listen.
       - selene wired (vim.yml std lib, CI + pre-commit); Mason owns editor-only
         LSP servers (lua/editor/mason.lua), brew owns shell/CI tools —
         documented under "Tool sources" below. Brewfile.common (zdots main):
         + rubberband, + selene, − lua-language-server.

       Blocked on human: merge/push decision for the branch.

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
