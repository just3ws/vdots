return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<CR>", mode = "n", desc = "AI actions" },
      { "<leader>ac", "<cmd>CodeCompanionChat<CR>", mode = "n", desc = "AI chat" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
  },
}
