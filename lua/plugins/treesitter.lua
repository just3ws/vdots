return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("editor.treesitter").setup()
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local sel = require "nvim-treesitter-textobjects.select"
      local mov = require "nvim-treesitter-textobjects.move"

      -- Select text objects (visual + operator-pending)
      local selmap = function(lhs, query, desc)
        vim.keymap.set({ "x", "o" }, lhs, function()
          sel.select_textobject(query, "textobjects")
        end, { silent = true, desc = desc })
      end

      selmap("af", "@function.outer", "outer function")
      selmap("if", "@function.inner", "inner function")
      selmap("ac", "@class.outer", "outer class")
      selmap("ic", "@class.inner", "inner class")

      -- Jump to next/prev function
      local movmap = function(lhs, fn, query, desc)
        vim.keymap.set("n", lhs, function()
          fn(query, "textobjects")
        end, { silent = true, desc = desc })
      end

      movmap("]m", mov.goto_next_start, "@function.outer", "Next function start")
      movmap("]M", mov.goto_next_end, "@function.outer", "Next function end")
      movmap("[m", mov.goto_previous_start, "@function.outer", "Prev function start")
      movmap("[M", mov.goto_previous_end, "@function.outer", "Prev function end")
    end,
  },
}
