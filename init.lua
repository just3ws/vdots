-- ============================================================================
-- 🧠 Native Neovim v0.12 Configuration (Final Safe Version)
-- ============================================================================

-- Leader before anything that binds keys. All other options live in
-- editor/options.lua (loaded below) — don't set vim.opt here.
vim.g.mapleader = ";"

-- Plugin Management
vim.pack.add {
  { src = "https://github.com/rebelot/kanagawa.nvim", name = "kanagawa" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/lukas-reineke/indent-blankline.nvim" },
  { src = "https://github.com/j-hui/fidget.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/tpope/vim-surround" },
  { src = "https://github.com/tpope/vim-commentary" },
  { src = "https://github.com/tpope/vim-repeat" },
  { src = "https://github.com/tpope/vim-abolish" },
  { src = "https://github.com/tpope/vim-eunuch" },
  { src = "https://github.com/wellle/targets.vim" },
  { src = "https://github.com/vim-scripts/align" },
  { src = "https://github.com/pbrisbin/vim-mkdir" },
  { src = "https://github.com/folke/flash.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/stevearc/oil.nvim" },
  { src = "https://github.com/nvim-tree/nvim-tree.lua" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/stevearc/aerial.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/jmbuhr/otter.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/tpope/vim-fugitive" },
  { src = "https://github.com/sindrets/diffview.nvim" },
  { src = "https://github.com/tpope/vim-rhubarb" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/JoosepAlviste/nvim-ts-context-commentstring" },
  { src = "https://github.com/vim-ruby/vim-ruby" },
  { src = "https://github.com/tpope/vim-endwise" },
  { src = "https://github.com/tpope/vim-bundler" },
  { src = "https://github.com/tpope/vim-rails" },
  { src = "https://github.com/nvim-neotest/neotest" },
  { src = "https://github.com/nvim-neotest/neotest-go" },
  { src = "https://github.com/olimorris/neotest-rspec" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/antoinemadec/FixCursorHold.nvim" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/leoluz/nvim-dap-go" },
  { src = "https://github.com/suketa/nvim-dap-ruby" },
  { src = "https://github.com/olimorris/codecompanion.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  -- Release tag so blink downloads its prebuilt Rust fuzzy lib (no cargo).
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range "1.*" },
  -- JS/TS test runner + debugger
  { src = "https://github.com/marilari88/neotest-vitest" },
  { src = "https://github.com/mxsdev/nvim-dap-vscode-js" },
}

require "editor.options" -- General settings (all vim.opt)
require "filetypes" -- Custom filetype mappings
require "editor.keymaps" -- Global keybindings
require "editor.autocmds" -- Event hooks
require "editor.commands" -- :Commands
require("editor.llm").setup() -- 🦙 Local-LLM (ai-query) buffer/selection pipe
require("editor.claude").setup() -- 🤖 Claude Code session pulse + last-change diff
require("editor.usage").setup() -- 📊 Friction/rage telemetry → :NvimUsage
require("editor.errors").setup() -- 🪲 All-errors log with diagnostic context → :NvimErrors
require("editor.search").setup() -- Native grep/quickfix (:Rg)
require "editor.healthcheck" -- Log deprecation warnings
require("editor.terminal").setup() -- 🖥️  Snacks terminal: toggle, named slots, ergonomic keymaps

require("snacks").setup {
  dashboard = {
    sections = {
      { section = "header" },
      {
        section = "keys",
        gap = 1,
        padding = 1,
        keys = {
          { icon = " ", key = "z", desc = "zdots Status", action = ":ZdotsStatus" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.picker.smart()" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.picker.grep()" },
          {
            icon = " ",
            key = "r",
            desc = "Recent Files",
            action = ":lua Snacks.picker.recent()",
          },
          {
            icon = " ",
            key = "m",
            desc = "Recent Markdown",
            action = ":VdotsRecentMarkdown",
          },
          {
            icon = " ",
            key = "c",
            desc = "Config",
            action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})",
          },
          { icon = "󰒲 ", key = "L", desc = "PackSync", action = ":PackSync" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      { section = "recent_files", title = "Recent Files", limit = 8, padding = 1 },
      {
        section = "recent_files",
        title = "Recent Markdown",
        limit = 15,
        padding = 1,
        filter = require("editor.mdfiles").is_markdown,
      },
      {
        footer = ("  Neovim %d.%d.%d"):format(
          vim.version().major,
          vim.version().minor,
          vim.version().patch
        ),
        padding = 1,
      },
    },
  },
  notifier = { enabled = true, timeout = 3000 },
  gitbrowse = { enabled = true },
  lazygit = { enabled = true },
  terminal = { enabled = true },
  picker = { enabled = true },
  words = { enabled = true },
  rename = { enabled = true },
  scope = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  bigfile = { enabled = true },
}

-- UI & Theme
-- Guard the base colorscheme: on a fresh machine vim.pack may not have fetched
-- kanagawa.nvim yet, and an unguarded require/colorscheme throws (E185 / module
-- not found), aborting the rest of init. Degrade gracefully with a hint instead.
if
  not pcall(function()
    require("kanagawa").setup {
      theme = "wave",
      background = { dark = "wave" },
      -- Operator hand-tuned the platform background bluer than canonical Sumi
      -- Ink3 (#1F1F28); overriding ui.bg propagates #1A1B2F to every
      -- kanagawa-generated highlight, not just Normal.
      colors = { theme = { wave = { ui = { bg = "#1A1B2F" } } } },
    }
    vim.cmd.colorscheme "kanagawa-wave"
  end)
then
  vim.notify(
    "colorscheme 'kanagawa-wave' not installed yet — run :lua vim.pack.update() then restart",
    vim.log.levels.WARN
  )
end
require("ui.kanagawa_wave").setup() -- highlight overrides on top (self-contained palette)
require "ui.lualine"
require("ui.diagnostics").setup() -- Diagnostic signs / virtual-text styling
require("editor.treesitter").setup() -- Native TS highlighting + textobjects
require("editor.mason").setup() -- editor-only LSP servers (skipped headless/CI)

-- Plugin setup + their keymaps (everything vim.pack installs above)
require("plugins").setup_all()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end

    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gI", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "gr", vim.lsp.buf.references, "References")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")
    -- Diagnostic jumps use the newer vim.diagnostic.jump API (0.11+); the
    -- {count} form supersedes goto_next/goto_prev deprecated in 0.10.
    map("n", "]d", function()
      vim.diagnostic.jump { count = 1, float = true }
    end, "Next diagnostic")
    map("n", "[d", function()
      vim.diagnostic.jump { count = -1, float = true }
    end, "Prev diagnostic")

    -- Inlay hints: toggle for any LSP that supports them (vtsls, gopls, ruby_lsp…)
    if client.supports_method "textDocument/inlayHint" then
      map("n", "<leader>ih", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, "Toggle inlay hints")
    end
  end,
})

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      usePlaceholders = true,
      completeUnimported = true,
      analyses = { unusedparams = true },
    },
  },
})
vim.lsp.config("lua_ls", {
  settings = {
    Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } },
  },
})
vim.lsp.config("ruby_lsp", { init_options = { formatter = "auto" } })
vim.lsp.config("yamlls", { settings = { yaml = { keyOrdering = false } } })
vim.lsp.config("vtsls", {
  settings = {
    typescript = {
      -- Pick up the workspace's own typescript install (matches project tsconfig paths).
      tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
      inlayHints = {
        parameterNames = { enabled = "literals" },
        variableTypes = { enabled = true },
        returnTypes = { enabled = true },
      },
    },
    vtsls = {
      -- Monorepo: auto-detect the workspace tsconfig so @phalanxduel/* paths resolve.
      autoUseWorkspaceTsdk = true,
    },
  },
})
vim.lsp.config("sqls", {
  settings = {
    sqls = {
      connections = {
        -- Matches the typical dev DATABASE_URL in .env.example / docker-compose.yml.
        {
          driver = "postgresql",
          dataSourceName = "host=127.0.0.1 port=5432 dbname=phalanxduel_dev",
        },
      },
    },
  },
})

vim.lsp.enable {
  "lua_ls",
  "gopls",
  "ruby_lsp",
  "standardrb",
  "basedpyright",
  "yamlls",
  "terraformls",
  "vtsls",
  "sqls",
}
