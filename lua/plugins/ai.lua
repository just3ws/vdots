return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    config = function(_, opts)
      require("codecompanion").setup(opts)
      vim.keymap.set(
        "n",
        "<leader>aa",
        "<cmd>CodeCompanionActions<CR>",
        { silent = true, desc = "AI actions" }
      )
      vim.keymap.set(
        "n",
        "<leader>ac",
        "<cmd>CodeCompanionChat<CR>",
        { silent = true, desc = "AI chat" }
      )
    end,
  },
}
