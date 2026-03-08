return {
  {
    "echasnovski/mini.icons",
    version = false,
    opts = {},
  },
  {
    "nvim-tree/nvim-web-devicons",
    lazy = false,
    priority = 1000,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = true, -- Inline blame like VS Code
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end
        -- Navigation
        map("n", "]h", function()
          if vim.wo.diff then return "]h" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })
        map("n", "[h", function()
          if vim.wo.diff then return "[h" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "Prev hunk" })
        -- Actions
        map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
      end,
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
      { "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo (Telescope)" },
    },
  },
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      -- Set globals before the plugin loads so nord.set() sees them.
      vim.g.nord_contrast = true
      vim.g.nord_borders = true
      vim.g.nord_disable_background = false
      vim.g.nord_cursorline_transparent = false
      vim.g.nord_enable_sidebar_background = false
      vim.g.nord_italic = false
      vim.g.nord_italic_comments = false
      vim.g.nord_bold = true
      vim.g.nord_uniform_diff_background = true
      vim.g.nord_uniform_status_lines = true
    end,
    config = function()
      require("ui.nord").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require "ui.lualine"
    end,
  },
  {
    "folke/snacks.nvim",
    event = "VimEnter",
    enabled = function()
      return vim.fn.argc() == 0 and #vim.api.nvim_list_uis() > 0
    end,
    opts = {
      dashboard = { enabled = true },
    },
  },
}
