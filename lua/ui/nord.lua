local M = {}

---Apply the Nord colorscheme and strip all italics.
---vim.g.nord_* globals must be set before calling (done in plugin init).
function M.setup()
  -- Apply theme
  local ok_nord, nord = pcall(require, "nord")
  if not ok_nord then
    return
  end
  nord.set()

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

  -- Trailing whitespace highlight (used by autocmds.lua)
  vim.api.nvim_set_hl(0, "BadWhitespace", { bg = "#BF616A" })

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

---@class NordPalette
---@field none    string
---@field bg      string
---@field bg_dark string
---@field bg_light string
---@field fg      string
---@field fg_light string
---@field fg_dark string
---@field red     string
---@field orange  string
---@field yellow  string
---@field green   string
---@field cyan    string
---@field blue    string
---@field magenta string
---@field gray    string
---@field gray_light string

---Nord color palette for use by other modules.
---@type NordPalette
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
