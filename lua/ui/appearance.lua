---Follow the macOS appearance. 'background' is set from it at startup, and a
---timer keeps checking while a UI is attached, so an open editor flips with
---the system. Setting 'background' reloads kanagawa (Lotus or Wave), and the
---ColorScheme autocmds put the overrides back on top.
local M = {}

local DEFAULTS = "/usr/bin/defaults"

---How often to check, in milliseconds.
M.interval = 3000

---@type uv.uv_timer_t?
M.timer = nil

---The last appearance macOS reported. Only a change to it moves 'background',
---so a manual :set background stays until macOS flips.
---@type "light"|"dark"?
M.last = nil

---@param code integer exit code of `defaults read -g AppleInterfaceStyle`
---@return "light"|"dark"
local function from_exit(code)
  return code == 0 and "dark" or "light"
end

---Read the appearance without blocking.
---@param done fun(bg: "light"|"dark")
function M.read(done)
  vim.system({ DEFAULTS, "read", "-g", "AppleInterfaceStyle" }, {}, function(out)
    done(from_exit(out.code))
  end)
end

---@param bg "light"|"dark"
local function follow(bg)
  if bg == M.last then
    return
  end
  M.last = bg
  if vim.o.background ~= bg then
    vim.o.background = bg
  end
end

---Set 'background' from macOS now (blocking; used once at startup).
function M.sync()
  if vim.fn.executable(DEFAULTS) ~= 1 then
    return
  end
  local out = vim.system({ DEFAULTS, "read", "-g", "AppleInterfaceStyle" }):wait()
  follow(from_exit(out.code))
end

---Check every `interval` ms and follow a change.
---@param interval integer?
---@param read fun(done: fun(bg: "light"|"dark"))? defaults to M.read
function M.watch(interval, read)
  M.stop()
  interval = interval or M.interval
  read = read or M.read
  M.last = M.last or vim.o.background
  M.timer = vim.uv.new_timer()
  M.timer:start(interval, interval, function()
    read(vim.schedule_wrap(follow))
  end)
end

function M.stop()
  if M.timer then
    M.timer:stop()
    M.timer:close()
    M.timer = nil
  end
end

---Sync now; start watching once a UI attaches (never headless).
function M.setup()
  M.sync()
  if vim.fn.executable(DEFAULTS) ~= 1 then
    return
  end
  vim.api.nvim_create_autocmd("UIEnter", {
    group = vim.api.nvim_create_augroup("AppearanceFollow", { clear = true }),
    once = true,
    callback = function()
      M.watch()
    end,
  })
end

return M
