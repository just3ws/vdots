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
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = true, show_end = true },
    },
  },
  {
    dir = vim.fn.expand "~/github.com/dracula/Dracula Pro/themes/vim",
    name = "dracula-pro",
    lazy = false,
    priority = 1000,
    config = function()
      require("ui.dracula_pro").setup()
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
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
    keys = {
      { "<leader>a", "<cmd>AerialToggle<cr>", desc = "Aerial (Symbols)" },
    },
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          {
            footer = ("  Neovim %d.%d.%d"):format(
              vim.version().major,
              vim.version().minor,
              vim.version().patch
            ),
            padding = 1,
          },
          { section = "startup" },
        },
      },
      notifier = { enabled = true, timeout = 3000 },
      gitbrowse = { enabled = true },
      picker = { enabled = true },
      words = { enabled = true },
      rename = { enabled = true },
      scope = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      bigfile = { enabled = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "SnacksDashboardOpened",
        callback = function()
          local zdots = require("zdots")
          local status = zdots.get_status()
          if not status then return end

          local bufnr = vim.api.nvim_get_current_buf()
          local lines = { "", "  zdots Platform", "" }
          for _, line in ipairs(status) do
            table.insert(lines, "  " .. line)
          end
          vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, lines)
        end,
      })
    end,
    keys = {
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      { "<leader>zi", "<cmd>ZdotsIngest<cr>", desc = "zdots: Ingest context" },
      { "<leader>zt", function()
        local zdots = require("zdots")
        local tasks = zdots.ztask("list")
        if #tasks == 0 then
          vim.notify("No active zdots tasks found", vim.log.levels.INFO)
          return
        end
        
        Snacks.picker.select(tasks, {
          prompt = "zdots Tasks",
          format = function(item)
            return string.format("[%s] %s", item.id, item.title)
          end,
          confirm = function(item)
            if item.file_path then
              vim.cmd("edit " .. item.file_path)
            else
              vim.notify("No file path associated with task " .. item.id, vim.log.levels.WARN)
            end
          end,
        })
      end, desc = "zdots Tasks" },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "codecompanion" },
    opts = {
      file_types = { "markdown", "codecompanion" },
    },
  },
}
