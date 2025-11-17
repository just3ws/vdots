-- ---------------------------------------------------------------------------
-- NERDTree setup (Left-side, clean icons, safe behavior)
-- ---------------------------------------------------------------------------
-- Force devicons to initialize early
-- Load devicons early and correctly
pcall(function()
  require("nvim-web-devicons").setup {
    override = {},
    default = true,
  }
end)

-- Clean icons (no brackets, no padding)
vim.g.DevIconsEnableFoldersOpenClose = 0
vim.g.NERDTreeGitStatusConcealBrackets = 1
vim.g.NERDTreeGitStatusUseNerdFonts = 1
vim.g.WebDevIconsExactMatch = 0
vim.g.WebDevIconsNerdTreeAfterGlyphPadding = ""
vim.g.WebDevIconsNerdTreeBeforeGlyphPadding = ""
vim.g.WebDevIconsNerdTreeGitPluginForceVAlign = 0
vim.g.WebDevIconsNerdTreeGlyphPadding = ""
vim.g.WebDevIconsUnicodeDecorateFolderNodes = 1

-- Toggle + find file
vim.keymap.set("n", "<leader>n", ":NERDTreeToggle<CR>", { silent = true })
vim.keymap.set("n", "<leader>ef", ":NERDTreeFind<CR>", { silent = true })

-- Auto-open for directories
vim.cmd [[
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter *
    \ if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") |
    \   execute 'NERDTree' argv()[0] |
    \   wincmd p |
    \ endif
]]

-- Auto-quit when NERDTree is last window
vim.cmd [[
  autocmd bufenter *
    \ if (winnr("$") == 1 &&
    \     exists("t:NERDTreeBufName") &&
    \     bufname() == t:NERDTreeBufName) |
    \   quit |
    \ endif
]]

-- -- Prevent NERDTree pane from receiving file openings
-- vim.cmd [[
--   autocmd BufEnter * if (winnr("$") > 1 && &filetype ==# 'nerdtree') |
--         \ wincmd l |
--         \ endif
-- ]]

-- Nordish highlights
vim.api.nvim_set_hl(0, "NERDTreeDir", { fg = "#81A1C1" })
vim.api.nvim_set_hl(0, "NERDTreeDirSlash", { fg = "#81A1C1" })
vim.api.nvim_set_hl(0, "NERDTreeOpenable", { fg = "#8FBCBB" })
vim.api.nvim_set_hl(0, "NERDTreeClosable", { fg = "#8FBCBB" })
vim.api.nvim_set_hl(0, "NERDTreeExecFile", { fg = "#A3BE8C", bold = true })
vim.api.nvim_set_hl(0, "NERDTreeFile", { fg = "#D8DEE9" })
vim.api.nvim_set_hl(0, "NERDTreeGitDirty", { fg = "#EBCB8B" })
vim.api.nvim_set_hl(0, "NERDTreeGitAdded", { fg = "#A3BE8C" })
vim.api.nvim_set_hl(0, "NERDTreeGitDeleted", { fg = "#BF616A" })
vim.api.nvim_set_hl(0, "NERDTreeGitModified", { fg = "#D08770" })
