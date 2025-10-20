-- lua/ui/colors/nord.lua
local nord = require "theme.nord"

-- Global Nord options (see :help nord.nvim)
vim.g.nord_contrast = true -- Brighter statusline / splits
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

-- Apply Nord colorscheme
require("nord").set()

-- --- Highlight overrides for consistency ---
local set_hl = vim.api.nvim_set_hl

-- Comments and diagnostics (non-italic)
set_hl(0, "Comment", { fg = nord.gray_light, italic = false })
set_hl(0, "DiagnosticHint", { fg = nord.cyan, italic = false })
set_hl(0, "DiagnosticInfo", { fg = nord.blue, italic = false })
set_hl(0, "DiagnosticWarn", { fg = nord.yellow, italic = false })
set_hl(0, "DiagnosticError", { fg = nord.red, italic = false })

-- Borders and UI elements
set_hl(0, "WinSeparator", { fg = nord.bg_light, bg = nord.bg_dark })
set_hl(0, "NormalFloat", { bg = nord.bg_dark, fg = nord.fg })
set_hl(0, "FloatBorder", { fg = nord.blue, bg = nord.bg_dark })
set_hl(0, "Pmenu", { fg = nord.fg, bg = nord.bg_light })
set_hl(0, "PmenuSel", { fg = nord.bg_dark, bg = nord.cyan, bold = true })

-- Cursorline subtle highlight
set_hl(0, "CursorLine", { bg = nord.bg_light })

-- Git indicators
set_hl(0, "DiffAdd", { bg = "#3B4252", fg = nord.green })
set_hl(0, "DiffChange", { bg = "#3B4252", fg = nord.yellow })
set_hl(0, "DiffDelete", { bg = "#3B4252", fg = nord.red })
set_hl(0, "DiffText", { bg = "#434C5E", fg = nord.fg_light, bold = true })
