local lint = require "lint"

-- ============================================================================
-- Define which linters run for which filetypes
-- ============================================================================
lint.linters_by_ft = {
  ruby = { "rubocop", "brakeman", "bundler_audit" },
  javascript = { "eslint" },
  json = { "eslint" },
  css = { "stylelint" },
  yaml = { "yamllint" },
  lua = { "luacheck" }, -- ✅ Add Lua support
}

-- ============================================================================
-- Custom linters: Brakeman + Bundler Audit
-- ============================================================================

lint.linters.brakeman = {
  cmd = "brakeman",
  stdin = false,
  args = { "--no-progress", "--format", "json" },
  parser = function(output)
    local ok, decoded = pcall(vim.json.decode, output)
    if not ok or not decoded.warnings then
      return {}
    end
    local diagnostics = {}
    for _, warning in ipairs(decoded.warnings) do
      table.insert(diagnostics, {
        lnum = (warning.line or 1) - 1,
        col = 0,
        message = warning.message or warning.warning_type,
        severity = vim.diagnostic.severity.WARN,
        source = "brakeman",
      })
    end
    return diagnostics
  end,
}

lint.linters.bundler_audit = {
  cmd = "bundle",
  stdin = false,
  args = { "audit", "--verbose" },
  parser = function(output)
    local diagnostics = {}
    for line in output:gmatch "[^\r\n]+" do
      if line:match "Insecure Source" or line:match "Vulnerable" then
        table.insert(diagnostics, {
          lnum = 0,
          col = 0,
          message = line,
          severity = vim.diagnostic.severity.ERROR,
          source = "bundler-audit",
        })
      end
    end
    return diagnostics
  end,
}

-- ============================================================================
-- Lua: Luacheck configuration
-- ============================================================================

lint.linters.luacheck = {
  cmd = "luacheck",
  stdin = false,
  args = {
    "--formatter",
    "plain",
    "--codes", -- show diagnostic codes like (W111)
    "--ranges", -- show column ranges
    "--filename",
    "%:p",
    "-", -- read file from stdin
  },
  stream = "stderr",
  ignore_exitcode = true,
  parser = require("lint.parser").from_errorformat("%f:%l:%c: (%t%n) %m,%-G%.%#", {
    source = "luacheck",
    severity_map = {
      E = vim.diagnostic.severity.ERROR,
      W = vim.diagnostic.severity.WARN,
    },
  }),
}

-- ============================================================================
-- Safe lint runner (skips missing binaries)
-- ============================================================================

local function safe_try_lint()
  local ft = vim.bo.filetype
  local linters = lint.linters_by_ft[ft] or {}
  if vim.tbl_isempty(linters) then
    -- Only notify in debug mode to reduce noise
    vim.notify_once("[nvim-lint] No linters configured for filetype: " .. ft, vim.log.levels.DEBUG)
    return
  end

  local ran = false
  for _, linter in ipairs(linters) do
    local def = lint.linters[linter]
    local cmd = def and def.cmd or linter
    if vim.fn.executable(cmd) == 1 then
      lint.try_lint(linter)
      ran = true
    else
      vim.notify_once("[nvim-lint] Skipping missing linter: " .. linter, vim.log.levels.DEBUG)
    end
  end

  if not ran then
    vim.notify_once("[nvim-lint] No available linters for filetype: " .. ft, vim.log.levels.DEBUG)
  end
end

-- ============================================================================
-- Autocommands & Manual Command
-- ============================================================================

-- Run lint automatically on save or leaving insert mode
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
  callback = safe_try_lint,
})

-- Manual trigger
vim.api.nvim_create_user_command("Lint", safe_try_lint, {})
