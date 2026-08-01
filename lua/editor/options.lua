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

-- Clipboard: "copy-on-yank" model. We intentionally do NOT set unnamedplus —
-- that would route deletes through the system clipboard and clobber it. Instead
-- yanks are mirrored to the + register via a TextYankPost autocmd (see
-- editor/autocmds.lua), so copying is automatic while deletes never touch the
-- OS clipboard. Paste external content with "+p (or Cmd+V in insert mode).
opt.clipboard = ""

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

-- ponytail: prevents E764 on buffers where no plugin has set omnifunc;
-- blink.cmp owns normal completion, this is only the <C-X><C-O> fallback.
opt.omnifunc = "v:lua.vim.lsp.omnifunc"
opt.completeopt = { "menuone", "noselect", "noinsert" }

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

-- Python provider: probing for neovim/pynvim spawns up to 4 interpreters
-- through the mise shims (~200ms of startup), so the result — including the
-- negative "no candidate has the module" case — is cached on disk, keyed on
-- each candidate's resolved path + mtime. Cache hit: zero subprocess spawns.
-- The key invalidates when a shim or interpreter changes; installing pynvim
-- into an existing interpreter does not touch its mtime, so after
-- `pip install pynvim` delete the cache file to force a re-probe.
local python_candidates = { vim.fn.expand "~/.local/share/mise/shims/python3", "python3" }
local python_cache = vim.fn.stdpath "cache" .. "/python3_host_prog"

local function python_cache_key()
  local parts = {}
  for _, python in ipairs(python_candidates) do
    local resolved = vim.fn.exepath(python)
    parts[#parts + 1] = resolved .. "@" .. vim.fn.getftime(resolved)
  end
  return table.concat(parts, ";")
end

local function probe_python_host()
  for _, python in ipairs(python_candidates) do
    if has_python_module(python, "neovim") or has_python_module(python, "pynvim") then
      return python
    end
  end
  return ""
end

local function resolve_python_host()
  local key = python_cache_key()
  local ok, cached = pcall(vim.fn.readfile, python_cache)
  if ok and cached[1] == key and cached[2] ~= nil then
    return cached[2]
  end
  local host = probe_python_host()
  local cache_dir = vim.fn.stdpath "cache"
  if vim.fn.isdirectory(cache_dir) == 0 then
    vim.fn.mkdir(cache_dir, "p")
  end
  pcall(vim.fn.writefile, { key, host }, python_cache)
  return host
end

local python_host = resolve_python_host()
if python_host ~= "" then
  g.python3_host_prog = python_host
else
  g.loaded_python3_provider = 0
end

g.loaded_node_provider = 0
g.loaded_python_provider = 0
g.loaded_python2_provider = 0
g.loaded_perl_provider = 0
