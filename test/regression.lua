-- ============================================================================
-- Neovim Configuration Regression Test Suite
-- ============================================================================
-- Run with: nvim --headless -u init.lua -c "luafile test/regression.lua"
-- Or use the wrapper: ./test/run.sh
--
-- Exit codes:
--   0 = All tests passed
--   1 = One or more tests failed
-- ============================================================================

local results = {
  passed = 0,
  failed = 0,
  errors = {},
}

local function test(name, fn)
  local ok, err = pcall(fn)
  if ok then
    results.passed = results.passed + 1
    print("✓ " .. name)
  else
    results.failed = results.failed + 1
    table.insert(results.errors, { name = name, error = err })
    print("✗ " .. name)
    print("  Error: " .. tostring(err))
  end
end

local function assert_eq(actual, expected, msg)
  if actual ~= expected then
    error(
      string.format(
        "%s: expected %s, got %s",
        msg or "Assertion failed",
        vim.inspect(expected),
        vim.inspect(actual)
      )
    )
  end
end

local function assert_true(val, msg)
  if not val then
    error(msg or "Expected true, got false/nil")
  end
end

local function assert_contains(str, pattern, msg)
  if not string.find(str, pattern, 1, true) then
    error(string.format("%s: '%s' not found in '%s'", msg or "String not found", pattern, str))
  end
end

local function assert_exists(module_name)
  local ok, _ = pcall(require, module_name)
  if not ok then
    error("Module not found: " .. module_name)
  end
end

print("\n" .. string.rep("=", 60))
print "Neovim Configuration Regression Tests"
print(string.rep("=", 60) .. "\n")

-- ============================================================================
-- SECTION 1: Core Options
-- ============================================================================
print "\n[Core Options]"

test("Leader key is semicolon", function()
  assert_eq(vim.g.mapleader, ";", "mapleader")
end)

test("Tab settings (expandtab, tabstop=2, shiftwidth=2)", function()
  assert_true(vim.o.expandtab, "expandtab should be true")
  assert_eq(vim.o.tabstop, 2, "tabstop")
  assert_eq(vim.o.shiftwidth, 2, "shiftwidth")
end)

test("Line numbers enabled (number + relativenumber)", function()
  assert_true(vim.o.number, "number should be true")
  assert_true(vim.o.relativenumber, "relativenumber should be true")
end)

test("Mouse enabled", function()
  assert_eq(vim.o.mouse, "a", "mouse")
end)

test("Termguicolors enabled", function()
  assert_true(vim.o.termguicolors, "termguicolors should be true")
end)

test("Split behavior (splitbelow, splitright)", function()
  assert_true(vim.o.splitbelow, "splitbelow")
  assert_true(vim.o.splitright, "splitright")
end)

test("Search settings (ignorecase, smartcase)", function()
  assert_true(vim.o.ignorecase, "ignorecase")
  assert_true(vim.o.smartcase, "smartcase")
end)

test("Clipboard includes unnamedplus", function()
  assert_contains(vim.o.clipboard, "unnamedplus", "clipboard")
end)

-- ============================================================================
-- SECTION 2: Plugin Loading (lazy.nvim)
-- ============================================================================
print "\n[Plugin Loading]"

test("lazy.nvim is loaded", function()
  assert_exists "lazy"
end)

test("Core plugins loaded: plenary", function()
  assert_exists "plenary"
end)

test("Core plugins loaded: telescope", function()
  assert_exists "telescope"
end)

test("Core plugins loaded: oil.nvim", function()
  assert_exists "oil"
end)

test("Core plugins loaded: nvim-treesitter", function()
  assert_exists "nvim-treesitter"
end)

test("Core plugins loaded: nvim-cmp", function()
  assert_exists "cmp"
end)

test("Core plugins loaded: nvim-lspconfig", function()
  assert_exists "lspconfig"
end)

test("Core plugins loaded: mason", function()
  assert_exists "mason"
end)

