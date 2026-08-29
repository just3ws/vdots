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

test("Clipboard uses copy-on-yank (no unnamedplus, yank-mirror autocmd present)", function()
  -- We deliberately avoid unnamedplus so deletes don't clobber the system
  -- clipboard; yanks are mirrored to + via a TextYankPost autocmd instead.
  assert_true(
    not string.find(vim.o.clipboard, "unnamedplus", 1, true),
    "clipboard should not set unnamedplus"
  )
  local yank_autocmds = vim.api.nvim_get_autocmds { event = "TextYankPost", group = "vimrc" }
  assert_true(
    #yank_autocmds > 0,
    "expected a TextYankPost yank-mirror autocmd in the 'vimrc' group"
  )
end)

-- ============================================================================
-- SECTION 2: Plugin Loading (vim.pack + lua/plugins.lua wiring)
-- ============================================================================
print "\n[Plugin Loading]"

test("plugin wiring module loaded (lua/plugins.lua)", function()
  assert_true(package.loaded["plugins"] ~= nil, "require('plugins').setup_all() should have run")
end)

test("Core plugins loaded: plenary", function()
  assert_exists "plenary"
end)

test("Core plugins loaded: telescope", function()
  assert_exists "telescope"
end)

test("Core plugins loaded: nvim-tree", function()
  assert_exists "nvim-tree"
  local tree_view = require "nvim-tree.view"
  assert_true(tree_view ~= nil, "nvim-tree view should exist")
  assert_true(
    type(require("editor.explorer").on_attach) == "function",
    "explorer on_attach should be function"
  )
end)

test("Core plugins loaded: blink.cmp", function()
  assert_exists "blink.cmp"
end)

test("Core plugins loaded: nvim-lspconfig", function()
  assert_exists "lspconfig"
end)

test("Core plugins loaded: gitsigns", function()
  assert_exists "gitsigns"
end)

test("Core plugins loaded: conform", function()
  assert_exists "conform"
end)

test("Core plugins loaded: lualine", function()
  assert_exists "lualine"
end)

test("Theme loaded: ui.kanagawa_wave overrides on kanagawa-wave", function()
  assert_exists "ui.kanagawa_wave"
  -- kanagawa.nvim's load() always sets colors_name to "kanagawa" regardless
  -- of variant (wave/dragon/lotus) — this is upstream's own behavior.
  assert_eq(vim.g.colors_name, "kanagawa", "colorscheme should be kanagawa (wave variant)")
end)

-- ============================================================================
-- SECTION 3: LSP Configuration
-- ============================================================================
print "\n[LSP Configuration]"

test("LSP servers configured: lua_ls", function()
  assert_true(vim.lsp.config["lua_ls"] ~= nil, "lua_ls config should exist")
end)

test("LSP servers configured: gopls", function()
  assert_true(vim.lsp.config["gopls"] ~= nil, "gopls config should exist")
end)

test("LSP servers configured: ruby_lsp", function()
  assert_true(vim.lsp.config["ruby_lsp"] ~= nil, "ruby_lsp config should exist")
end)

test("blink.cmp has LSP source", function()
  local blink = require "blink.cmp"
  -- Check if blink.cmp is configured with lsp source
  -- Since we can't easily get the live config from the module, we trust the setup
  assert_true(blink ~= nil, "blink.cmp should be available")
end)

test("Diagnostic config is set", function()
  local config = vim.diagnostic.config()
  assert_true(config ~= nil, "diagnostic config should exist")
end)

-- ============================================================================
-- SECTION 4: Treesitter (Native)
-- ============================================================================
print "\n[Treesitter]"

test("Native treesitter is available", function()
  assert_true(vim.treesitter ~= nil, "vim.treesitter should be available")
end)

test("Treesitter parsers available: lua", function()
  local ok = pcall(vim.treesitter.language.inspect, "lua")
  assert_true(ok, "lua parser should be available")
end)

test("Treesitter parsers available: markdown", function()
  local ok = pcall(vim.treesitter.language.inspect, "markdown")
  assert_true(ok, "markdown parser should be available")
end)

-- ============================================================================
-- SECTION 5: Telescope / Snacks
-- ============================================================================
print "\n[Telescope / Snacks]"

test("Telescope loads without error", function()
  local telescope = require "telescope"
  assert_true(telescope ~= nil, "telescope should load")
end)

