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
      local explorer = require "editor.explorer"
      require("nvim-tree").setup {
        on_attach = explorer.on_attach, -- NERDTree-compat layered on defaults
        -- NERDTree-style "follow": reveal/highlight the active file in the tree
        -- as you switch buffers. update_root stays off so the tree root is
        -- stable (only the highlight/reveal follows the cursor).
        update_focused_file = {
          enable = true,
          update_root = false,
        },
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
      explorer.setup()
    end,
  },
}
