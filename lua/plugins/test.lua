return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Adapters
    "olimorris/neotest-rspec",
    "nvim-neotest/neotest-go",
  },
  keys = {
    { "<leader>tr", function() require("neotest").run.run() end, desc = "Run nearest test" },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show test output" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle test output panel" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop testing" },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-rspec"),
        require("neotest-go")({
          experimental = {
            test_table = true,
          },
          args = { "-v", "-race" },
        }),
      },
    })
  end,
}
