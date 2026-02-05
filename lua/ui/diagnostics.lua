-- ============================================================================
-- Neovim Native Diagnostics (Nord aligned, Neovim 0.11+ API)
-- ============================================================================

local M = {}

function M.setup()
  local nord = require("ui.nord").palette

  -- Core diagnostic configuration (Neovim 0.11+ API)
  vim.diagnostic.config {
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "",
        [vim.diagnostic.severity.WARN] = "",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "",
      },
    },
    virtual_text = {
      prefix = "●",
      spacing = 2,
      format = function(d)
        local labels = {
          [vim.diagnostic.severity.ERROR] = "ERR",
          [vim.diagnostic.severity.WARN] = "WRN",
          [vim.diagnostic.severity.INFO] = "INF",
          [vim.diagnostic.severity.HINT] = "HNT",
        }
        return string.format("%s %s", labels[d.severity] or "", d.message)
      end,
    },
    float = {
      border = "rounded",
      source = "if_many",
      focusable = false,
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  }

  -- Nord-aligned colors
  local function hl(name, opts)
    vim.api.nvim_set_hl(0, name, opts)
  end
  hl("DiagnosticError", { fg = nord.red, italic = false })
  hl("DiagnosticWarn", { fg = nord.yellow, italic = false })
  hl("DiagnosticInfo", { fg = nord.blue, italic = false })
  hl("DiagnosticHint", { fg = nord.cyan, italic = false })

  -- Gutter icons (match theme, subtle background)
  hl("DiagnosticSignError", { fg = nord.red, bg = "NONE" })
  hl("DiagnosticSignWarn", { fg = nord.yellow, bg = "NONE" })
  hl("DiagnosticSignInfo", { fg = nord.blue, bg = "NONE" })
  hl("DiagnosticSignHint", { fg = nord.cyan, bg = "NONE" })

  -- Underline for inline diagnostics
  hl("DiagnosticUnderlineError", { undercurl = true, sp = nord.red })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = nord.yellow })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = nord.blue })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = nord.cyan })

  -- Floating hover on CursorHold
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      vim.diagnostic.open_float(nil, { focusable = false })
    end,
  })
end

return M
