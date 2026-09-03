---
name: read-aloud
description: Work on or debug the vdots read-aloud plugin and the `vdots publish` listen-along pipeline. Use when the user asks about `;r*` keymaps, the rendered preview pane, pacing/voices, `vdots-read` / `vdots-publish` / `vdots-listen`, the article page, enhanced read-aloud documents, or the Google Drive listen library.
---

# read-aloud

The offline Markdown reader (`lua/vdots/readaloud/`, macOS `say`) plus the
publish pipeline that builds a synced listen-along session on Google Drive.

Full reference: `docs/wiki/Read-Aloud.md`, `:help vdots-readaloud`
(`doc/vdots-readaloud.txt`), `man vdots-{read,publish,listen}`.

## Map

| Concern | Where |
|---|---|
| Markdown → speech blocks | `lua/vdots/readaloud/parse.lua` (`parse.document()` is the entry — frontmatter-aware, fence-unwrap, keeps `{s,e}` source lines) |
| Enhanced-doc YAML contract | `lua/vdots/readaloud/frontmatter.lua` |
| Pronunciation (tech map + per-doc lexicon) | `lua/vdots/readaloud/pronounce.lua` |
| Rate / pauses / time-stretch / cue timing | `lua/vdots/readaloud/pace.lua` — `M.presets` is the tuning surface |
| Rendered preview + cursor sync | `lua/vdots/readaloud/preview.lua` |
| `say` state machine + publish | `lua/vdots/readaloud/player.lua` |
| CLI bridge (headless nvim) | `bin/vdots-read` + `bin/vdots-read.lua` |
| Publish pipeline | `bin/vdots-listen` (+ `bin/vdots-listen-catalog.py`) |
| Scrolling read-along video | `bin/vdots-readalong` (rsvg frames + ffmpeg) |
| OCR-friendly guide PDF | `bin/vdots-guide-image` (`document.md` → `guide.pdf`, rsvg pages) |
| Readability JSON | `bin/vdots-readability` |
| Health | `lua/vdots/readaloud/health.lua` → `:checkhealth vdots.readaloud` |

## Rules

- **Never change the delivery of a document's body.** Enhanced docs are
  speech-ready: no re-expansion, rewriting, summarising, reordering, dropping.
- **Two pacing levers, kept apart** (`pace.lua`): boundary silence
  (`[[slnc]]` at clause/sentence/paragraph — where a speaker pauses) and a
  whole-file `stretch` applied *after* `say` renders. Per-word `[[slnc]]` was
  tried and removed — it sounds like flash cards.
- The pace preset (rate + stretch) has **one source**: `pace.lua`. Shell reads
  it via `vdots-read --print-pace`. Don't hardcode rates elsewhere.
- The `article.html` synced player is **browser-only** — Google Drive's HTML
  preview sandboxes JS and media. `index.md` + `audio.mp3` is the Drive path.
- macOS only (`say`). `ffmpeg` / `rubberband` are graceful-degradation.

## Tasks

**Tune the reading feel** — edit `pace.lua` `M.presets` (`stretch` lower =
slower/more air everywhere; `clause`/`sentence`/`para` = pause ms). Then
`vdots-read --sample --voice "Zoe (Premium)"` to audition, or re-publish the
canonical doc `~/ai/outbox/wwwr/interview-prep/basis-dsp/pack.md --force`.

**Change a pipeline stage** — it's `bin/vdots-listen` `cmd_publish`. Files are
written to role-named paths (`p_mp3`, `p_m4a`, `p_doc`, …) then `meta.json`
lists them; `catalog.py` reads every filename from `meta.json`, so keep those
in sync. `-v` narrates every step.

**After any change**: `./test/run.sh` + `./test/lint.sh` (both must pass), then
publish the canonical doc and verify the tree + `index.md`. If you touched the
article page, serve `~/ai/outbox/listen` over a real HTTP server (Python's
`http.server` has no Range support — use a range-capable one) and confirm the
transcript highlights follow playback.

**Verifying playback**: automation Chrome cannot load `<audio>` media at all —
verify DOM/JS wiring and cue data instead, and test real playback out of band.