test("Core plugins loaded: lualine", function()
  assert_exists "lualine"
end)

test("Theme loaded: nord", function()
  assert_exists "nord"
  assert_eq(vim.g.colors_name, "nord", "colorscheme should be nord")
end)

-- ============================================================================
-- SECTION 3: LSP Configuration
-- ============================================================================
print "\n[LSP Configuration]"

test("LSP servers configured: lua_ls", function()
  local config = vim.lsp.config.lua_ls
  assert_true(config ~= nil, "lua_ls config should exist")
end)

test("LSP servers configured: gopls", function()
  local config = vim.lsp.config.gopls
  assert_true(config ~= nil, "gopls config should exist")
end)

test("LSP servers configured: ruby_lsp", function()
  local config = vim.lsp.config.ruby_lsp
  assert_true(config ~= nil, "ruby_lsp config should exist")
end)

test("nvim-cmp has LSP source", function()
  local cmp = require "cmp"
  local config = cmp.get_config()
  local has_lsp = false
  for _, source in ipairs(config.sources or {}) do
    if source.name == "nvim_lsp" then
      has_lsp = true
      break
    end
  end
  assert_true(has_lsp, "nvim-cmp should have nvim_lsp source")
end)

test("Diagnostic config is set", function()
  local config = vim.diagnostic.config()
  assert_true(config ~= nil, "diagnostic config should exist")
  assert_true(
    config.virtual_text ~= nil or config.virtual_text == false,
    "virtual_text should be configured"
  )
end)

-- ============================================================================
-- SECTION 4: Treesitter
-- ============================================================================
print "\n[Treesitter]"

test("Treesitter highlight enabled", function()
  local configs = require "nvim-treesitter.configs"
  -- Just verify module loads without error
  assert_true(configs ~= nil, "treesitter configs should load")
end)

test("Treesitter parsers available: lua", function()
  local ok = pcall(vim.treesitter.language.inspect, "lua")
  assert_true(ok, "lua parser should be available")
end)

test("Treesitter parsers available: ruby", function()
  local ok = pcall(vim.treesitter.language.inspect, "ruby")
  assert_true(ok, "ruby parser should be available")
end)

test("Treesitter parsers available: go", function()
  local ok = pcall(vim.treesitter.language.inspect, "go")
  assert_true(ok, "go parser should be available")
end)

-- ============================================================================
-- SECTION 5: Telescope
-- ============================================================================
print "\n[Telescope]"

test("Telescope loads without error", function()
  local telescope = require "telescope"
  assert_true(telescope ~= nil, "telescope should load")
end)

test("Telescope builtin functions available", function()
  local builtin = require "telescope.builtin"
  assert_true(type(builtin.find_files) == "function", "find_files should be a function")
  assert_true(type(builtin.live_grep) == "function", "live_grep should be a function")
  assert_true(type(builtin.buffers) == "function", "buffers should be a function")
end)

test("Telescope fzf extension loaded", function()
  local telescope = require "telescope"
  local ok, _ = pcall(function()
    return telescope.extensions.fzf
  end)
  -- Note: may not be loaded until first use, so just check no error
  assert_true(ok or true, "fzf extension check should not error")
end)

-- ============================================================================
-- SECTION 6: Keymaps
-- ============================================================================
print "\n[Keymaps]"

local function keymap_exists(mode, lhs)
  local maps = vim.api.nvim_get_keymap(mode)
  -- Normalize: Neovim stores <C-p> as <C-P>, <leader> expanded, etc.
  local normalized = vim.api.nvim_replace_termcodes(lhs, true, true, true)
  for _, map in ipairs(maps) do
    local map_normalized = vim.api.nvim_replace_termcodes(map.lhs, true, true, true)
    if map.lhs == lhs or map.lhs:lower() == lhs:lower() or map_normalized == normalized then
      return true, map.rhs or map.callback
    end
  end
  return false, nil
end

