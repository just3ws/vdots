-- ============================================================================
-- 🧠 Native Neovim v0.12 Configuration (Final Safe Version)
-- ============================================================================

local opt = vim.opt
local g = vim.g

g.mapleader = ";"
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.numberwidth = 3
opt.wrap = false
opt.termguicolors = true
opt.laststatus = 2
opt.showmode = false
opt.autowrite = true
opt.joinspaces = false

opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.inccommand = "nosplit"

opt.signcolumn = "yes"
opt.updatetime = 250
opt.scrolloff = 4
opt.sidescrolloff = 8

opt.clipboard:append { "unnamed", "unnamedplus" }

local data = vim.fn.stdpath "data"
opt.undofile = true
opt.undodir = data .. "/undo//"

-- Setup PATH
local path = vim.env.PATH or ""
local mise_shims = vim.fn.expand("~/.local/share/mise/shims")
if vim.fn.isdirectory(mise_shims) == 1 and not path:find(mise_shims, 1, true) then
  vim.env.PATH = mise_shims .. ":" .. path
end

-- Plugin Management
vim.pack.add({
  { src = "https://github.com/dracula/vim", name = "dracula" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  { src = "https://github.com/echasnovski/mini.nvim" },
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
})

require "editor.options"
require "editor.keymaps"
require "editor.autocmds"
require "editor.commands"
require("features.search").setup()

require("snacks").setup({
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
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.picker.files({cwd = vim.fn.stdpath('config')})" },
          { icon = "󰒲 ", key = "L", desc = "PackSync", action = ":PackSync" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
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
  picker = { enabled = true },
  words = { enabled = true },
  rename = { enabled = true },
  scope = { enabled = true },
  quickfile = { enabled = true },
  statuscolumn = { enabled = true },
  bigfile = { enabled = true },
})

-- UI & Theme
vim.cmd.colorscheme("dracula")
require "ui.lualine"

require("oil").setup()
require("mini.statusline").setup()
require("mini.pick").setup()
require("which-key").setup()

require("nvim-tree").setup({
  view = { width = 36, side = "left" },
  renderer = {
    group_empty = true,
    highlight_git = true,
    icons = {
      show = { file = true, folder = true, folder_arrow = true, git = true },
    },
  },
  filters = {
    dotfiles = false,
    custom = { "^\\.DS_Store$" },
  },
})
require("editor.explorer").setup()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
    end
    
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "gr", vim.lsp.buf.references, "References")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    
    if client.name == "ruby_lsp" then
      map("n", "<leader>ih", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, "RubyLSP: Toggle Inlay Hints")
    end
  end,
})

vim.lsp.config("gopls", {
  settings = { gopls = { usePlaceholders = true, completeUnimported = true, analyses = { unusedparams = true } } }
})
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } }, workspace = { checkThirdParty = false } } }
})
vim.lsp.config("ruby_lsp", { init_options = { formatter = "auto" } })
vim.lsp.config("yamlls", { settings = { yaml = { keyOrdering = false } } })

vim.lsp.enable({ "lua_ls", "gopls", "ruby_lsp", "standardrb", "basedpyright", "yamlls", "terraformls" })

vim.api.nvim_create_autocmd("InsertCharPre", {
  callback = function()
    if vim.fn.pumvisible() == 0 and vim.v.char:match("[%w%.%/]") then
      vim.schedule(function()
        if vim.api.nvim_get_mode().mode == "i" then
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true), "n")
        end
      end)
    end
  end,
})
opt.completeopt = { "menuone", "noselect", "noinsert" }

vim.api.nvim_create_user_command("PackSync", function() vim.pack.update() end, {})
vim.keymap.set("n", "<leader>vr", "<cmd>source $MYVIMRC<cr>", { desc = "Reload Config" })
vim.keymap.set("n", "<leader>ve", "<cmd>edit $MYVIMRC<cr>", { desc = "Edit Config" })
