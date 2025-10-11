require('nvim-treesitter.configs').setup({
  ensure_installed = {
    "bash", "c", "css", "go", "html", "javascript",
    "json", "lua", "markdown", "python", "ruby", "vim", "vimdoc"
  },
  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = { enable = true },
})

