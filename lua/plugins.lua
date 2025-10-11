require('packer').startup(function(use)
  -- Core dependency
  use 'wbthomason/packer.nvim'

  -- UI
  use 'arcticicestudio/nord-vim'
  use { 'vim-airline/vim-airline' }
  use { 'vim-airline/vim-airline-themes' }

  -- Editing, text objects, motion
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-commentary'
  use 'wellle/targets.vim'
  use 'kana/vim-textobj-user'
  use 'nelstrom/vim-textobj-rubyblock'
  use 'tek/vim-textobj-ruby'

  -- Ruby & Rails
  use 'vim-ruby/vim-ruby'
  use 'tpope/vim-bundler'
  use 'tpope/vim-rails'
  use 'tpope/vim-rake'
  use 'tpope/vim-endwise'

  -- Go support
  use { 'fatih/vim-go', run = ':GoInstallBinaries' }

  -- Git & workflow
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-eunuch'

  -- Tools
  use { 'junegunn/fzf.vim', opt = true, cmd = { 'FZF', 'Files', 'GFiles' } }
  use { 'preservim/nerdtree', opt = true, cmd = { 'NERDTreeToggle', 'NERDTreeFind' } }
  use 'editorconfig/editorconfig-vim'
  use 'mhinz/vim-startify'
  use 'dense-analysis/ale'

  -- Misc
  use 'tpope/vim-abolish'
  use 'tpope/vim-projectionist'
  use 'tpope/vim-sensible'
  use 'pbrisbin/vim-mkdir'
  use 'vitalk/vim-shebang'

  --------------------------------------------------------------------------
  -- Modern syntax and highlighting: Tree-sitter
  --------------------------------------------------------------------------
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {
          'ruby', 'go', 'lua', 'javascript', 'json',
          'html', 'css', 'bash', 'python'
        },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      }
    end
  }

  use {
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter'
  }

  use {
    'windwp/nvim-ts-autotag',
    after = 'nvim-treesitter',
    config = function()
      require('nvim-ts-autotag').setup()
    end
  }

  use {
    'JoosepAlviste/nvim-ts-context-commentstring',
    after = 'nvim-treesitter'
  }

  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'

end)
