return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    keys = {
      { "<leader>aia", "<cmd>CodeCompanionActions<CR>", mode = "n", desc = "AI actions" },
      { "<leader>aic", "<cmd>CodeCompanionChat<CR>", mode = "n", desc = "AI chat" },
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
