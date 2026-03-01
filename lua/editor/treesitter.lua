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

  local nord = require("ui.nord").palette
  local set_hl = vim.api.nvim_set_hl

  -- --- Nord Highlight Overrides ---
  local highlights = {
    ["@comment"] = { fg = nord.gray_light, italic = false },
    ["@function"] = { fg = nord.blue, bold = true },
    ["@keyword"] = { fg = nord.magenta, bold = true },
    ["@string"] = { fg = nord.green },
    ["@type"] = { fg = nord.yellow },
    ["@variable"] = { fg = nord.fg },
    ["@constant"] = { fg = nord.cyan },
    ["@tag"] = { fg = nord.blue },
    ["@tag.attribute"] = { fg = nord.green },
    ["@tag.delimiter"] = { fg = nord.gray_light },
    ["@error"] = { fg = nord.red, bold = true },
    ["@warning"] = { fg = nord.yellow },
    ["@todo"] = { fg = nord.orange, bold = true },
  }

  for group, opts in pairs(highlights) do
    set_hl(0, group, opts)
  end
end

return M
