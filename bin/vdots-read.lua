-- bin/vdots-read.lua — headless bridge for `vdots-read`.
-- Emits (per $VDOTS_MODE, default "script"):
--   script      : the spoken script for `say` (pronounced + paced [[slnc]] beats)
--   transcript  : the verbatim reading prose, one block per blank-line group
--   vtt <secs>  : a WebVTT transcript timed against $VDOTS_DURATION seconds
--
-- Invoked as:  nvim --headless -u NONE -l bin/vdots-read.lua <file.md>
-- Env: $VDOTS_REPO (repo root), $VDOTS_PACE, $VDOTS_MODE, $VDOTS_DURATION.

local repo = vim.env.VDOTS_REPO or vim.fn.fnamemodify(vim.fn.expand "<sfile>:p", ":h:h")
local file = _G.arg and _G.arg[1] or nil
if not file or file == "" then
  io.stderr:write "vdots-read.lua: no input file\n"
  vim.cmd "cquit 1"
end

local function load(mod)
  local ok, m = pcall(dofile, repo .. "/lua/vdots/readaloud/" .. mod .. ".lua")
  return ok and m or nil
end

local parse = load "parse"
if not parse then
  io.stderr:write "vdots-read.lua: cannot load parser\n"
  vim.cmd "cquit 1"
end
local pron = load "pronounce"
local pace = load "pace"

local blocks = parse.parse(vim.fn.readfile(file))
local mode = vim.env.VDOTS_MODE or "script"
local cfg = { pace = vim.env.VDOTS_PACE or "follow" }

if mode == "transcript" then
  local parts = {}
  for _, b in ipairs(blocks) do
    parts[#parts + 1] = (b.text:gsub("%s+", " "))
  end
  io.write(table.concat(parts, "\n\n"), "\n")
elseif mode == "vtt" and pace then
  io.write(pace.vtt(blocks, cfg, tonumber(vim.env.VDOTS_DURATION) or 0), "\n")
elseif mode == "cues-json" and pace then
  io.write(vim.json.encode(pace.cues(blocks, cfg, tonumber(vim.env.VDOTS_DURATION) or 0)), "\n")
else
  if pron then
    for _, b in ipairs(blocks) do
      b.speak = pron.apply(b.speak)
    end
  end
  if pace then
    io.write(pace.script(blocks, cfg), "\n")
  else
    for _, b in ipairs(blocks) do
      io.write(b.speak, "\n")
    end
  end
end
vim.cmd "quit"
