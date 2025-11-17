-- ============================================================================
-- 🧩 Neovim Healthcheck / Deprecation Filter with Logging
-- ----------------------------------------------------------------------------
-- Filters out noisy upstream deprecation warnings (e.g. :sign_define) but
-- still shows all others. Logs suppressed ones to a file for traceability.
-- ============================================================================

local M = {}

-- Define path for log file
local log_dir = vim.fn.stdpath "data" .. "/logs"
local log_file = log_dir .. "/deprecations.log"

-- Ensure log directory exists
if vim.fn.isdirectory(log_dir) == 0 then
  vim.fn.mkdir(log_dir, "p")
end

-- Helper to write suppressed messages to log
local function log_deprecation(name, alt, version, plugin)
  local f = io.open(log_file, "a")
  if not f then
    return
  end
  local ts = os.date "%Y-%m-%d %H:%M:%S"
  f:write(
    string.format(
      "[%s] name=%s alt=%s version=%s plugin=%s\n",
      ts,
      tostring(name),
      tostring(alt),
      tostring(version),
      tostring(plugin)
    )
  )
  f:close()
end

-- Preserve original vim.deprecate
local original_deprecate = vim.deprecate

vim.deprecate = function(name, alt, version, plugin)
  -- Known upstream deprecations that are safe to ignore (Neovim 0.11.x)
  local known = {
    ["sign_define"] = true,
    [":sign-define"] = true,
    ["vim.fn.sign_define"] = true,
  }

  if type(name) == "string" then
    for pattern, _ in pairs(known) do
      if name:match(pattern) then
        log_deprecation(name, alt, version, plugin)
        return
      end
    end
  end

  -- Forward all other deprecations normally
  return original_deprecate(name, alt, version, plugin)
end

-- -- Optional: notify user where logs are stored
-- vim.schedule(function()
--   vim.notify("Deprecation filter active → logs at: " .. log_file, vim.log.levels.INFO)
-- end)

return M
