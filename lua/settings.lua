local opt = vim.opt
local g = vim.g

-- Backup / Swap / Undo directories
opt.backupskip = "*.log,/tmp/*"
opt.backupext = ".bak"
opt.backupdir = vim.fn.expand("~/.local/share/nvim/backup//")
opt.directory = vim.fn.expand("~/.local/share/nvim/swap//")
opt.undodir = vim.fn.expand("~/.local/share/nvim/undo//")
opt.viewdir = vim.fn.expand("~/.local/share/nvim/view//")

-- General options
opt.splitbelow = true
opt.splitright = true
opt.ignorecase = true
opt.smartcase = true
opt.diffopt:append("vertical")
opt.wildmode = { "list:longest", "list:full" }
opt.termguicolors = true
opt.joinspaces = false
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.shiftround = true
opt.number = true
opt.numberwidth = 3
opt.wrap = false
opt.laststatus = 2
opt.showmode = false
opt.autowrite = true
opt.backspace = { "indent", "eol", "start" }
opt.hlsearch = true
opt.inccommand = ""

g.is_posix = 1
g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }

-- Clipboard
opt.clipboard:append({ "unnamed", "unnamedplus" })

-- External providers
g.ruby_host_prog = vim.fn.expand("~/.asdf/shims/neovim-ruby-host")
g.python3_host_prog = vim.fn.expand("~/.asdf/shims/python3")
g.python_host_prog = vim.fn.expand("~/.asdf/shims/python2")
g.python2_host_prog = vim.fn.expand("~/.asdf/shims/python2")
g.loaded_perl_provider = 0
