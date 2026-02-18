return {
  {
    "preservim/nerdtree",
    cmd = {
      "NERDTree",
      "NERDTreeToggle",
      "NERDTreeFind",
      "NERDTreeFocus",
      "NERDTreeClose",
    },
    init = function()
      local explorer = require "editor.explorer"
      explorer.setup_globals()
      explorer.setup()
    end,
  },
  {
    "ryanoasis/vim-devicons",
    lazy = true,
  },
  {
    "Xuyuanp/nerdtree-git-plugin",
    dependencies = { "preservim/nerdtree" },
    lazy = true,
  },
}