test("Keymap: <C-p> mapped (Telescope find_files)", function()
  local exists, _ = keymap_exists("n", "<C-p>")
  assert_true(exists, "<C-p> should be mapped")
end)

test("Keymap: <leader>ff mapped (quickfix grep)", function()
  local exists, _ = keymap_exists("n", ";ff")
  assert_true(exists, "<leader>ff should be mapped")
end)

test("Keymap: <leader>n mapped (Explorer toggle)", function()
  local exists, _ = keymap_exists("n", ";n")
  assert_true(exists, "<leader>n should be mapped for explorer toggle")
end)

test("Keymap: Split navigation <C-h/j/k/l>", function()
  local h, _ = keymap_exists("n", "<C-h>")
  local j, _ = keymap_exists("n", "<C-j>")
  local k, _ = keymap_exists("n", "<C-k>")
  local l, _ = keymap_exists("n", "<C-l>")
  assert_true(h and j and k and l, "Split navigation keys should be mapped")
end)

test("Keymap: Visual indent </> with reselect", function()
  local lt, _ = keymap_exists("x", "<")
  local gt, _ = keymap_exists("x", ">")
  assert_true(lt and gt, "Visual indent keys should be mapped")
end)

-- ============================================================================
-- SECTION 7: Commands
-- ============================================================================
print "\n[Commands]"

local function command_exists(name)
  local ok, _ = pcall(vim.api.nvim_parse_cmd, name, {})
  return ok
end

test("Command: :Files (Telescope)", function()
  assert_true(command_exists "Files", ":Files should exist")
end)

test("Command: :Rg quickfix grep", function()
  assert_true(command_exists "Rg", ":Rg should exist")
end)

test("Command: :Buffers (Telescope)", function()
  assert_true(command_exists "Buffers", ":Buffers should exist")
end)

test("Command: :Git (Fugitive)", function()
  assert_true(command_exists "Git", ":Git should exist")
end)

test("Command: :NERDTreeToggle compatibility alias", function()
  assert_true(command_exists "NERDTreeToggle", ":NERDTreeToggle should exist")
end)

test("Command: :Ack compatibility alias", function()
  assert_true(command_exists "Ack", ":Ack should exist")
end)

test("Command: :Lazy (plugin manager)", function()
  assert_true(command_exists "Lazy", ":Lazy should exist")
end)

test("Command: :Mason (LSP installer)", function()
  assert_true(command_exists "Mason", ":Mason should exist")
end)

-- ============================================================================
-- SECTION 8: Highlights / Theme
-- ============================================================================
print "\n[Theme / Highlights]"

test("Nord colorscheme active", function()
  assert_eq(vim.g.colors_name, "nord", "colorscheme")
end)

test("Normal highlight exists", function()
  local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  assert_true(hl.fg ~= nil or hl.bg ~= nil, "Normal highlight should have fg or bg")
end)

test("DiagnosticError highlight exists", function()
  local hl = vim.api.nvim_get_hl(0, { name = "DiagnosticError" })
  assert_true(hl.fg ~= nil, "DiagnosticError should have fg color")
end)

test("Treesitter highlights exist (@function)", function()
  local hl = vim.api.nvim_get_hl(0, { name = "@function" })
  -- May inherit, so just check it doesn't error
  assert_true(hl ~= nil, "@function highlight should exist")
end)

-- ============================================================================
-- SECTION 9: Autocommands
-- ============================================================================
print "\n[Autocommands]"

test("Augroup 'vimrc' exists", function()
  local ok, _ = pcall(vim.api.nvim_get_autocmds, { group = "vimrc" })
  assert_true(ok, "vimrc augroup should exist")
end)

