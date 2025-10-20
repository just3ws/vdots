-- ---------------------------------------------------------------------------
-- NvimTree configuration with Nord theme integration
-- ---------------------------------------------------------------------------

-- Nord palette (shaunsingh/nord.nvim compatible)
local nord = {
  bg = "#2E3440",
  bg_dark = "#2B303B",
  bg_light = "#3B4252",
  fg = "#D8DEE9",
  fg_light = "#E5E9F0",
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

-- Core setup
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
      show = { file = true, folder = true, folder_arrow = true, git = true },
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
    -- ⚠️ NOTE: these patterns are Vim regex, not Lua patterns.
    -- Avoid ^ and % to prevent E33 “no previous substitute regex”.
    custom = {
      ".git", -- .git directory
      "node_modules", -- node modules
      "log", -- log dir
      "coverage", -- coverage dir
      "tmp", -- tmp dir
      "~$", -- backup files
      "Gemfile.lock", -- lockfile
      "bin", -- bin dir
    },
  },
  git = { enable = true, ignore = false },
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
  update_focused_file = { enable = true, update_root = true },
  actions = {
    open_file = {
      quit_on_open = false,
      resize_window = true,
    },
  },
  hijack_cursor = true,
  respect_buf_cwd = true,
}

-- ---------------------------------------------------------------------------
-- Apply Nord highlights
-- ---------------------------------------------------------------------------
local hl = vim.api.nvim_set_hl
hl(0, "NvimTreeNormal", { fg = nord.fg, bg = nord.bg_dark })
hl(0, "NvimTreeNormalNC", { fg = nord.fg, bg = nord.bg_dark })
hl(0, "NvimTreeEndOfBuffer", { fg = nord.bg_dark, bg = nord.bg_dark })
hl(0, "NvimTreeRootFolder", { fg = nord.cyan, bold = true })
hl(0, "NvimTreeFolderName", { fg = nord.blue })
hl(0, "NvimTreeOpenedFolderName", { fg = nord.cyan, bold = true })
hl(0, "NvimTreeEmptyFolderName", { fg = nord.gray_light })
hl(0, "NvimTreeIndentMarker", { fg = nord.gray })
hl(0, "NvimTreeExecFile", { fg = nord.green, bold = true })
hl(0, "NvimTreeGitDirty", { fg = nord.orange })
hl(0, "NvimTreeGitNew", { fg = nord.green })
hl(0, "NvimTreeGitDeleted", { fg = nord.red })
hl(0, "NvimTreeGitStaged", { fg = nord.yellow })
hl(0, "NvimTreeGitIgnored", { fg = nord.gray })
hl(0, "NvimTreeSpecialFile", { fg = nord.magenta, underline = true })
hl(0, "NvimTreeImageFile", { fg = nord.cyan })
hl(0, "NvimTreeSymlink", { fg = nord.magenta })
hl(0, "NvimTreeCursorLine", { bg = nord.bg_light })
hl(0, "NvimTreeWinSeparator", { fg = nord.bg, bg = nord.bg_dark })
