-- ============================================================================
-- Neovim Native Diagnostics (ALE Replacement)
-- Color & Symbol setup matching Nord theme
-- ============================================================================

-- Define diagnostic signs (icons) similar to ALE’s style
local signs = {
  Error = "●", -- ERR
  Warn = ".", -- WRN
  Info = "i",
  Hint = "h",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Diagnostic configuration
vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
    spacing = 2,
    format = function(diagnostic)
      local labels = {
        [vim.diagnostic.severity.ERROR] = "ERR",
        [vim.diagnostic.severity.WARN] = "WRN",
        [vim.diagnostic.severity.INFO] = "INF",
        [vim.diagnostic.severity.HINT] = "HNT",
      }
      local label = labels[diagnostic.severity] or ""
      return string.format("%s %s", label, diagnostic.message)
    end,
  },
  float = {
    border = "rounded",
    source = "if_many",
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

-- Nord-like diagnostic highlight groups
-- These override default LSP diagnostic colors for better readability
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#BF616A", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#EBCB8B", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#88C0D0", bold = true })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#A3BE8C", bold = true })

-- Match gutter signs to Nord’s tone
vim.api.nvim_set_hl(0, "DiagnosticSignError", { fg = "#BF616A", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { fg = "#EBCB8B", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { fg = "#88C0D0", bg = "NONE" })
vim.api.nvim_set_hl(0, "DiagnosticSignHint", { fg = "#A3BE8C", bg = "NONE" })

-- Optional: show diagnostics in a floating window on hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})

vim.api.nvim_set_hl(0, "DiagnosticError", { fg = "#BF616A", italic = false })
vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#EBCB8B", italic = false })
vim.api.nvim_set_hl(0, "DiagnosticInfo", { fg = "#81A1C1", italic = false })
vim.api.nvim_set_hl(0, "DiagnosticHint", { fg = "#88C0D0", italic = false })
vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = "#BF616A" })
