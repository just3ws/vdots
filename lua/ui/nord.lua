local M = {}

function M.setup()
  -- Core Nord options
  vim.g.nord_contrast = true
  vim.g.nord_borders = true
  vim.g.nord_disable_background = false
  vim.g.nord_cursorline_transparent = false
  vim.g.nord_enable_sidebar_background = false
  vim.g.nord_italic = false
  vim.g.nord_italic_comments = false
  vim.g.nord_bold = true
  vim.g.nord_uniform_diff_background = true
  vim.g.nord_uniform_status_lines = true

  -- Apply theme
  require("nord").set()

  -- Force-disable italics globally
  local no_italic_groups = {
    "Comment",
    "Identifier",
    "Statement",
    "Keyword",
    "Type",
    "Special",
    "Function",
    "Conditional",
    "Repeat",
    "Operator",
    "Label",
    "Exception",
    "Include",
    "PreProc",
    "StorageClass",
    "Structure",
    "Constant",
    "String",
    "Character",
    "Number",
    "Boolean",
    "Float",
  }

  for _, group in ipairs(no_italic_groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    if ok then
      hl.italic = false
      vim.api.nvim_set_hl(0, group, hl)
    end
  end

  -- Diagnostics in Nord colors
  vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#BF616A", italic = false })
  vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#EBCB8B", italic = false })
  vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#81A1C1", italic = false })
  vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#88C0D0", italic = false })

  -- Optional: remove italics from Treesitter highlights
  local ts_groups = {
    "@comment",
    "@function",
    "@method",
    "@keyword",
    "@type",
    "@variable",
    "@parameter",
    "@property",
    "@field",
    "@namespace",
    "@operator",
  }
  for _, group in ipairs(ts_groups) do
    pcall(vim.api.nvim_set_hl, 0, group, { italic = false })
  end
end

M.palette = {
  none = "NONE",
  bg = "#2E3440",
  bg_dark = "#2B303B",
  bg_light = "#3B4252",
  fg = "#D8DEE9",
  fg_light = "#E5E9F0",
  fg_dark = "#C0C5CE",
  red = "#BF616A",
  orange = "#D08770",
  yellow = "#EBCB8B",
  green = "#A3BE8C",
  cyan = "#88C0D0",
  blue = "#81A1C1",
  magenta = "#B48EAD",
  gray = "#4C566A",
  gray_light = "#616E88",
}

return M
