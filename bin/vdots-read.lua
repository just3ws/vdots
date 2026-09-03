-- bin/vdots-read.lua — headless bridge for `vdots-read`.
-- Emits (per $VDOTS_MODE, default "script"):
--   script          the spoken script for `say` (lexicon + paced [[slnc]] beats)
--   transcript      verbatim prose (one line per sentence when enhanced)
--   vtt <secs>      a WebVTT transcript timed against $VDOTS_DURATION
--   cues-json <s>   timed cues as JSON
--   chapters <secs> chapter markers as JSON  [{start,title}]
--   meta            the frontmatter block as JSON (never spoken)
--
-- Invoked as:  nvim --headless -u NONE -l bin/vdots-read.lua <file.md>
-- Env: $VDOTS_REPO, $VDOTS_PACE, $VDOTS_MODE, $VDOTS_DURATION.

local repo = vim.env.VDOTS_REPO or vim.fn.fnamemodify(vim.fn.expand "<sfile>:p", ":h:h")
local file = _G.arg and _G.arg[1] or nil
if not file or file == "" then
  io.stderr:write "vdots-read.lua: no input file\n"
  vim.cmd "cquit 1"
end
vim.opt.runtimepath:append(repo)

local parse = require "vdots.readaloud.parse"
local pron = require "vdots.readaloud.pronounce"
local pace = require "vdots.readaloud.pace"

local lines = vim.fn.readfile(file)
local mode = vim.env.VDOTS_MODE or "script"
local cfg = { pace = vim.env.VDOTS_PACE or "follow" }
local dur = tonumber(vim.env.VDOTS_DURATION) or 0

if mode == "meta" then
  local r = require("vdots.readaloud.frontmatter").parse(lines)
  io.write(
    vim.json.encode(vim.tbl_extend("force", r.fm, { enhanced = r.enhanced, present = r.present })),
    "\n"
  )
  vim.cmd "quit"
end

local doc = parse.document(lines, {})
local blocks, enhanced, fm = doc.blocks, doc.enhanced, doc.fm
local sent = { sentences = enhanced }

if mode == "chapters" then
  io.write(vim.json.encode(pace.chapters(blocks, cfg, dur, fm.sections)), "\n")
elseif mode == "chapters-vtt" then
  io.write(pace.chapters_vtt(pace.chapters(blocks, cfg, dur, fm.sections), dur), "\n")
elseif mode == "transcript" then
  local parts = {}
  for _, b in ipairs(blocks) do
    if enhanced and b.kind ~= "heading" then
      for chunk in b.text:gmatch "[^.!?]+[.!?]*" do
        chunk = vim.trim(chunk)
        if chunk ~= "" then
          parts[#parts + 1] = (chunk:gsub("%s+", " "))
        end
      end
    else
      parts[#parts + 1] = (b.text:gsub("%s+", " "))
    end
  end
  io.write(table.concat(parts, "\n"), "\n")
elseif mode == "vtt" then
  io.write(pace.vtt(blocks, cfg, dur, sent), "\n")
elseif mode == "cues-json" then
  io.write(vim.json.encode(pace.cues(blocks, cfg, dur, sent)), "\n")
else -- script
  for _, b in ipairs(blocks) do
    b.speak = enhanced and pron.lexicon(b.speak, fm.pronunciation) or pron.apply(b.speak)
  end
  io.write(pace.script(blocks, cfg), "\n")
end
vim.cmd "quit"
