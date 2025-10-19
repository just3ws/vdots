require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 35,
    side = "left",
    preserve_window_proportions = true,
  },
  renderer = {
    group_empty = true,
    highlight_git = true,
    icons = {
      show = { file = true, folder = true, folder_arrow = true, git = true },
    },
  },
  filters = {
    dotfiles = false,
    custom = {
      "^%.git$", -- .git directory (must escape the dot)
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
})
