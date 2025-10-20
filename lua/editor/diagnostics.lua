-- ============================================================================
-- Neovim Diagnostics (Nord-themed, ALE-style replacement)
-- ============================================================================

local nord = require "theme.nord"
local set_hl = vim.api.nvim_set_hl

-- ─────────────────────────────────────────────────────────────────────────────
-- Diagnostic Sign Icons
-- ─────────────────────────────────────────────────────────────────────────────
local signs = {
  Error = " ",
  Warn = " ",
  Info = " ",
  Hint = " ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Diagnostic Configuration
-- ─────────────────────────────────────────────────────────────────────────────
vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
    spacing = 2,
    format = function(diagnostic)
      local labels = {
        [vim.diagnostic.severity.ERROR] = "ERR",
        [vim.diagnostic.severity.WARN] = "WRN",
        [vim.diagnostic.severity.INFO] = "INF",
        [vim.diagnostic.severity.HINT] = "HNT",
      }
      local label = labels[diagnostic.severity] or ""
      return string.format("%s %s", label, diagnostic.message)
    end,
  },
  float = {
    border = "rounded",
    source = "if_many",
    header = { " Diagnostics", "Title" },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

-- ─────────────────────────────────────────────────────────────────────────────
-- Highlight Groups — tuned for Nord
-- ─────────────────────────────────────────────────────────────────────────────
local hl_map = {
  DiagnosticError = { fg = nord.red, bold = true },
  DiagnosticWarn = { fg = nord.yellow, bold = true },
  DiagnosticInfo = { fg = nord.cyan, bold = true },
  DiagnosticHint = { fg = nord.green, bold = false },

  DiagnosticSignError = { fg = nord.red, bg = "NONE" },
  DiagnosticSignWarn = { fg = nord.yellow, bg = "NONE" },
  DiagnosticSignInfo = { fg = nord.cyan, bg = "NONE" },
  DiagnosticSignHint = { fg = nord.green, bg = "NONE" },

  DiagnosticUnderlineError = { undercurl = true, sp = nord.red },
  DiagnosticUnderlineWarn = { undercurl = true, sp = nord.yellow },
  DiagnosticUnderlineInfo = { undercurl = true, sp = nord.cyan },
  DiagnosticUnderlineHint = { undercurl = true, sp = nord.green },

  DiagnosticVirtualTextError = { fg = nord.red, bg = nord.bg_light },
  DiagnosticVirtualTextWarn = { fg = nord.yellow, bg = nord.bg_light },
  DiagnosticVirtualTextInfo = { fg = nord.cyan, bg = nord.bg_light },
  DiagnosticVirtualTextHint = { fg = nord.green, bg = nord.bg_light },

  FloatBorder = { fg = nord.blue, bg = nord.bg_dark },
  NormalFloat = { fg = nord.fg, bg = nord.bg_dark },
}

for group, opts in pairs(hl_map) do
  set_hl(0, group, opts)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- Optional: show diagnostics in floating window on hover
-- ─────────────────────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false, border = "rounded" })
  end,
})
