local telescope = require "telescope"
local actions = require "telescope.actions"

telescope.setup {
  defaults = {
    prompt_prefix = "🔍 ",
    selection_caret = " ",
    path_display = { "smart" },
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
