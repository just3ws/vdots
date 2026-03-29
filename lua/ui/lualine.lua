local dracula = require("ui.dracula_pro").palette

local dracula_pro_theme = {
  normal = {
    a = { bg = dracula.purple, fg = dracula.bg, gui = "bold" },
    b = { bg = dracula.bg_light, fg = dracula.fg },
    c = { bg = dracula.bg_dark, fg = dracula.fg },
  },
  insert = {
    a = { bg = dracula.green, fg = dracula.bg, gui = "bold" },
    b = { bg = dracula.bg_light, fg = dracula.fg },
    c = { bg = dracula.bg_dark, fg = dracula.fg },
  },
  visual = {
    a = { bg = dracula.pink, fg = dracula.bg, gui = "bold" },
    b = { bg = dracula.bg_light, fg = dracula.fg },
    c = { bg = dracula.bg_dark, fg = dracula.fg },
  },
  replace = {
    a = { bg = dracula.red, fg = dracula.bg, gui = "bold" },
    b = { bg = dracula.bg_light, fg = dracula.fg },
    c = { bg = dracula.bg_dark, fg = dracula.fg },
  },
  command = {
    a = { bg = dracula.orange, fg = dracula.bg, gui = "bold" },
    b = { bg = dracula.bg_light, fg = dracula.fg },
    c = { bg = dracula.bg_dark, fg = dracula.fg },
  },
  inactive = {
    a = { bg = dracula.bg_dark, fg = dracula.gray },
    b = { bg = dracula.bg_dark, fg = dracula.gray },
    c = { bg = dracula.bg_dark, fg = dracula.gray },
  },
}

require("lualine").setup {
  options = {
    theme = dracula_pro_theme,
    section_separators = "",
    component_separators = "",
    globalstatus = true,
  },
}
