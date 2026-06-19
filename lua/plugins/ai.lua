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
      -- 🦙 Local llama.cpp (Qwen3-8B @ :11500), OpenAI-compatible API.
      -- Auth is ignored by the server but the field must be non-empty.
      adapters = {
        llama = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "http://127.0.0.1:11500",
              api_key = "local",
              chat_url = "/v1/chat/completions",
              models_endpoint = "/v1/models",
            },
            schema = {
              model = { default = "local" },
              num_ctx = { default = 32768 },
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = "llama",
          variables = {
            zdots = {
              description = "Inject zdots platform context for the current file",
              callback = function(context)
                local zdots = require "zdots"
                local hydrated = zdots.hydrate_context(context.bufnr)
                if hydrated == "" then
                  return "No zdots context found for this file."
                end
                return "## zdots Platform Context\n\n" .. hydrated
              end,
            },
          },
        },
        inline = { adapter = "llama" },
        cmd = { adapter = "llama" },
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)
    end,
  },
}
