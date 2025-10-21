return {
  -----------------------------------------------------
  -- Core UI
  -----------------------------------------------------
  {
    "shaunsingh/nord.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nord").set()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup { options = { theme = "nord" } }
    end,
  },

  -----------------------------------------------------
  -- Core editing
  -----------------------------------------------------
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "tpope/vim-commentary",
  "wellle/targets.vim",
  "tpope/vim-eunuch",
  -- Text objects
  {
    "kana/vim-textobj-user",
    lazy = false, -- must load first
  },
  {
    "nelstrom/vim-textobj-rubyblock",
    dependencies = { "kana/vim-textobj-user" },
    ft = "ruby",
  },
  {
    "tek/vim-textobj-ruby",
    dependencies = { "kana/vim-textobj-user" },
    ft = "ruby",
  },

  -----------------------------------------------------
  -- Ruby ecosystem
  -----------------------------------------------------
  "vim-ruby/vim-ruby",
  "tpope/vim-endwise",
  "tpope/vim-bundler",
  "tpope/vim-rails",

  -----------------------------------------------------
  -- Git
  -----------------------------------------------------
  { "tpope/vim-fugitive", cmd = { "Git", "Gdiffsplit", "Gblame" } },
  "tpope/vim-rhubarb",

  -----------------------------------------------------
  -- File tree
  -----------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    build = "make",
    config = function()
      require "editor.telescope"
    end,
  },
  "mileszs/ack.vim",

  -- Treesitter
  -----------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("editor.treesitter").setup()
    end,
  },
  "nvim-treesitter/nvim-treesitter-textobjects",
  "windwp/nvim-ts-autotag",
  "JoosepAlviste/nvim-ts-context-commentstring",

  -----------------------------------------------------
  -- LSP + completion
  -----------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require "lsp"
    end,
  },
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",

  -----------------------------------------------------
  -- Linting / formatting
  -----------------------------------------------------
  "mfussenegger/nvim-lint",
  "stevearc/conform.nvim",

  -----------------------------------------------------
  -- Misc
  -----------------------------------------------------
  "tpope/vim-abolish",
  "pbrisbin/vim-mkdir",
  "vitalk/vim-shebang",
}