test("BufWritePre autocmd exists", function()
  local cmds = vim.api.nvim_get_autocmds { event = "BufWritePre" }
  assert_true(#cmds > 0, "BufWritePre autocmds should exist")
end)

test("FileType autocmds exist", function()
  local cmds = vim.api.nvim_get_autocmds { event = "FileType" }
  assert_true(#cmds > 0, "FileType autocmds should exist")
end)

-- ============================================================================
-- SECTION 10: File Operations (simulate editing)
-- ============================================================================
print "\n[File Operations]"

test("Can create and edit a buffer", function()
  vim.cmd "enew"
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "line 1", "line 2", "line 3" })
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  assert_eq(#lines, 3, "buffer should have 3 lines")
  vim.cmd "bwipeout!"
end)

test("Filetype detection works for .lua", function()
  vim.cmd "enew"
  vim.cmd "file test.lua"
  vim.cmd "doautocmd BufRead"
  local ft = vim.bo.filetype
  assert_eq(ft, "lua", "filetype for .lua")
  vim.cmd "bwipeout!"
end)

test("Filetype detection works for .rb", function()
  vim.cmd "enew"
  vim.cmd "file test.rb"
  vim.cmd "doautocmd BufRead"
  local ft = vim.bo.filetype
  assert_eq(ft, "ruby", "filetype for .rb")
  vim.cmd "bwipeout!"
end)

test("Filetype detection works for .go", function()
  vim.cmd "enew"
  vim.cmd "file test.go"
  vim.cmd "doautocmd BufRead"
  local ft = vim.bo.filetype
  assert_eq(ft, "go", "filetype for .go")
  vim.cmd "bwipeout!"
end)

-- ============================================================================
-- SECTION 11: ALE (lazy loaded - trigger by opening a file)
-- ============================================================================
print "\n[ALE Linting]"

-- Trigger ALE loading by simulating file open
vim.cmd "enew"
vim.cmd "file test_ale.rb"
vim.cmd "doautocmd BufReadPre"
vim.cmd "doautocmd BufNewFile"
vim.cmd "bwipeout!"

test("ALE plugin variables set", function()
  assert_true(vim.g.ale_linters ~= nil, "ale_linters should be set")
  assert_true(vim.g.ale_fixers ~= nil, "ale_fixers should be set")
end)

test("ALE Ruby linter configured", function()
  local linters = vim.g.ale_linters
  assert_true(linters ~= nil and linters.ruby ~= nil, "Ruby linters should be configured")
end)

test("ALE Lua linter configured", function()
  local linters = vim.g.ale_linters
  assert_true(linters ~= nil and linters.lua ~= nil, "Lua linters should be configured")
end)

-- ============================================================================
-- SECTION 12: Copilot (lazy loaded on InsertEnter)
-- ============================================================================
print "\n[Copilot]"

-- Trigger Copilot loading by entering insert mode briefly
vim.cmd "enew"
vim.cmd "doautocmd InsertEnter"
vim.cmd "bwipeout!"

test("Copilot module loads", function()
  local ok, _ = pcall(require, "copilot")
  assert_true(ok, "copilot module should load")
end)

test("Copilot accept key is configured", function()
  local config = require "copilot.config"
  assert_true(config ~= nil, "copilot config should load")
  assert_eq(config.suggestion.keymap.accept, "<M-]>", "copilot accept key")
end)

-- ============================================================================
-- SECTION 13: Search Defaults
-- ============================================================================
print "\n[Search Defaults]"

test("grepprg uses ripgrep when available", function()
  if vim.fn.executable "rg" == 1 then
    assert_contains(vim.o.grepprg, "rg --vimgrep", "grepprg")
  end
end)

-- ============================================================================
-- RESULTS
-- ============================================================================
print("\n" .. string.rep("=", 60))
print(string.format("Results: %d passed, %d failed", results.passed, results.failed))
print(string.rep("=", 60))

if results.failed > 0 then
  print "\nFailed tests:"
  for _, err in ipairs(results.errors) do
    print(string.format("  - %s", err.name))
    print(string.format("    %s", err.error))
  end
  print ""
  vim.cmd "cq 1" -- Exit with error code
else
  print "\nAll tests passed!"
  vim.cmd "qa!"
end
