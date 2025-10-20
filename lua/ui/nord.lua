-- ============================================================================
-- Nord Theme (Palette + UI Integration)
-- Centralized color control for Neovim
-- ============================================================================

local M = {}

M.palette = {
  none        = "NONE",
  bg          = "#2E3440",
  bg_dark     = "#2B303B",
  bg_light    = "#3B4252",
  fg          = "#D8DEE9",
  fg_light    = "#E5E9F0",
  fg_dark     = "#C0C5CE",
  red         = "#BF616A",
  orange      = "#D08770",
  yellow      = "#EBCB8B",
  green       = "#A3BE8C",
  cyan        = "#88C0D0",
  blue        = "#81A1C1",
  magenta     = "#B48EAD",
  gray        = "#4C566A",
  gray_light  = "#616E88",
}

function M.setup()
  local nord = M.palette

  -- Global theme settings for shaunsingh/nord.nvim
  vim.g.nord_contrast = true
  vim.g.nord_borders = true
  vim.g.nord_disable_background = false
  vim.g.nord_cursorline_transparent = false
  vim.g.nord_enable_sidebar_background = false
  vim.g.nord_italic = false
  vim.g.nord_uniform_diff_background = true
  vim.g.nord_bold = true
  vim.g.nord_uniform_status_lines = true
  vim.g.nord_bold_vertical_split_line = false
  vim.g.nord_italic_comments = false
  vim.g.nord_underline = true

  require("nord").set()

  local hl = vim.api.nvim_set_hl
  hl(0, "Comment", { fg = nord.gray_light, italic = false })
  hl(0, "DiagnosticHint",  { fg = nord.cyan, italic = false })
  hl(0, "DiagnosticInfo",  { fg = nord.blue, italic = false })
  hl(0, "DiagnosticWarn",  { fg = nord.yellow, italic = false })
  hl(0, "DiagnosticError", { fg = nord.red, italic = false })
  hl(0, "WinSeparator",    { fg = nord.bg_light, bg = nord.bg_dark })
  hl(0, "NormalFloat",     { fg = nord.fg, bg = nord.bg_dark })
  hl(0, "FloatBorder",     { fg = nord.blue, bg = nord.bg_dark })
  hl(0, "Pmenu",           { fg = nord.fg, bg = nord.bg_light })
  hl(0, "PmenuSel",        { fg = nord.bg_dark, bg = nord.cyan, bold = true })
  hl(0, "CursorLine",      { bg = nord.bg_light })
  hl(0, "DiffAdd",         { bg = "#3B4252", fg = nord.green })
  hl(0, "DiffChange",      { bg = "#3B4252", fg = nord.yellow })
  hl(0, "DiffDelete",      { bg = "#3B4252", fg = nord.red })
  hl(0, "DiffText",        { bg = "#434C5E", fg = nord.fg_light, bold = true })
end

return M

