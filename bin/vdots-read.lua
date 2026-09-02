-- bin/vdots-read.lua — headless bridge for `vdots-read`.
-- Runs the shared Markdown→speech transform (lua/vdots/readaloud/parse.lua) and
-- prints the spoken text to stdout, one block per line. The `vdots-read` shell
-- script pipes that into `say` (or `say -o`).
--
-- Invoked as:  nvim --headless -u NONE -l bin/vdots-read.lua <file.md>
-- Repo root is passed via $VDOTS_REPO.

local repo = vim.env.VDOTS_REPO or vim.fn.fnamemodify(vim.fn.expand "<sfile>:p", ":h:h")
local file = _G.arg and _G.arg[1] or nil
if not file or file == "" then
  io.stderr:write "vdots-read.lua: no input file\n"
  vim.cmd "cquit 1"
end

local ok, parse = pcall(dofile, repo .. "/lua/vdots/readaloud/parse.lua")
if not ok then
  io.stderr:write("vdots-read.lua: cannot load parser: " .. tostring(parse) .. "\n")
  vim.cmd "cquit 1"
end
local ok2, pron = pcall(dofile, repo .. "/lua/vdots/readaloud/pronounce.lua")

local lines = vim.fn.readfile(file)
for _, b in ipairs(parse.parse(lines)) do
  io.write(ok2 and pron.apply(b.speak) or b.speak, "\n")
end
vim.cmd "quit"
