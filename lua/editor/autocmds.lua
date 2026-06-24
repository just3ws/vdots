local augroup = vim.api.nvim_create_augroup("vimrc", { clear = true })

-- Resize splits automatically when Vim window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  command = "wincmd =",
})

-- 🤖 Live-reload buffers that Claude Code (or anything) edits on disk.
-- Without this, an open buffer holds the stale version and a save would
-- clobber Claude's work. checktime triggers FileChangedShellPost on real
-- changes, where we toast a funky notification + repaint git signs.
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  group = augroup,
  callback = function()
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      pcall(vim.cmd.checktime)
    end
  end,
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  group = augroup,
  callback = function(args)
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ":t")
    local ok, snacks = pcall(require, "snacks")
    local msg = "🤖 reloaded " .. name .. " (changed on disk)"
    if ok and snacks.notifier then
      snacks.notify(msg, { level = vim.log.levels.INFO, title = "Claude Code" })
    else
      vim.notify(msg, vim.log.levels.INFO)
    end
    pcall(function()
      require("gitsigns").refresh()
    end)
  end,
})

-- 📋 Copy-on-yank: mirror unnamed yanks to the system clipboard (+), but leave
-- deletes/changes alone so they never clobber what you copied. Explicit register
-- yanks (e.g. "ayy) stay private. See the clipboard note in editor/options.lua.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    local ev = vim.v.event
    if ev.operator == "y" and ev.regname == "" then
      pcall(vim.fn.setreg, "+", ev.regcontents, ev.regtype)
    end
  end,
})

-- Restore last cursor position when reopening a file
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local ft = vim.bo.filetype
    if ft ~= "gitcommit" and vim.fn.line [['"]] > 0 and vim.fn.line [['"]] <= vim.fn.line "$" then
      vim.schedule(function()
        pcall(function()
          vim.cmd 'normal! g`"'
        end)
      end)
    end
  end,
})

-- Automatically open images in default macOS viewer and close buffer
vim.api.nvim_create_autocmd("BufEnter", {
  group = augroup,
  pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif" },
  callback = function()
    vim.fn.jobstart({ "open", vim.fn.expand "%" }, { detach = true })
    vim.cmd "bwipeout!"
  end,
})

-- Add dash as part of word in certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "css", "scss", "slim", "html", "eruby", "coffee", "javascript", "wxml" },
  callback = function()
    vim.opt_local.iskeyword:append "-"
  end,
})

-- Filetype-specific indentation
local indent_settings = {
  javascript = 2,
  json = 2,
  markdown = 2,
  python = 4,
  ruby = 2,
}

for ft, size in pairs(indent_settings) do
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = ft,
    callback = function()
      vim.opt_local.tabstop = size
      vim.opt_local.shiftwidth = size
      vim.opt_local.softtabstop = size
    end,
  })
end

-- Filetype overrides based on filename patterns
local filetype_overrides = {
  ["*.md"] = "markdown",
  [".mdlrc"] = "ruby",
  [".env"] = "sh",
  ["*.bpmn"] = "xml",
  [".env.*"] = "sh",
  [".erdconfig"] = "yaml",
  [".eslintignore"] = "gitignore",
  [".npmignore"] = "gitignore",
  [".prettierignore"] = "gitignore",
  [".jscsrc"] = "json",
  [".jshintrc"] = "json",
  [".eslintrc"] = "json",
  [".prettierrc"] = "json",
  [".releaserc"] = "json",
  ["*.lst"] = "text",
}
for pattern, ft in pairs(filetype_overrides) do
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup,
    pattern = pattern,
    callback = function()
      vim.bo.filetype = ft
    end,
  })
end

-- Highlight trailing whitespace for specific filetypes
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup,
  pattern = { "*.py", "*.pyw", "*.c", "*.h" },
  callback = function()
    vim.schedule(function()
      pcall(function()
        vim.cmd [[match BadWhitespace /\s\+$/]]
      end)
    end)
  end,
})

-- Remove trailing whitespace and collapse excessive blank lines on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  callback = function()
    local save_cursor = vim.fn.getpos "."
    pcall(function()
      vim.cmd [[silent! %s/\s\+$//e]]
      vim.cmd [[silent! %s/\n\{3,\}/\r\r/e]]
    end)
    vim.fn.setpos(".", save_cursor)
  end,
})

-- Automatically close location list before quitting (except for quickfix)
vim.api.nvim_create_autocmd("QuitPre", {
  group = augroup,
  callback = function()
    vim.schedule(function()
      if vim.bo.filetype ~= "qf" then
        pcall(vim.cmd, "silent! lclose")
      end
    end)
  end,
})
