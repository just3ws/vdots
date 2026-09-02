-- after/ftplugin/markdown.lua — buffer-local keymaps for the read-aloud feature.
-- Prefix `;r` ("read aloud"). macOS `say` engine; see lua/editor/readaloud.lua.

local ra = require "editor.readaloud"

local function map(lhs, fn, desc)
  vim.keymap.set("n", lhs, fn, { buffer = true, silent = true, desc = desc })
end

map("<leader>rr", function()
  ra.start { from_cursor = true }
end, "Read aloud from cursor")
map("<leader>ra", function()
  ra.start { from_cursor = false }
end, "Read aloud whole document")
map("<leader>rs", ra.stop, "Read aloud: stop")
map("<leader>r<space>", ra.toggle_pause, "Read aloud: pause/resume")
map("<leader>r]", ra.next, "Read aloud: next")
map("<leader>r[", ra.prev, "Read aloud: previous")
map("<leader>rc", ra.read_current, "Read aloud: current block")
map("<leader>rx", function()
  ra.export()
end, "Read aloud: export audio + open player")
