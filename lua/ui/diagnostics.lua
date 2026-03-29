-- ============================================================================
-- Neovim Native Diagnostics (Nord aligned, Neovim 0.11+ API)
-- ============================================================================

local M = {}

function M.setup()
  local dracula = require("ui.dracula_pro").palette

  -- Core diagnostic configuration (Neovim 0.11+ API)
  vim.diagnostic.config {
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "●",
        [vim.diagnostic.severity.WARN] = "●",
        [vim.diagnostic.severity.INFO] = "●",
        [vim.diagnostic.severity.HINT] = "●",
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

  -- Dracula-aligned colors
  local function hl(name, opts)
    vim.api.nvim_set_hl(0, name, opts)
  end
  hl("DiagnosticError", { fg = dracula.red, italic = false })
  hl("DiagnosticWarn", { fg = dracula.yellow, italic = false })
  hl("DiagnosticInfo", { fg = dracula.purple, italic = false })
  hl("DiagnosticHint", { fg = dracula.cyan, italic = false })

  -- Gutter icons (match theme, subtle background)
  hl("DiagnosticSignError", { fg = dracula.red, bg = "NONE" })
  hl("DiagnosticSignWarn", { fg = dracula.yellow, bg = "NONE" })
  hl("DiagnosticSignInfo", { fg = dracula.purple, bg = "NONE" })
  hl("DiagnosticSignHint", { fg = dracula.cyan, bg = "NONE" })

  -- Underline for inline diagnostics
  hl("DiagnosticUnderlineError", { undercurl = true, sp = dracula.red })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = dracula.yellow })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = dracula.purple })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = dracula.cyan })

  -- Floating hover on CursorHold
  vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
      vim.diagnostic.open_float(nil, { focusable = false })
    end,
  })
end

return M
