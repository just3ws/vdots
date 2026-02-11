local ok_builtin, builtin = pcall(require, "telescope.builtin")
if not ok_builtin then
  return
end

vim.api.nvim_create_user_command("Files", function()
  builtin.find_files()
end, {})

vim.api.nvim_create_user_command("GFiles", function()
  builtin.git_files()
end, {})

vim.api.nvim_create_user_command("Buffers", function()
  builtin.buffers()
end, {})

vim.api.nvim_create_user_command("Commits", function()
  builtin.git_commits()
end, {})

vim.api.nvim_create_user_command("BCommits", function()
  builtin.git_bcommits()
end, {})
