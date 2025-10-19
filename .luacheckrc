-- vim: ft=lua tw=80
-- luacheck: globals std stds self cache ignore files exclude_files
-- luacheck: no max line length

-- Explicitly tell Luacheck these lowercase globals are intentional
-- luacheck: ignore std stds self cache ignore files exclude_files

-- Define config tables explicitly
stds = {}
files = {}

-- Neovim-specific globals
stds.nvim = {
  read_globals = {
    "vim",  -- Neovim API
    "jit",  -- LuaJIT runtime
  },
}

-- Base standard
std = "lua51+nvim"

-- Linting behavior
self = false
cache = true

-- Ignore patterns
ignore = {
  "631",       -- line too long
  "212/_.*",   -- unused arg starting with "_"
  "122",       -- setting read-only field
  "113",       -- undefined global (dynamic require)
}

-- Per-directory overrides
files["lua/**/*.lua"] = {
  std = "lua51+nvim",
}

-- Test-specific globals (Busted / Plenary)
files["tests/**/*.lua"] = {
  std = "lua51+nvim",
  read_globals = {
    "describe", "context", "it",
    "before_each", "after_each",
    "setup", "teardown",
    "assert", "pending", "mock",
  },
}

-- Exclude generated files
exclude_files = {
  "plugin/packer_compiled.lua",
}

-- Return true so formatters stop parsing here
return true
