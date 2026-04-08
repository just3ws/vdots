return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("editor.treesitter").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      max_lines = 2,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
  },
  {
    "windwp/nvim-ts-autotag",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable_autocmd = false,
    },
  },
}
