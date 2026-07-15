local M = {}

---@class DraculaProPalette
---@field none     string
---@field bg       string
---@field bg_dark  string
---@field bg_light string
---@field fg       string
---@field fg_light string
---@field fg_dark  string
---@field red      string
---@field orange   string
---@field yellow   string
---@field green    string
---@field cyan     string
---@field pink     string
---@field purple   string
---@field gray     string
---@field gray_light string

---Dracula PRO color palette.
---@type DraculaProPalette
M.palette = {
  none = "NONE",
  bg = "#22212C",
  bg_dark = "#17161D",
  bg_light = "#454158",
  fg = "#F8F8F2",
  fg_light = "#FFFFFF",
  fg_dark = "#C6C6C2",
  red = "#FF9580",
  orange = "#FFCA80",
  yellow = "#FFFF80",
  green = "#8AFF80",
  cyan = "#80FFEA",
  pink = "#FF80BF",
  purple = "#9580FF",
  gray = "#7970A9",
  gray_light = "#504C67",
}

function M.setup()
  -- Highlight overrides layered on the active colorscheme (dracula); there is
  -- no dracula_pro colors file — this module owns the PRO palette + overrides.
  -- Custom highlight overrides for maximum Dracula Pro integration
  local function hl(name, opts)
    vim.api.nvim_set_hl(0, name, opts)
  end

  local p = M.palette

  -- Diagnostics (matching Dracula Pro palette)
  hl("DiagnosticError", { fg = p.red, italic = false })
  hl("DiagnosticWarn", { fg = p.yellow, italic = false })
  hl("DiagnosticInfo", { fg = p.purple, italic = false })
  hl("DiagnosticHint", { fg = p.cyan, italic = false })

  -- Gutter icons
  hl("DiagnosticSignError", { fg = p.red, bg = "NONE" })
  hl("DiagnosticSignWarn", { fg = p.yellow, bg = "NONE" })
  hl("DiagnosticSignInfo", { fg = p.purple, bg = "NONE" })
  hl("DiagnosticSignHint", { fg = p.cyan, bg = "NONE" })

  -- Underline for inline diagnostics
  hl("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.yellow })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.purple })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.cyan })

  -- Trailing whitespace highlight
  hl("BadWhitespace", { bg = p.red })

  -- Ensure transparency is handled if desired (keeping the default background for now as requested)
  -- But we can tweak some UI elements to be more "Pro"
  hl("Pmenu", { bg = p.bg_dark, fg = p.fg })
  hl("PmenuSel", { bg = p.bg_light, fg = p.fg_light, bold = true })
  hl("FloatBorder", { fg = p.purple, bg = "NONE" })
  hl("NormalFloat", { bg = p.bg_dark })

  -- Indent-blankline overrides
  hl("IblIndent", { fg = p.bg_light, nocombine = true })
  hl("IblScope", { fg = p.purple, nocombine = true })
end

return M
