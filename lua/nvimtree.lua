-- lua/nvimtree.lua

-- Define Nord color palette (same as shaunsingh/nord.nvim)
local nord = {
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

-- Configure NvimTree
require("nvim-tree").setup {
  sort_by = "case_sensitive",
  view = {
    width = 35,
    side = "left",
    preserve_window_proportions = true,
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    highlight_opened_files = "name",
    root_folder_modifier = ":t",
    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = true,
      },
      glyphs = {
        default = "",
        symlink = "",
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
        },
      },
    },
  },
  filters = {
    dotfiles = false,
    custom = {
      "^%.git$", -- .git directory (escaped dot)
      "node_modules", -- node modules
      "^log$", -- log dir
      "^coverage$", -- coverage dir
      "^tmp$", -- tmp dir
      "~$", -- backup files
      "Gemfile.lock", -- lockfile
      "^bin$", -- bin dir
    },
  },
  git = {
    enable = true,
    ignore = false,
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    show_on_open_dirs = true,
    debounce_delay = 50,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  actions = {
    open_file = {
      quit_on_open = true,
    },
  },
}

-- Apply Nord highlights
vim.api.nvim_set_hl(0, "NvimTreeNormal", { fg = nord.fg, bg = nord.bg_dark })
vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { fg = nord.fg, bg = nord.bg_dark })
vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { fg = nord.bg_dark, bg = nord.bg_dark })
vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = nord.cyan, bold = true })
vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = nord.blue })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = nord.cyan, bold = true })
vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName", { fg = nord.gray_light, italic = false })
vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = nord.gray })
vim.api.nvim_set_hl(0, "NvimTreeExecFile", { fg = nord.green, bold = true })
vim.api.nvim_set_hl(0, "NvimTreeGitDirty", { fg = nord.orange })
vim.api.nvim_set_hl(0, "NvimTreeGitNew", { fg = nord.green })
vim.api.nvim_set_hl(0, "NvimTreeGitDeleted", { fg = nord.red })
vim.api.nvim_set_hl(0, "NvimTreeGitStaged", { fg = nord.yellow })
vim.api.nvim_set_hl(0, "NvimTreeGitIgnored", { fg = nord.gray })
vim.api.nvim_set_hl(0, "NvimTreeSpecialFile", { fg = nord.magenta, underline = true })
vim.api.nvim_set_hl(0, "NvimTreeImageFile", { fg = nord.cyan })
vim.api.nvim_set_hl(0, "NvimTreeSymlink", { fg = nord.magenta })
vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = nord.bg_light })
vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = nord.bg, bg = nord.bg_dark })

-- Optional: make background transparent (matches Nord + transparent terminal)
-- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "NONE" })
