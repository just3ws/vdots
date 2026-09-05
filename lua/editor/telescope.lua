local telescope = require "telescope"
local actions = require "telescope.actions"

local vimgrep_arguments
if vim.fn.executable "ack" == 1 then
  vimgrep_arguments = {
    "ack",
    "-H",
    "--nogroup",
    "--column",
    "--smart-case",
    "--nocolor",
    "--nofilter",
  }
elseif vim.fn.executable "rg" == 1 then
  vimgrep_arguments = {
    "rg",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
  }
end

telescope.setup {
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = " ",
    path_display = { "smart" },
    vimgrep_arguments = vimgrep_arguments,
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
    layout_config = {
      horizontal = { preview_width = 0.55 },
      vertical = { mirror = false },
    },
  },
  pickers = {
    find_files = { hidden = true },
    buffers = { sort_lastused = true },
  },
}
