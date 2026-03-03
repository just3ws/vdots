return {
  -- Core Lua utility library (also used by tests and AI integrations)
  { "nvim-lua/plenary.nvim", lazy = false },

  -- Core editing
  "tpope/vim-surround",
  "tpope/vim-repeat",
  "tpope/vim-commentary",
  "wellle/targets.vim",
  "tpope/vim-eunuch",
  "vim-scripts/align",

  -- Ruby ecosystem
  "vim-ruby/vim-ruby",
  "tpope/vim-endwise",
  "tpope/vim-bundler",
  "tpope/vim-rails",

  -- Git
  { "tpope/vim-fugitive", cmd = { "Git", "Gdiffsplit", "Gblame" } },
  "tpope/vim-rhubarb",

  -- Misc
  "tpope/vim-abolish",
  "pbrisbin/vim-mkdir",
}
