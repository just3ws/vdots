local M = {}

---Initialize native treesitter and apply Dracula PRO highlight overrides.
function M.setup()
  -- Neovim 0.12+ has built-in treesitter support.
  -- Highlighting is enabled by default for many languages.
  -- For others, we can enable it via autocmd or globally.

  -- Enable native treesitter highlighting globally (standard in 0.12+)
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local bufnr = args.buf
      local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
      if lang then
        pcall(vim.treesitter.start, bufnr, lang)
      end
    end,
  })

  local ts_textobjects_ok, ts_textobjects = pcall(require, "nvim-treesitter-textobjects")
  if ts_textobjects_ok then
    -- Note: Textobjects plugin now works directly with vim.treesitter in 0.12+
    ts_textobjects.setup {
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
    }
  end

  local kanagawa = require("ui.kanagawa_wave").palette
  local set_hl = vim.api.nvim_set_hl

  -- --- Kanagawa Wave Highlight Overrides ---
  -- These still apply to Treesitter capture groups in 0.12
  local highlights = {
    ["@comment"] = { fg = kanagawa.gray, italic = true },
    ["@function"] = { fg = kanagawa.green, bold = true },
    ["@keyword"] = { fg = kanagawa.pink, bold = true },
    ["@string"] = { fg = kanagawa.yellow },
    ["@type"] = { fg = kanagawa.cyan },
    ["@variable"] = { fg = kanagawa.fg },
    ["@constant"] = { fg = kanagawa.purple },
    ["@tag"] = { fg = kanagawa.pink },
    ["@tag.attribute"] = { fg = kanagawa.orange },
    ["@tag.delimiter"] = { fg = kanagawa.fg },
    ["@error"] = { fg = kanagawa.red, bold = true },
    ["@warning"] = { fg = kanagawa.yellow },
    ["@todo"] = { fg = kanagawa.orange, bold = true },
  }

  for group, opts in pairs(highlights) do
    set_hl(0, group, opts)
  end
end

return M
