return {
  {
    "nvim-treesitter/nvim-treesitter",
    commit = "4916d6592ede8c07973490d9322f187e07dfefac",
    build = ":TSUpdate",
    config = function()
      require("editor.treesitter").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    commit = "b0c45cefe2c8f7b55fc46f34e563bc428ef99636",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      max_lines = 2,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    commit = "851e865342e5a4cb1ae23d31caf6e991e1c99f1e",
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
