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
        { "<leader>e", group = "explorer" },
        { "<leader>h", group = "git hunks" },
        { "<leader>g", group = "git" },
        { "<leader>n", group = "notifications" },
        { "<leader>b", group = "buffer" },
        { "<leader>x", group = "diagnostics (Trouble)" },
        { "<leader>s", group = "search" },
        { "<leader>t", group = "test" },
        { "<leader>d", group = "debug" },
      },
    },
  },
}
