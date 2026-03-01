return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    priority = 1000,
  },
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      -- Set globals before the plugin loads so nord.set() sees them.
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_cursorline_transparent = false
      vim.g.nord_enable_sidebar_background = false
      vim.g.nord_italic = false
      vim.g.nord_italic_comments = false
      vim.g.nord_bold = true
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_uniform_status_lines = true
    end,
    config = function()
      require("ui.nord").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup { options = { theme = "nord" } }
    end,
  },
}
