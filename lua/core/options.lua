-- General editor options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 8
vim.opt.mouse = "a"
vim.opt.clipboard:append("unnamedplus")
vim.opt.backupskip = { "*.log", "/tmp/*" }

-- Backup and swap paths
local data = vim.fn.stdpath("data")
vim.opt.backupdir = data .. "/backup//"
vim.opt.directory = data .. "/swap//"
vim.opt.undodir = data .. "/undo//"
vim.opt.viewdir = data .. "/view//"
