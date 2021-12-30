local LEADER = ';'
local COLORSCHEME = 'nord'

vim.cmd [[syntax enable]]

require('plugins')

vim.g.mapleader = LEADER
vim.g.maplocalleader = LEADER

vim.opt.completeopt = 'menuone,noinsert,noselect'
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.hidden = true
vim.opt.inccommand = 'nosplit'
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftround =  true
vim.opt.shiftwidth = 2
vim.opt.shortmess = vim.opt.shortmess + 'c'
vim.opt.showmode = false
vim.opt.signcolumn = 'yes'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.updatetime = 100

-- set clipboard& clipboard+=unnamed,unnamedplus
vim.opt.autowrite = true
-- set autowriteall
-- set backupext=.bak
-- set backupskip=*.log
-- set expandtab
-- set ignorecase
-- set inccommand=
-- set number
-- set numberwidth=3
-- set shiftround
-- set shiftwidth=2
-- set smartcase
-- set softtabstop=2
-- set splitbelow
-- set splitright
-- set tabstop=2
-- set tags^=.git/tags
-- set undofile
--
-- set noshowmode
-- set nowrap

-- vim.api.nvim_set_keymap(<mode>, <keys>, <actions>, <options>)
vim.api.nvim_set_keymap('n', '<C-s>', ':write<CR>', { noremap = true })
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r>+', { noremap = true })

function _G.put(...)
  local objects = {}
  for i = 1, select('#', ...) do
    local v = select(1, ...)
    table.insert(objects, vim.inspect(v))
  end

  print(table.concat(objects, '\n'))
  return ...
end

vim.g.ruby_host_prog = vim.env.HOME .. '/.asdf/shims/neovim-ruby-host'
vim.g.python_host_prog = vim.env.HOME .. '/.asdf/shims/python2'
vim.g.python2_host_prog = vim.env.HOME .. '/.asdf/shims/python2'
vim.g.python3_host_prog = vim.env.HOME .. '/.asdf/shims/python3'

vim.opt.wildignore = {
  '*/cache/*',
  '*/tmp/*'
}

vim.cmd('colorscheme ' .. COLORSCHEME)
