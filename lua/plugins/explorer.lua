return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup {
        default_file_explorer = false, -- Keep NERDTree as primary for now
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
    "preservim/nerdtree",
    cmd = {
      "NERDTree",
      "NERDTreeToggle",
      "NERDTreeFind",
      "NERDTreeFocus",
      "NERDTreeClose",
    },
    init = function()
      local explorer = require "editor.explorer"
      explorer.setup_globals()
      explorer.setup()
    end,
  },
  {
    "ryanoasis/vim-devicons",
    lazy = true,
  },
  {
    "Xuyuanp/nerdtree-git-plugin",
    dependencies = { "preservim/nerdtree" },
    lazy = true,
  },
}
