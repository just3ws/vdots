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

local function rails_env()
  local is_rails = vim.fn.filereadable "config/environment.rb" ~= 0
  if not is_rails then
    return ""
  end
  local env = os.getenv "RAILS_ENV" or "development"
  return "󰴭 " .. env
end

require("lualine").setup {
  options = {
    theme = dracula_pro_theme,
    section_separators = "",
    component_separators = "",
    globalstatus = true,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { rails_env, "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
}
