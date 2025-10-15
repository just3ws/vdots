require("conform").setup({
  formatters_by_ft = {
    ruby = { "rubocop" },
    javascript = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    css = { "prettier" },
  },

  format_on_save = {
    timeout_ms = 2000,
    lsp_fallback = true,
  },
})

-- Manual command (like :ALEFix)
vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, {})

