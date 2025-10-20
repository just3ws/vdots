-- vim: ft=lua tw=80
-- luacheck: globals std stds self cache ignore files
-- luacheck: no max line length

-- ============================================================================
-- 🧠 Base setup
-- ============================================================================

-- Explicitly tell Luacheck these lowercase globals are intentional
-- luacheck: ignore std stds self cache ignore files

stds = {}
files = {}

-- ============================================================================
-- 🌙 Neovim-specific standard (LuaJIT + vim API)
-- ============================================================================
stds.nvim = {
  read_globals = {
    "vim",  -- Neovim global API
    "jit",  -- LuaJIT runtime
  },
}

-- Default standard
std = "lua51+nvim"

-- ============================================================================
-- ⚙️ Behavior
-- ============================================================================
self = false
cache = true
redefined = false
unused_args = true
allow_defined_top = true

-- ============================================================================
-- 🚫 Ignore / Suppressions
-- ============================================================================
ignore = {
  "631",         -- line too long
  "212/_.*",     -- unused arg starting with "_"
  "122",         -- setting read-only field (common in API metatables)
  "113",         -- accessing undefined global (dynamic require, etc.)
  "111",         -- shadowing upvalue (often fine in closures)
}

-- ============================================================================
-- 📂 Per-directory rules
-- ============================================================================
files["lua/**/*.lua"] = {
  std = "lua51+nvim",
}

files["tests/**/*.lua"] = {
  std = "lua51+nvim",
  read_globals = {
    "describe", "context", "it",
    "before_each", "after_each",
    "setup", "teardown",
    "assert", "pending", "mock",
    "spy", "stub",
  },
}

-- ============================================================================
-- ✅ Return value
-- ============================================================================
return true
