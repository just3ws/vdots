-- Detect Homebrew prefix dynamically
local brew_prefix = vim.fn.isdirectory("/opt/homebrew") == 1 and "/opt/homebrew" or "/usr/local"
vim.opt.runtimepath:append(brew_prefix .. "/opt/fzf")

-- Core modules (these should all live in ~/.config/nvim/lua/)
require("plugins")
require("options")
require("keymaps")
require("autocmds")
require("lsp")
require("treesitter")
require("linting")
require("formatting")
require("diagnostics")
require("nvimtree")
require("settings")

-- UI and appearance
vim.opt.tags:append(".git/tags")
vim.opt.background = "dark"
vim.cmd.colorscheme("nord")
vim.g.airline_theme = "nord"
vim.api.nvim_set_hl(0, "BadWhitespace", { ctermbg = "red", bg = "darkred" })

-- FZF integration
vim.g.fzf_action = {
  ["ctrl-t"] = "tab split",
  ["ctrl-x"] = "split",
  ["ctrl-v"] = "vsplit",
}

-- Grep integration (ag → rg fallback)
if vim.fn.executable("ag") == 1 then
  vim.opt.grepprg = "ag --nogroup --nocolor"
  vim.env.FZF_DEFAULT_COMMAND = "ag --literal --files-with-matches --nocolor --hidden -g ''"
elseif vim.fn.executable("rg") == 1 then
  vim.opt.grepprg = "rg --vimgrep"
  vim.env.FZF_DEFAULT_COMMAND = "rg --files --hidden --glob '!.git/*'"
end
