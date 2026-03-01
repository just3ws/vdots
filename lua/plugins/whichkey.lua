return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- 300 ms before popup appears; keeps the ; → : fallback feeling snappy.
      delay = 300,
      win = { border = "rounded" },
      spec = {
        { "<leader>-", group = "explorer" },
        { "<leader>a", group = "AI" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>r", group = "refactor" },
      },
    },
  },
}
