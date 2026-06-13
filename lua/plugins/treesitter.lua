return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "yaml", "css", "html", "javascript", "latex", 
        "norg", "scss", "svelte", "tsx", "typst", "vue", "regex"
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    branch = "master",
    -- Post-archival versions work natively with Neovim 0.12
    opts = {
      max_lines = 2,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    -- Works directly with vim.treesitter in 0.12+
  },
  {
    "windwp/nvim-ts-autotag",
    branch = "main",
    opts = {},
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    branch = "main",
    opts = {
      enable_autocmd = false,
    },
  },
}
