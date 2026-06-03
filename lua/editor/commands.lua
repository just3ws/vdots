local cmd = vim.api.nvim_create_user_command

-- Config editing shortcuts
cmd("Reload", "source $MYVIMRC", {})
cmd("Vimrc", "edit $MYVIMRC", {})
cmd("Svimrc", "split $MYVIMRC", {})
cmd("Tvimrc", "tabedit $MYVIMRC", {})
cmd("Vvimrc", "vsplit $MYVIMRC", {})

-- Shell env editing shortcuts
cmd("Zshenv", "edit $ZDOTDIR/.zshenv", {})
cmd("Szshenv", "split $ZDOTDIR/.zshenv", {})
cmd("Tzshenv", "tabedit $ZDOTDIR/.zshenv", {})
cmd("Vzshenv", "vsplit $ZDOTDIR/.zshenv", {})

-- zdots platform commands
cmd("ZdotsIngest", function()
  require("zdots").ingest_buffer(0)
end, { desc = "Ingest current buffer into zdots context engine" })
