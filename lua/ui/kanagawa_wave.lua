local M = {}

---@class KanagawaWavePalette
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

-- Fallback hex (verified against iTerm2-Color-Schemes' Kanagawa Wave.itermcolors)
-- for the same-machine-not-yet-installed race guarded in init.lua.
local fallback = {
  bg = "#1F1F28",
  bg_dark = "#16161D",
  bg_light = "#2A2A37",
  fg = "#DCD7BA",
  fg_light = "#DCD7BA",
  fg_dark = "#C8C093",
  red = "#C34043",
  orange = "#FFA066",
  yellow = "#E6C384",
  green = "#98BB6C",
  cyan = "#7AA89F",
  pink = "#D27E99",
  purple = "#957FB8",
  gray = "#727169",
  gray_light = "#54546D",
}

local ok, kanagawa_colors = pcall(function()
  return require("kanagawa.colors").setup { theme = "wave" }
end)

local resolved = fallback
if ok and kanagawa_colors and kanagawa_colors.palette then
  local p = kanagawa_colors.palette
  resolved = {
    bg = p.sumiInk3,
    bg_dark = p.sumiInk0,
    bg_light = p.sumiInk4,
    fg = p.fujiWhite,
    fg_light = p.fujiWhite,
    fg_dark = p.oldWhite,
    red = p.autumnRed,
    orange = p.surimiOrange,
    yellow = p.carpYellow,
    green = p.springGreen,
    cyan = p.waveAqua2,
    pink = p.sakuraPink,
    purple = p.oniViolet,
    gray = p.fujiGray,
    gray_light = p.sumiInk4,
  }
end

-- ponytail: bg hand-tuned bluer/more saturated than canonical Sumi Ink3
-- (#1F1F28 -> #1A1B2F), overriding both the fallback and the live plugin
-- value; every other field stays exactly what kanagawa.nvim reports.
resolved.bg = "#1A1B2F"
resolved.none = "NONE"

---Kanagawa Wave color palette (sourced from kanagawa.nvim when installed).
---@type KanagawaWavePalette
M.palette = resolved

function M.setup()
  -- Highlight overrides layered on the active colorscheme (kanagawa-wave);
  -- this module owns the same override set dracula_pro used to, recolored.
  local function hl(name, opts)
    vim.api.nvim_set_hl(0, name, opts)
  end

  local p = M.palette

  -- Diagnostics
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

  -- Flush the gutter and end-of-buffer to the editor bg: the kanagawa.setup
  -- ui.bg override (init.lua) already recolors Normal, but SignColumn and
  -- EndOfBuffer keep their own shades unless forced, breaking the seamless bg.
  hl("Normal", { bg = p.bg, fg = p.fg })
  hl("NormalNC", { bg = p.bg, fg = p.fg })
  hl("SignColumn", { bg = p.bg })
  hl("EndOfBuffer", { bg = p.bg, fg = p.bg })

  hl("Pmenu", { bg = p.bg_dark, fg = p.fg })
  hl("PmenuSel", { bg = p.bg_light, fg = p.fg_light, bold = true })
  hl("FloatBorder", { fg = p.purple, bg = "NONE" })
  hl("NormalFloat", { bg = p.bg_dark })

  -- Indent-blankline overrides
  hl("IblIndent", { fg = p.bg_light, nocombine = true })
  hl("IblScope", { fg = p.purple, nocombine = true })

  -- Ackrc syntax integration
  hl("ackrcDirective", { fg = p.purple, bold = true })
  hl("ackrcIgnoreDirOption", { fg = p.purple, bold = true })
  hl("ackrcTypeOption", { fg = p.purple, bold = true })
  hl("ackrcTypeDelOption", { fg = p.purple, bold = true })
  hl("ackrcTypeFilterOption", { fg = p.purple, bold = true })
  hl("ackrcTypeShortOption", { fg = p.purple, bold = true })
  hl("ackrcTypeLongOption", { fg = p.purple, bold = true })
  hl("ackrcDirectoryName", { fg = p.yellow })
  hl("ackrcColorOption", { fg = p.orange, bold = true })
  hl("ackrcFlag", { fg = p.cyan })
  hl("ackrcShortFlag", { fg = p.cyan })
  hl("ackrcFilterType", { fg = p.yellow, bold = true })
  hl("ackrcTypeName", { fg = p.cyan, bold = true })
  hl("ackrcTypeNameDel", { fg = p.cyan, bold = true })
  hl("ackrcExtension", { fg = p.green })
  hl("ackrcRegex", { fg = p.pink })
  hl("ackrcRegexEscape", { fg = p.yellow })
  hl("ackrcDelimiter", { fg = p.gray })
  hl("ackrcNumber", { fg = p.orange })
  hl("ackrcComment", { fg = p.gray, italic = true })

  -- Color keywords rendered in Kanagawa Wave palette
  hl("ackrcModifierBold", { bold = true })
  hl("ackrcModifierItalic", { italic = true })
  hl("ackrcModifierUnderline", { underline = true })
  hl("ackrcModifier", { fg = p.fg_dark, italic = true })
  hl("ackrcColorBlack", { fg = p.gray_light })
  hl("ackrcColorRed", { fg = p.red, bold = true })
  hl("ackrcColorGreen", { fg = p.green, bold = true })
  hl("ackrcColorYellow", { fg = p.yellow, bold = true })
  hl("ackrcColorBlue", { fg = "#7E9CD8", bold = true })
  hl("ackrcColorMagenta", { fg = p.pink, bold = true })
  hl("ackrcColorCyan", { fg = p.cyan, bold = true })
  hl("ackrcColorWhite", { fg = p.fg, bold = true })
  hl("ackrcBgColorBlack", { bg = p.bg_dark, fg = p.fg })
  hl("ackrcBgColorRed", { bg = p.red, fg = p.fg })
  hl("ackrcBgColorGreen", { bg = p.green, fg = p.bg_dark })
  hl("ackrcBgColorYellow", { bg = p.yellow, fg = p.bg_dark })
  hl("ackrcBgColorBlue", { bg = "#7E9CD8", fg = p.bg_dark })
  hl("ackrcBgColorMagenta", { bg = p.pink, fg = p.bg_dark })
  hl("ackrcBgColorCyan", { bg = p.cyan, fg = p.bg_dark })
  hl("ackrcBgColorWhite", { bg = p.fg, fg = p.bg_dark })
  hl("ackrcRgbColor", { fg = p.orange, underline = true })
  hl("ackrcColorDefault", { fg = p.gray })
end

return M
