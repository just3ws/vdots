return {
  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    cmd = { "Copilot" },
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = true,
        auto_trigger = false,
        hide_during_completion = true,
        keymap = {
          accept = "<M-]>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<M-\\\\>",
        },
      },
      filetypes = {
        ["*"] = true,
        lua = true,
        javascript = true,
        typescript = true,
        python = true,
        ruby = true,
      },
    },
  },
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
