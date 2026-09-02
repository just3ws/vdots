-- bin/vdots-read.lua — headless bridge for `vdots-read`.
-- Runs the shared Markdown→speech transform (parse + tech-pronunciation + paced
-- silences) and prints the spoken script to stdout. `vdots-read` pipes it to `say`.
--
-- Invoked as:  nvim --headless -u NONE -l bin/vdots-read.lua <file.md>
-- Env: $VDOTS_REPO (repo root), $VDOTS_PACE (follow|relaxed|natural).

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
if pron then
  for _, b in ipairs(blocks) do
    b.speak = pron.apply(b.speak)
  end
end

if pace then
  io.write(pace.script(blocks, { pace = vim.env.VDOTS_PACE or "follow" }), "\n")
else
  for _, b in ipairs(blocks) do
    io.write(b.speak, "\n")
  end
end
vim.cmd "quit"
