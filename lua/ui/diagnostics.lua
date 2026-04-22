-- ============================================================================
-- Neovim Native Diagnostics (Nord aligned, Neovim 0.11+ API)
-- ============================================================================

local M = {}

function M.setup()
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

end

return M
