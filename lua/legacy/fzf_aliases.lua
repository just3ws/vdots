local builtin = require "telescope.builtin"

vim.api.nvim_create_user_command("Files", function()
  builtin.find_files()
end, {})

vim.api.nvim_create_user_command("GFiles", function()
  builtin.git_files()
end, {})

vim.api.nvim_create_user_command("Buffers", function()
  builtin.buffers()
end, {})

vim.api.nvim_create_user_command("Rg", function()
  builtin.live_grep()
end, {})

vim.api.nvim_create_user_command("Ack", function(opts)
  require("telescope.builtin").live_grep { default_text = opts.args }
end, { nargs = 1 })

vim.api.nvim_create_user_command("Commits", function()
  builtin.git_commits()
end, {})

vim.api.nvim_create_user_command("BCommits", function()
  builtin.git_bcommits()
end, {})
