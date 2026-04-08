-- Ruby buffer-local abbreviations
local function abbrev(lhs, rhs)
  vim.cmd(string.format("iabbrev <buffer> %s %s", lhs, rhs))
end

abbrev("re", "return")
abbrev("pu", "public")
abbrev("pr", "private")
abbrev("it", "it {  }")
abbrev("desc", "describe \"\" do<CR>end")
abbrev("cont", "context \"\" do<CR>end")

-- Rails navigation (enhanced vim-rails)
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, desc = desc })
end

map("n", "<leader>rr", ":A<CR>", "Jump to Spec/Source")
map("n", "<leader>rv", ":AV<CR>", "Vertical Split Spec/Source")
map("n", "<leader>rc", ":Rcontroller ", "Go to Controller")
map("n", "<leader>rm", ":Rmodel ", "Go to Model")
map("n", "<leader>bi", ":!bundle install<CR>", "Bundle Install")

-- Ruby specific settings
vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
