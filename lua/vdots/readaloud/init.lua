-- vdots.readaloud — read a Markdown buffer aloud with a rendered preview pane.
--
-- Two panes: edit the Markdown on the left, follow along on the right (a
-- read-only render-markdown copy). The macOS `say` voice reads a markup-stripped
-- version of each block; highlight + cursor track it in both panes. Pause /
-- jump / resume-from-cursor; hardware media keys via a Now-Playing helper.
--
-- macOS only. See `:help vdots-readaloud` and `:checkhealth vdots.readaloud`.

local player = require "vdots.readaloud.player"

local M = {}

-- Playback surface (also the RPC entry points for the media-key helper and the
-- SwiftBar remote: `nvim --server … --remote-expr "v:lua.require('vdots.readaloud').<fn>()"`).
M.play = player.play
M.stop = player.stop
M.close = player.close
M.refresh = player.refresh
M.pause = player.pause
M.resume = player.resume
M.toggle_pause = player.toggle_pause
M.next = player.next
M.prev = player.prev
M.export = player.export
M.publish = player.publish

---Convenience for the media-key helper / SwiftBar (no-arg, string-returning).
function M.rpc(cmd)
  local fn = M[cmd]
  if type(fn) == "function" then
    pcall(fn)
  end
  return ""
end

local MAPS = {
  {
    "<leader>rr",
    function()
      M.play { from_cursor = true }
    end,
    "Read aloud from cursor",
  },
  { "<leader>rp", M.toggle_pause, "Read aloud: pause/resume" },
  { "<leader>r]", M.next, "Read aloud: next block" },
  { "<leader>r[", M.prev, "Read aloud: previous block" },
  { "<leader>rs", M.stop, "Read aloud: stop" },
  { "<leader>rq", M.close, "Read aloud: close preview" },
  { "<leader>rf", M.refresh, "Read aloud: refresh preview" },
  {
    "<leader>rx",
    function()
      M.export()
    end,
    "Read aloud: export audio",
  },
  {
    "<leader>rP",
    function()
      M.publish()
    end,
    "Read aloud: publish to listen library (:VdotsReadPublish! to re-record)",
  },
}

---Set the buffer-local `;r` keymaps. Called from after/ftplugin/markdown.lua
---and for the preview buffer.
---@param bufnr integer
function M.attach(bufnr)
  for _, m in ipairs(MAPS) do
    vim.keymap.set("n", m[1], m[2], { buffer = bufnr, silent = true, desc = m[3] })
  end
end

---@param opts table? merged into vim.g.vdots_readaloud
function M.setup(opts)
  if opts then
    vim.g.vdots_readaloud = vim.tbl_deep_extend("force", vim.g.vdots_readaloud or {}, opts)
  end
end

return M
