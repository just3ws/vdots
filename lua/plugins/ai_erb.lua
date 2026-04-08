return {
  "jmbuhr/otter.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
  },
  opts = {
    lsp = {
      hover = {
        border = "rounded",
      },
    },
    buffers = {
      set_filetype = true,
    },
  },
  config = function(_, opts)
    local otter = require("otter")
    otter.setup(opts)

    -- Automatically activate otter in ERB files
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
      pattern = { "*.html.erb", "*.erb" },
      callback = function()
        otter.activate({ "ruby" }, true, true, nil)
      end,
    })
  end,
}
