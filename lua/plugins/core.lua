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
    init = function()
      -- Suppress the plugin's after/ftplugin mappings; we own them in
      -- after/ftplugin/ruby.lua so ar/ir stays with vim-textobj-rubyblock.
      vim.g.textobj_ruby_no_mappings = 1
    end,
  },

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
