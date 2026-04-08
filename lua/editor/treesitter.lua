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

  local ts_textobjects_ok, ts_textobjects = pcall(require, "nvim-treesitter-textobjects")
  if ts_textobjects_ok then
    ts_textobjects.setup({
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
    })
  end

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
