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
    },
    opts = {
      strategies = {
        chat = {
          variables = {
            zdots = {
              description = "Inject zdots platform context for the current file",
              callback = function(context)
                local zdots = require("zdots")
                local hydrated = zdots.hydrate_context(context.bufnr)
                if hydrated == "" then
                  return "No zdots context found for this file."
                end
                return "## zdots Platform Context\n\n" .. hydrated
              end,
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
  },
}
