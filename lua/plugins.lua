-- ~/.config/nvim/lua/plugins.lua
return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- UI & statusline
  use({ "shaunsingh/nord.nvim" })
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "nord" } })
    end,
  })

  -- Core editing
  use("tpope/vim-surround")
  use("tpope/vim-repeat")
  use("tpope/vim-commentary")
  use("wellle/targets.vim")
  use("kana/vim-textobj-user")
  use("nelstrom/vim-textobj-rubyblock")
  use("tek/vim-textobj-ruby")
  use("tpope/vim-eunuch")

  -- Ruby ecosystem
  use("vim-ruby/vim-ruby")
  use("tpope/vim-endwise")
  use("tpope/vim-bundler")
  use("tpope/vim-rails")

  -- Git
  use({ "tpope/vim-fugitive", cmd = { "Git", "Gdiffsplit", "Gblame" } })
  use("tpope/vim-rhubarb")

  -- File tree
  use({
    "nvim-tree/nvim-tree.lua",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvimtree")
    end,
  })

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = function()
      require("treesitter")
    end,
  })
  use("nvim-treesitter/nvim-treesitter-textobjects")
  use("windwp/nvim-ts-autotag")
  use("JoosepAlviste/nvim-ts-context-commentstring")

  -- LSP / Completion
  use({
    "neovim/nvim-lspconfig",
    requires = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("lsp")
    end,
  })
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  use("hrsh7th/cmp-cmdline")

  use({
    "L3MON4D3/LuaSnip",
    tag = "v2.*",
    run = "make install_jsregexp",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  })
  use("saadparwaiz1/cmp_luasnip")
  use("rafamadriz/friendly-snippets")

  -- Linting / formatting
  use("mfussenegger/nvim-lint")
  use("stevearc/conform.nvim")

  -- Misc
  use("tpope/vim-abolish")
  use("pbrisbin/vim-mkdir")
  use("vitalk/vim-shebang")

  use({
    "goolord/alpha-nvim",
    -- dependencies = { 'echasnovski/mini.icons' },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local startify = require("alpha.themes.startify")
      -- available: devicons, mini, default is mini
      -- if provider not loaded and enabled is true, it will try to use another provider
      startify.file_icons.provider = "devicons"
      require("alpha").setup(startify.config)
    end,
  })
end)
