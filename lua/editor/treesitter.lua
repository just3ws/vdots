local M = {}

---Initialize nvim-treesitter and apply Nord highlight overrides.
function M.setup()
  local ok = pcall(require, "nvim-treesitter")
  if not ok then
    vim.notify("nvim-treesitter not found", vim.log.levels.WARN)
    return
  end

  -- Post-rewrite API: setup() only accepts install_dir; parsers managed via :TSInstall
  require("nvim-treesitter").setup()

  local dracula = require("ui.dracula_pro").palette
  local set_hl = vim.api.nvim_set_hl

  -- --- Dracula PRO Highlight Overrides ---
  local highlights = {
    ["@comment"] = { fg = dracula.gray, italic = true },
    ["@function"] = { fg = dracula.green, bold = true },
    ["@keyword"] = { fg = dracula.pink, bold = true },
    ["@string"] = { fg = dracula.yellow },
    ["@type"] = { fg = dracula.cyan },
    ["@variable"] = { fg = dracula.fg },
    ["@constant"] = { fg = dracula.purple },
    ["@tag"] = { fg = dracula.pink },
    ["@tag.attribute"] = { fg = dracula.orange },
    ["@tag.delimiter"] = { fg = dracula.fg },
    ["@error"] = { fg = dracula.red, bold = true },
    ["@warning"] = { fg = dracula.yellow },
    ["@todo"] = { fg = dracula.orange, bold = true },
  }

  for group, opts in pairs(highlights) do
    set_hl(0, group, opts)
  end
end

return M
