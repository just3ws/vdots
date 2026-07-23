-- ============================================================================
-- 🤖  claude.lua — Claude Code session awareness
-- ============================================================================
-- Detects whether a Claude Code session is live in *this* repo and exposes:
--   • a pulsing lualine component (M.status / M.color)
--   • :ClaudeDiff / <leader>gC — open Diffview on the file Claude last touched
--
-- Detection: Claude Code streams its session transcript to
-- ~/.claude/projects/<cwd-with-/-and-.-replaced-by-->/<uuid>.jsonl and keeps
-- writing while it works. If the newest transcript was touched within
-- THRESHOLD seconds, a session is considered active. Result is cached for 2s
-- so the pulse timer stays cheap.
-- ============================================================================

local M = {}

local THRESHOLD = 45 -- seconds since last transcript write to count as "active"
local PULSE = { "●", "◕", "◑", "◔", "○", "◔", "◑", "◕" } -- breathing indicator

local function transcript_dir()
  local enc = vim.fn.getcwd():gsub("[/.]", "-")
  return vim.fn.expand "~/.claude/projects/" .. enc
end

local cache = { at = 0, active = false }
function M.is_active()
  local now = os.time()
  if now - cache.at < 2 then
    return cache.active
  end
  cache.at = now
  local newest = 0
  for _, f in ipairs(vim.fn.glob(transcript_dir() .. "/*.jsonl", false, true)) do
    local mt = vim.fn.getftime(f)
    if mt > newest then
      newest = mt
    end
  end
  cache.active = newest > 0 and (now - newest) <= THRESHOLD
  return cache.active
end

-- ---------------------------------------------------------------------------
-- Pulsing lualine component
-- ---------------------------------------------------------------------------
local frame = 1

function M.status()
  if not M.is_active() then
    return ""
  end
  return "󰭹 claude " .. PULSE[frame]
end

function M.color()
  local p = require("ui.kanagawa_wave").palette
  -- Breathe between bright and dim by walking the pulse cycle.
  local dim = frame > #PULSE / 2
  return { fg = dim and p.gray or p.green, gui = "bold" }
end

-- ---------------------------------------------------------------------------
-- Diff the file Claude last touched (newest mtime among git-changed files)
-- ---------------------------------------------------------------------------
function M.last_changed_file()
  local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
  local out = vim.fn.systemlist {
    "git",
    "-C",
    root,
    "-c",
    "status.relativePaths=false",
    "status",
    "--porcelain",
    "-uall",
  }
  if vim.v.shell_error ~= 0 then
    return nil
  end
  local newest, newest_mt = nil, 0
  for _, line in ipairs(out) do
    local path = line:sub(4) -- strip "XY " status prefix
    path = path:gsub('^"', ""):gsub('"$', "")
    if path:find " -> " then -- renames: take the destination
      path = path:gsub(".* %-> ", "")
    end
    local abs = root .. "/" .. path
    local mt = vim.fn.getftime(abs)
    if mt > newest_mt then
      newest_mt, newest = mt, path
    end
  end
  return newest
end

function M.diff_last_change()
  local file = M.last_changed_file()
  if not file then
    vim.notify("🤖 No changed files to diff.", vim.log.levels.WARN, { title = "Claude Code" })
    return
  end
  vim.notify(
    "🤖 Diffing " .. vim.fn.fnamemodify(file, ":t"),
    vim.log.levels.INFO,
    { title = "Claude Code" }
  )
  vim.cmd("DiffviewOpen -- " .. vim.fn.fnameescape(file))
end

-- ---------------------------------------------------------------------------
-- Setup: pulse timer (only refreshes lualine while a session is active) + maps
-- ---------------------------------------------------------------------------
function M.setup()
  local timer = vim.uv.new_timer()
  timer:start(
    1000,
    600,
    vim.schedule_wrap(function()
      if M.is_active() then
        frame = (frame % #PULSE) + 1
        pcall(function()
          require("lualine").refresh()
        end)
      end
    end)
  )

  vim.api.nvim_create_user_command("ClaudeDiff", M.diff_last_change, {
    desc = "Diffview the file Claude Code last touched",
  })
  vim.keymap.set("n", "<leader>gC", M.diff_last_change, { desc = "Diff Claude's last change" })
end

return M
