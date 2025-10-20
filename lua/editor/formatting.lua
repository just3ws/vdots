require("conform").setup({
  formatters_by_ft = {
    ruby = { "rubocop" },
    javascript = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    css = { "prettier" },
    lua = { "stylua" },
  },

  -- 🔧 Dynamic format_on_save: skip special files
  format_on_save = function(bufnr)
    local filename = vim.api.nvim_buf_get_name(bufnr)

    -- skip special files
    if filename:match("%.luacheckrc$") or filename:match("%.stylua%.toml$") then
      return false
    end

    return {
      timeout_ms = 2000,
      lsp_fallback = true,
    }
  end,
})

-- Manual command (like :ALEFix)
vim.api.nvim_create_user_command("Format", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, {})
