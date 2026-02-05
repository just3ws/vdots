local opt = vim.opt
local g = vim.g

-- General editor behavior
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.numberwidth = 3
opt.wrap = false
opt.termguicolors = true
opt.laststatus = 2
opt.showmode = false
opt.autowrite = true
opt.joinspaces = false

-- Indentation
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.shiftround = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.inccommand = "nosplit"

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Scrolling
opt.scrolloff = 4
opt.sidescrolloff = 8

-- UI stability
opt.signcolumn = "yes"
opt.updatetime = 250

-- Clipboard
opt.clipboard:append { "unnamed", "unnamedplus" }

-- Editing
opt.backspace = { "indent", "eol", "start" }
opt.diffopt:append "vertical"
opt.wildmode = { "list:longest", "list:full" }

-- Backup, swap, undo directories (enable persistence)
local data = vim.fn.stdpath "data"
opt.backup = true
opt.backupext = ".bak"
opt.backupskip = { "*.log", "/tmp/*" }
opt.backupdir = data .. "/backup//"
opt.directory = data .. "/swap//"
opt.undodir = data .. "/undo//"
opt.undofile = true
opt.viewdir = data .. "/view//"

-- Shell behavior
g.is_posix = 1
g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }

-- External providers
g.ruby_host_prog = vim.fn.expand "~/.asdf/shims/neovim-ruby-host"
g.python3_host_prog = vim.fn.expand "~/.asdf/shims/python3"
g.python_host_prog = vim.fn.expand "~/.asdf/shims/python2"
g.python2_host_prog = vim.fn.expand "~/.asdf/shims/python2"
g.loaded_perl_provider = 0
