local M = {}

function M.setup_all()
  -- Helper for keymaps
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc })
  end

  -- Flash
  require("flash").setup({})
  map({ "n", "x", "o" }, "s", function() require("flash").jump() end, "Flash jump")
  map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, "Flash treesitter")
  map("o", "r", function() require("flash").remote() end, "Remote flash")
  map({ "o", "x" }, "R", function() require("flash").treesitter_search() end, "Flash treesitter search")

  -- Diffview
  require("diffview").setup({})
  map("n", "<leader>gd", "<cmd>DiffviewOpen<cr>", "Diffview Open")
  map("n", "<leader>gD", "<cmd>DiffviewClose<cr>", "Diffview Close")
  map("n", "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", "File History")

  -- Gitsigns
  require("gitsigns").setup({
    current_line_blame = true,
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local function bmap(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      bmap("n", "]h", function()
        if vim.wo.diff then return "]h" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Next hunk" })
      bmap("n", "[h", function()
        if vim.wo.diff then return "[h" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, { expr = true, desc = "Prev hunk" })
      bmap("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
      bmap("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
      bmap("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
    end,
  })

  -- Trouble
  require("trouble").setup({})
  map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics (Trouble)")
  map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Buffer Diagnostics (Trouble)")
  map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", "Symbols (Trouble)")
  map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", "LSP Definitions / references / ... (Trouble)")
  map("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", "Location List (Trouble)")
  map("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", "Quickfix List (Trouble)")

  -- Todo-comments
  require("todo-comments").setup({})
  map("n", "]t", function() require("todo-comments").jump_next() end, "Next todo comment")
  map("n", "[t", function() require("todo-comments").jump_prev() end, "Previous todo comment")
  map("n", "<leader>st", "<cmd>TodoTelescope<cr>", "Todo (Telescope)")

  -- Indent-blankline
  require("ibl").setup({
    indent = { char = "│" },
    scope = { enabled = true, show_start = true, show_end = true },
  })

  -- Aerial
  require("aerial").setup({})
  map("n", "<leader>a", "<cmd>AerialToggle<cr>", "Aerial (Symbols)")

  -- Render-markdown
  require("render-markdown").setup({
    file_types = { "markdown", "codecompanion" },
  })

  -- Telescope
  require "editor.telescope"

  -- Oil
  require("oil").setup({
    default_file_explorer = false,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
    view_options = {
      show_hidden = true,
    },
  })
  map("n", "-", "<cmd>Oil<CR>", "Open parent directory with Oil")

  -- Nvim-tree
  require("nvim-tree").setup({
    view = { width = 36, side = "left" },
    renderer = {
      group_empty = true,
      highlight_git = true,
      icons = {
        show = { file = true, folder = true, folder_arrow = true, git = true },
      },
    },
    filters = { dotfiles = false, custom = { "^\\.DS_Store$" } },
  })
  require("editor.explorer").setup()

  -- Lazydev
  require("lazydev").setup({
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  })

  -- Blink.cmp
  require("blink.cmp").setup({
    keymap = { preset = "default" },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
  })

  -- Fidget
  require("fidget").setup({
    notification = {
      window = {
        avoid = { "NvimTree" }
      }
    }
  })

  -- Treesitter context
  require("treesitter-context").setup({
    max_lines = 2,
  })

  -- Autotag
  require("nvim-ts-autotag").setup({})

  -- Context commentstring
  require("ts_context_commentstring").setup({
    enable_autocmd = false,
  })

  -- Conform
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      ruby = { "standardrb", "rubocop", stop_after_first = true },
      go = { "goimports", "gofmt" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })
  map("", "<leader>f", function()
    require("conform").format { async = true, lsp_fallback = true }
  end, "Format buffer")

  -- Nvim-lint
  local lint = require "lint"
  lint.linters_by_ft = {
    lua = { "selene" },
    ruby = { "rubocop" },
    go = { "golangcilint" },
    javascript = { "eslint_d", "eslint" },
    typescript = { "eslint_d", "eslint" },
  }
  local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    group = lint_augroup,
    callback = function()
      lint.try_lint()
    end,
  })

  -- CodeCompanion
  require("codecompanion").setup({
    strategies = {
      chat = {
        variables = {
          zdots = {
            description = "Inject zdots platform context for the current file",
            callback = function(context)
              local zdots = require("zdots")
              local hydrated = zdots.hydrate_context(vim.api.nvim_buf_get_name(context.bufnr))
              if hydrated == "" then
                return "No zdots context found for this file."
              end
              return "## zdots Platform Context\n\n" .. hydrated
            end,
          },
        },
      },
    },
  })
  map("n", "<leader>aia", "<cmd>CodeCompanionActions<CR>", "AI actions")
  map("n", "<leader>aic", "<cmd>CodeCompanionChat<CR>", "AI chat")

  -- Otter
  require("otter").setup({
    lsp = { hover = { border = "rounded" } },
    buffers = { set_filetype = true },
  })
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.html.erb", "*.erb" },
    callback = function()
      require("otter").activate({ "ruby" }, true, true, nil)
    end,
  })

  -- Neotest
  require("neotest").setup({
    adapters = {
      require("neotest-rspec")({
        rspec_cmd = function()
          return { "bundle", "exec", "rspec" }
        end,
      }),
      require("neotest-go")({
        experimental = { test_table = true },
        args = { "-v", "-race" },
      }),
    },
    output_panel = {
      enabled = true,
      open = "botright split | vertical resize 60",
    },
    status = { virtual_text = true },
  })
  map("n", "<leader>tr", function() require("neotest").run.run() end, "Run nearest test")
  map("n", "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, "Run file tests")
  map("n", "<leader>tl", function() require("neotest").run.run_last() end, "Run last test")
  map("n", "<leader>ts", function() require("neotest").summary.toggle() end, "Toggle test summary")
  map("n", "<leader>to", function() require("neotest").output.open({ enter = true }) end, "Show test output")
  map("n", "<leader>tO", function() require("neotest").output_panel.toggle() end, "Toggle test output panel")
  map("n", "<leader>tS", function() require("neotest").run.stop() end, "Stop testing")

  -- DAP
  local dap = require "dap"
  local dapui = require "dapui"
  dapui.setup()
  require("dap-go").setup()
  require("dap-ruby").setup()
  dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
  dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
  dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
  map("n", "<leader>db", function() require("dap").toggle_breakpoint() end, "Toggle breakpoint")
  map("n", "<leader>dc", function() require("dap").continue() end, "Continue")
  map("n", "<leader>di", function() require("dap").step_into() end, "Step into")
  map("n", "<leader>do", function() require("dap").step_over() end, "Step over")
  map("n", "<leader>du", function() require("dap-ui").toggle() end, "Toggle Debug UI")
  map("n", "<leader>dr", function() require("dap").repl.open() end, "Open REPL")
  map("n", "<leader>dt", function() require("dap").terminate() end, "Terminate")

  -- Which-key
  require("which-key").setup({
    delay = 300,
    win = { border = "rounded" },
    spec = {
      { "<leader>ai", group = "AI" },
      { "<leader>c", group = "code" },
      { "<leader>f", group = "find/format" },
      { "<leader>e", group = "explorer" },
      { "<leader>h", group = "git hunks" },
      { "<leader>g", group = "git" },
      { "<leader>n", group = "notifications" },
      { "<leader>b", group = "buffer" },
      { "<leader>x", group = "diagnostics (Trouble)" },
      { "<leader>s", group = "search" },
      { "<leader>t", group = "test" },
      { "<leader>d", group = "debug" },
    },
  })
end

return M
