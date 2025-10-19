-- ~/.config/nvim/lua/colors/nord.lua
vim.g.nord_contrast = true -- Brighter statusline / splits
vim.g.nord_borders = true -- Define border colors
vim.g.nord_disable_background = false -- Keep background color (set true if using transparency)
vim.g.nord_cursorline_transparent = false
vim.g.nord_enable_sidebar_background = false
vim.g.nord_italic = false -- 🔧 disable italics globally
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = true -- Keep bold for emphasis
vim.g.nord_uniform_status_lines = true

-- Optional: Diagnostic styling to match LSP messages
vim.g.nord_bold_vertical_split_line = false
vim.g.nord_italic_comments = false -- Disable comment italics only
vim.g.nord_underline = true

-- Apply the colorscheme
require("nord").set()

-- Optional: override specific highlights (fine-tuning)
vim.api.nvim_set_hl(0, "Comment", { italic = false })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#88C0D0", italic = false })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#81A1C1", italic = false })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#EBCB8B", italic = false })
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#BF616A", italic = false })
