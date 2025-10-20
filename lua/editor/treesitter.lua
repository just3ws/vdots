-- Treesitter configuration with Nord colors

local nord = require "theme.nord"

-- --- Treesitter setup ---
require("nvim-treesitter.configs").setup {
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
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  autotag = {
    enable = true,
  },
}

-- --- Context Commentstring ---
vim.g.skip_ts_context_commentstring_module = true
pcall(function()
  require("ts_context_commentstring").setup {
    enable_autocmd = false,
  }
end)

-- --- Nord Highlights for Treesitter ---
-- Override key syntax groups for better contrast with Nord palette
local set_hl = vim.api.nvim_set_hl

-- Base
set_hl(0, "@comment", { fg = nord.gray_light, italic = true })
set_hl(0, "@punctuation", { fg = nord.gray_light })
set_hl(0, "@constant", { fg = nord.cyan })
set_hl(0, "@string", { fg = nord.green })
set_hl(0, "@string.regex", { fg = nord.orange })
set_hl(0, "@number", { fg = nord.orange })
set_hl(0, "@boolean", { fg = nord.orange, bold = true })
set_hl(0, "@variable", { fg = nord.fg })
set_hl(0, "@variable.builtin", { fg = nord.yellow })
set_hl(0, "@function", { fg = nord.blue, bold = true })
set_hl(0, "@function.builtin", { fg = nord.cyan })
set_hl(0, "@parameter", { fg = nord.fg_light })
set_hl(0, "@field", { fg = nord.fg })
set_hl(0, "@property", { fg = nord.cyan })
set_hl(0, "@keyword", { fg = nord.magenta, bold = true })
set_hl(0, "@keyword.function", { fg = nord.magenta, italic = false })
set_hl(0, "@type", { fg = nord.yellow })
set_hl(0, "@type.builtin", { fg = nord.orange })
set_hl(0, "@namespace", { fg = nord.cyan })
set_hl(0, "@symbol", { fg = nord.cyan })
set_hl(0, "@tag", { fg = nord.blue })
set_hl(0, "@tag.attribute", { fg = nord.green })
set_hl(0, "@tag.delimiter", { fg = nord.gray_light })
set_hl(0, "@operator", { fg = nord.magenta })
set_hl(0, "@conditional", { fg = nord.magenta })
set_hl(0, "@repeat", { fg = nord.magenta })
set_hl(0, "@label", { fg = nord.cyan })
set_hl(0, "@exception", { fg = nord.red })
set_hl(0, "@error", { fg = nord.red, bold = true })
set_hl(0, "@warning", { fg = nord.yellow })
set_hl(0, "@note", { fg = nord.cyan })
set_hl(0, "@todo", { fg = nord.orange, bold = true })

-- Ruby-specific
set_hl(0, "@variable.member.ruby", { fg = nord.cyan })
set_hl(0, "@symbol.ruby", { fg = nord.yellow })
set_hl(0, "@string.special.ruby", { fg = nord.orange })
set_hl(0, "@keyword.ruby", { fg = nord.magenta, bold = true })

-- Markdown tweaks
set_hl(0, "@text.title.markdown", { fg = nord.blue, bold = true })
set_hl(0, "@text.literal.markdown_inline", { fg = nord.green })
set_hl(0, "@text.uri.markdown_inline", { fg = nord.cyan, underline = true })
