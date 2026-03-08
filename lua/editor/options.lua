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
local openjdk_bin = "/opt/homebrew/opt/openjdk/bin"
local openjdk_home = "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
local mise_shims = vim.fn.expand "~/.local/share/mise/shims"
local path = vim.env.PATH or ""
if path == "" then
  path = "/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
end

if vim.fn.isdirectory(mise_shims) == 1 and not path:find(mise_shims, 1, true) then
  path = mise_shims .. ":" .. path
end

if vim.fn.isdirectory(openjdk_bin) == 1 and not path:find(openjdk_bin, 1, true) then
  path = openjdk_bin .. ":" .. path
end
vim.env.PATH = path

if vim.fn.isdirectory(openjdk_home) == 1 then
  vim.env.JAVA_HOME = openjdk_home
end

-- External providers
local function has_python_module(python, module)
  if vim.fn.executable(python) ~= 1 then
    return false
  end
  vim.fn.system { python, "-c", ("import %s"):format(module) }
  return vim.v.shell_error == 0
end

local ruby_host = vim.fn.expand "~/.local/share/mise/shims/neovim-ruby-host"
if vim.fn.executable(ruby_host) == 1 then
  g.ruby_host_prog = ruby_host
else
  g.loaded_ruby_provider = 0
end

for _, python in ipairs { vim.fn.expand "~/.local/share/mise/shims/python3", "python3" } do
  if has_python_module(python, "neovim") or has_python_module(python, "pynvim") then
    g.python3_host_prog = python
    break
  end
end

if not g.python3_host_prog or g.python3_host_prog == "" then
  g.loaded_python3_provider = 0
end

g.loaded_node_provider = 0
g.loaded_python_provider = 0
g.loaded_python2_provider = 0
g.loaded_perl_provider = 0
