local kanagawa = require("ui.kanagawa_wave").palette

local kanagawa_wave_theme = {
  normal = {
    a = { bg = kanagawa.purple, fg = kanagawa.bg, gui = "bold" },
    b = { bg = kanagawa.bg_light, fg = kanagawa.fg },
    c = { bg = kanagawa.bg_dark, fg = kanagawa.fg },
  },
  insert = {
    a = { bg = kanagawa.green, fg = kanagawa.bg, gui = "bold" },
    b = { bg = kanagawa.bg_light, fg = kanagawa.fg },
    c = { bg = kanagawa.bg_dark, fg = kanagawa.fg },
  },
  visual = {
    a = { bg = kanagawa.pink, fg = kanagawa.bg, gui = "bold" },
    b = { bg = kanagawa.bg_light, fg = kanagawa.fg },
    c = { bg = kanagawa.bg_dark, fg = kanagawa.fg },
  },
  replace = {
    a = { bg = kanagawa.red, fg = kanagawa.bg, gui = "bold" },
    b = { bg = kanagawa.bg_light, fg = kanagawa.fg },
    c = { bg = kanagawa.bg_dark, fg = kanagawa.fg },
  },
  command = {
    a = { bg = kanagawa.orange, fg = kanagawa.bg, gui = "bold" },
    b = { bg = kanagawa.bg_light, fg = kanagawa.fg },
    c = { bg = kanagawa.bg_dark, fg = kanagawa.fg },
  },
  inactive = {
    a = { bg = kanagawa.bg_dark, fg = kanagawa.gray },
    b = { bg = kanagawa.bg_dark, fg = kanagawa.gray },
    c = { bg = kanagawa.bg_dark, fg = kanagawa.gray },
  },
}

local function rails_env()
  local is_rails = vim.fn.filereadable "config/environment.rb" ~= 0
  if not is_rails then
    return ""
  end
  local env = vim.env.RAILS_ENV or "development"
  return "󰴭 " .. env
end

require("lualine").setup {
  options = {
    theme = kanagawa_wave_theme,
    section_separators = "",
    component_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = {
      {
        require("editor.claude").status,
        color = require("editor.claude").color,
      },
      rails_env,
      "encoding",
      "fileformat",
      "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
}
