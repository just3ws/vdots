return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- 300 ms before popup appears; keeps the ; → : fallback feeling snappy.
      delay = 300,
      win = { border = "rounded" },
      spec = {
        { "<leader>ai", group = "AI" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find/format" },
        { "<leader>n", group = "NERDTree" },
        { "<leader>e", group = "explorer" },
      },
    },
  },
}
