lua << EOF
-- Detect Homebrew prefix based on architecture
local brew_prefix = vim.fn.has('mac') == 1 and
  (vim.fn.isdirectory('/opt/homebrew') == 1 and '/opt/homebrew' or '/usr/local') or ''

-- Update runtimepath dynamically for fzf or other Homebrew packages
vim.opt.runtimepath:append(brew_prefix .. '/opt/fzf')

require('plugins')
require('keymaps')
require('lsp')
require('treesitter')
require('options')
require('settings')
require('nvimtree')
require('linting')
require('formatting')
require('diagnostics')
require('autocmds')

if vim.fn.has('mac') == 1 then
  local brew_prefix = vim.fn.isdirectory('/opt/homebrew') == 1 and '/opt/homebrew' or '/usr/local'
end
EOF

set tags^=.git/tags

set background=dark
colorscheme nord
let g:airline_theme='nord'

highlight BadWhitespace ctermbg=red guibg=darkred

let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'split',
      \ 'ctrl-v': 'vsplit' }

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor

  let $FZF_DEFAULT_COMMAND = 'ag --literal --files-with-matches --nocolor --hidden -g ""'

  if !exists(':Ag')
    command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
    nnoremap \ :Ag<SPACE>
  endif
endif