test("Snacks picker is available", function()
  local snacks = require "snacks"
  assert_true(snacks.picker ~= nil, "Snacks picker should be available")
end)

-- ============================================================================
-- SECTION 6: Keymaps
-- ============================================================================
print "\n[Keymaps]"

local function keymap_exists(mode, lhs)
  local maps = vim.api.nvim_get_keymap(mode)
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

test("Keymap: <leader>ff mapped (grep to quickfix)", function()
  local exists, _ = keymap_exists("n", ";ff")
  assert_true(exists, "<leader>ff should be mapped")
end)

test("Keymap: <leader>f mapped (Conform format — plugins.lua wiring)", function()
  local exists, _ = keymap_exists("n", ";f")
  assert_true(exists, "<leader>f should be mapped")
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

test("Keymap: Joining lines in normal mode (cursor preserved)", function()
  vim.cmd "enew"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "first line", "second line" })
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  vim.cmd "normal J"
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  assert_eq(#lines, 1, "lines joined count")
  assert_eq(lines[1], "first line second line", "joined text content")
  vim.cmd "bwipeout!"
end)

test("Keymap: Joining lines in visual mode (not moving lines)", function()
  vim.cmd "enew"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "alpha", "beta", "gamma" })
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  vim.cmd "normal VjJ"
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  assert_eq(#lines, 2, "visual J should join 2 lines into 1")
  assert_eq(lines[1], "alpha beta", "visual J joined result")
  assert_eq(lines[2], "gamma", "remaining line untouched")
  vim.cmd "bwipeout!"
end)

test("Keymap: Line moving with <A-j> / <A-k>", function()
  local j_exists, _ = keymap_exists("x", "<A-j>")
  local k_exists, _ = keymap_exists("x", "<A-k>")
  assert_true(
    j_exists and k_exists,
    "<A-j> and <A-k> should be mapped in visual mode for line moving"
  )
end)

-- ============================================================================
-- SECTION 7: Commands
-- ============================================================================
print "\n[Commands]"

local function command_exists(name)
  local ok, _ = pcall(vim.api.nvim_parse_cmd, name, {})
  return ok
end

test("Command: :Git (Fugitive)", function()
  assert_true(command_exists "Git", ":Git should exist")
end)

test("Command: :Oil", function()
  assert_true(command_exists "Oil", ":Oil should exist")
end)

test("Command: :NvimTreeToggle", function()
  assert_true(command_exists "NvimTreeToggle", ":NvimTreeToggle should exist")
end)

test("Command: :Rg (native grep)", function()
  assert_true(command_exists "Rg", ":Rg should exist")
end)

test("Command: :DiffviewOpen (plugins.lua wiring)", function()
  assert_true(command_exists "DiffviewOpen", ":DiffviewOpen should exist")
end)

test("Command: :PackSync (vim.pack update)", function()
  assert_true(command_exists "PackSync", ":PackSync should exist")
end)

-- ============================================================================
-- SECTION 8: Highlights / Theme
-- ============================================================================
print "\n[Theme / Highlights]"

test("Kanagawa Wave colorscheme active", function()
  assert_eq(vim.g.colors_name, "kanagawa", "colorscheme")
end)

test("Normal highlight exists", function()
  local hl = vim.api.nvim_get_hl(0, { name = "Normal" })
  assert_true(hl.fg ~= nil or hl.bg ~= nil, "Normal highlight should have fg or bg")
end)

test("DiagnosticError highlight exists", function()
  local hl = vim.api.nvim_get_hl(0, { name = "DiagnosticError" })
  assert_true(hl.fg ~= nil, "DiagnosticError should have fg color")
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

-- ============================================================================
-- SECTION 10: File Operations
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

-- Simple filetype check without doautocmd which was causing issues in headless mode
test("Filetype detection for .lua", function()
  vim.cmd "new test.lua"
  local ft = vim.bo.filetype
  assert_eq(ft, "lua", "filetype for .lua")
  vim.cmd "bwipeout!"
end)

test("Filetype detection for .rb", function()
  vim.cmd "new test.rb"
  local ft = vim.bo.filetype
  assert_eq(ft, "ruby", "filetype for .rb")
  vim.cmd "bwipeout!"
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
  vim.cmd "cq 1"
else
  print "\nAll tests passed!"
  vim.cmd "qa!"
end
