return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup {
        default_file_explorer = false,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
        },
      }
      vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory with Oil" })
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "echasnovski/mini.icons" },
    config = function()
      require("nvim-tree").setup {
        view = {
          width = 36,
          side = "left",
        },
        renderer = {
          group_empty = true,
          highlight_git = true,
          icons = {
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
          custom = { "^\\.DS_Store$" },
        },
      }
      local explorer = require "editor.explorer"
      explorer.setup()
    end,
  },
}
