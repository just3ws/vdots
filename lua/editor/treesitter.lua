local M = {}

function M.setup()
  local ok, ts = pcall(require, "nvim-treesitter.configs")
  if not ok then
    vim.notify("nvim-treesitter not found", vim.log.levels.WARN)
    return
  end

  local nord = require("ui.nord").palette
  local set_hl = vim.api.nvim_set_hl

  ts.setup {
    ensure_installed = {
      "bash",
      "c",
      "css",
      "go",
      "html",
      "javascript",
      "json",
      "lua",
      "markdown",
      "python",
      "ruby",
      "vim",
      "vimdoc",
      "yaml",
    },
    highlight = { enable = true, additional_vim_regex_highlighting = false },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn",
        node_incremental = "grn",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
    autotag = { enable = true },
  }

  vim.g.skip_ts_context_commentstring_module = true
  pcall(function()
    require("ts_context_commentstring").setup { enable_autocmd = false }
  end)

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
