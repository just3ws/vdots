-- vdots.readaloud.mediakeys — macOS hardware media keys (F7/F8/F9, Touch Bar,
-- AirPods) via a small Swift "Now Playing" helper.
--
-- Best-effort: macOS routes media keys to whichever media app played most
-- recently, so an active Music/Spotify/browser-video session can steal them.
-- The SwiftBar remote (bin/vdots-readaloud-swiftbar) is the reliable fallback.

local M = {}

local handle = nil

local function cache_dir()
  local d = (vim.env.XDG_CACHE_HOME or (vim.env.HOME .. "/.cache")) .. "/vdots"
  vim.fn.mkdir(d, "p")
  return d
end

local function src_path()
  -- lua/vdots/readaloud/mediakeys.lua -> repo root -> bin/
  local here = debug.getinfo(1, "S").source:sub(2)
  local repo = vim.fn.fnamemodify(here, ":h:h:h:h")
  return repo .. "/bin/vdots-mediakey-helper.swift"
end

M.bin = cache_dir() .. "/vdots-mediakey-helper"

---Build the helper if the compiled binary is missing or older than the source.
---@return boolean ok, string? err
function M.build()
  local src = src_path()
  if vim.fn.filereadable(src) == 0 then
    return false, "helper source not found: " .. src
  end
  if vim.fn.executable "swiftc" == 0 then
    return false, "swiftc not found (install Xcode command-line tools)"
  end
  local bin_mtime = vim.fn.getftime(M.bin)
  if bin_mtime > 0 and bin_mtime >= vim.fn.getftime(src) then
    return true
  end
  local res = vim.system({ "swiftc", "-O", "-o", M.bin, src }, { text = true }):wait()
  if res.code ~= 0 then
    return false, "swiftc failed:\n" .. (res.stderr or "")
  end
  return true
end

function M.available()
  return vim.fn.has "mac" == 1
    and (vim.fn.executable(M.bin) == 1 or vim.fn.executable "swiftc" == 1)
end

---Start the helper, wiring its commands back to this Neovim over RPC.
function M.start()
  if handle or vim.fn.has "mac" == 0 then
    return
  end
  local ok, err = M.build()
  if not ok then
    vim.notify("readaloud: media keys unavailable — " .. err, vim.log.levels.DEBUG)
    return
  end
  handle = vim.system({ M.bin }, {
    env = { VDOTS_NVIM_ADDR = vim.v.servername, PATH = vim.env.PATH },
    text = true,
  }, function()
    handle = nil
  end)
end

function M.stop()
  if handle then
    local h = handle
    handle = nil
    pcall(function()
      h:kill(15)
    end)
  end
end

return M
