return {
  -----------------------------------------------------
  -- Core UI
  -----------------------------------------------------
  {
    "ryanoasis/vim-devicons",
    lazy = false, -- force early load
    priority = 1000, -- load before UI plugins
  },


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
    lazy = false,
    priority = 1000,
  },
  {
    "nelstrom/vim-textobj-rubyblock",
    dependencies = { "kana/vim-textobj-user" },
    lazy = false,
  },
  {
    "tek/vim-textobj-ruby",
    dependencies = { "kana/vim-textobj-user" },
    lazy = false,
  },
  -- {
  --   "folke/which-key.nvim",
  --   event = "VeryLazy",
  --   opts = {
  --     -- your configuration comes here
  --     -- or leave it empty to use the default settings
  --     -- refer to the configuration section below
  --   },
  --   keys = {
  --     {
  --       "<leader>?",
  --       function()
  --         require("which-key").show { global = false }
  --       end,
  --       desc = "Buffer Local Keymaps (which-key)",
  --     },
  --   },
  -- },

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
  -- File tree (NERDTree)
  -----------------------------------------------------

  {
    "preservim/nerdtree",
    dependencies = { "ryanoasis/vim-devicons" }, -- "Xuyuanp/nerdtree-git-plugin" },
    config = function()
      require "editor.nerdtree"
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

  -----------------------------------------------------
  -- Linting / formatting
  -----------------------------------------------------
  -- "mfussenegger/nvim-lint",
  -- "stevearc/conform.nvim",
  'vim-scripts/align',

  -----------------------------------------------------
  -- AI Assistance
  -----------------------------------------------------
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Disable default tab mapping since we use it for completion
      vim.g.copilot_no_tab_map = true

      -- Use Alt+] to accept suggestion
      vim.g.copilot_assume_mapped = true
      vim.keymap.set("i", "<M-]>", 'copilot#Accept("<CR>")', {
        expr = true,
        replace_keycodes = false,
      })

      -- Additional settings
      vim.g.copilot_filetypes = {
        ["*"] = true, -- Enable for all filetypes
        ["lua"] = true, -- Explicitly enable for Lua
        ["javascript"] = true,
        ["typescript"] = true,
        ["python"] = true,
        ["ruby"] = true,
      }
    end,
  },

  -----------------------------------------------------
  -- Misc
  -----------------------------------------------------
  "tpope/vim-abolish",
  "pbrisbin/vim-mkdir",
  "vitalk/vim-shebang",
  "vim-scripts/align",
}
