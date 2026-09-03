-- :checkhealth vdots.readaloud

local M = {}

function M.check()
  local h = vim.health
  h.start "vdots.readaloud"

  if vim.fn.has "mac" == 1 then
    h.ok "platform: macOS"
  else
    h.error "vdots.readaloud is macOS only (engine is `say`)"
  end

  if vim.fn.executable "say" == 1 then
    h.ok "`say` found"
    local cfg = require "vdots.readaloud.config"
    local c = cfg.get()
    local v = cfg.resolve_voice(true)
    local neural = v and (v:find "Enhanced" or v:find "Premium")
    if neural then
      h.ok(("voice: %s (tone=%s) — warm neural voice"):format(v, c.tone))
    elseif v then
      h.ok(("voice: %s (tone=%s)"):format(v, c.tone))
    else
      h.warn("voice: system default (tone=" .. c.tone .. ") — no preferred voice installed")
    end
    if not neural then
      h.info(
        "For a warm, human voice download a Premium/Enhanced one (Zoe, Ava, Evan): "
          .. "System Settings ▸ Accessibility ▸ Spoken Content ▸ Manage Voices — "
          .. 'auto-picked once installed. Siri voices: set voice = "Siri Voice 4".'
      )
    end
    local s = require("vdots.readaloud.pace").settings(c)
    h.ok(
      ("pace: %s (%d wpm; %dms between paragraphs, %dms before a section)"):format(
        c.pace,
        s.rate,
        s.para,
        s.section
      )
    )
  else
    h.error "`say` not found — read-aloud will not work"
  end

  if vim.v.servername ~= "" then
    h.ok("RPC server address: " .. vim.v.servername)
  else
    h.warn "v:servername is empty — media keys / SwiftBar cannot reach this instance"
  end

  local mk = require "vdots.readaloud.mediakeys"
  if vim.fn.executable "swiftc" == 1 then
    local ok, err = mk.build()
    if ok then
      h.ok("media-key helper built: " .. mk.bin)
    else
      h.warn("media-key helper did not build: " .. tostring(err))
    end
  else
    h.warn "swiftc not found — hardware media keys disabled (Xcode CLT: xcode-select --install)"
  end
  h.info "media keys are best-effort: an active Music/Spotify/video session wins them"

  if vim.fn.executable "ffmpeg" == 1 then
    h.ok "ffmpeg found — chapters embedded in the .m4a, audio time-stretched for pace"
  else
    h.info "ffmpeg not found — no chapters in the .m4a, no pace time-stretch"
  end
  if vim.fn.executable "rubberband" == 1 then
    h.ok "rubberband found — high-quality (R3) time-stretch for the spoken pace"
  else
    h.info "rubberband not found — pace time-stretch falls back to ffmpeg atempo (`brew install rubberband`)"
  end
  if vim.fn.executable "rsvg-convert" == 1 then
    h.ok "rsvg-convert found — publish renders the read-along video and guide.pdf"
  else
    h.info "rsvg-convert not found — no readalong.mp4, no guide.pdf (`brew install librsvg`)"
  end
  if vim.fn.executable "jq" == 1 then
    h.ok "jq found"
  else
    h.warn "jq not found — :VdotsReadPublish cannot read frontmatter (plain-doc fallback)"
  end

  local ok_rm = pcall(require, "render-markdown")
  if ok_rm then
    h.ok "render-markdown.nvim present (preview pane renders)"
  else
    h.warn "render-markdown.nvim not found — the preview pane shows raw Markdown"
  end

  local shim = (vim.env.HOME or "") .. "/.swiftbar/vdots-readaloud.5s.sh"
  if vim.fn.filereadable(shim) == 1 then
    h.ok("SwiftBar shim installed: " .. shim)
  else
    h.info "SwiftBar remote not installed (optional) — `vdots doctor --fix` installs it"
  end

  local ldir =
    vim.fn.expand(require("vdots.readaloud.config").get().listen_dir or "~/ai/outbox/listen")
  if vim.fn.isdirectory(ldir) == 1 then
    h.ok("listen library: " .. ldir)
  else
    h.info(
      "listen library not created yet: "
        .. ldir
        .. " (:VdotsReadPublish or `vdots doctor --fix` creates it)"
    )
  end
  if
    vim.fn.isdirectory((vim.env.HOME or "") .. "/ai/.tmp.driveupload") == 1
    or vim.fn.isdirectory((vim.env.HOME or "") .. "/Library/CloudStorage") == 1
  then
    h.ok "Google Drive desktop present — the listen library syncs automatically"
  else
    h.info "Google Drive desktop not detected — published sessions stay local"
  end

  for _, d in ipairs(require("vdots.readaloud.config").diagnose()) do
    if d.ok then
      h.ok("config: " .. d.msg)
    else
      h.error("config: " .. d.msg)
    end
  end
end

return M
