return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("editor.treesitter").setup()
    end,
  },
  "nvim-treesitter/nvim-treesitter-textobjects",
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  "JoosepAlviste/nvim-ts-context-commentstring",
}
