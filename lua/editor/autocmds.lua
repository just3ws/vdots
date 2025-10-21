local augroup = vim.api.nvim_create_augroup("vimrc", { clear = true })

-- Resize splits automatically when Vim window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  command = "wincmd =",
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
    vim.schedule(function()
      local save_cursor = vim.fn.getpos "."
      pcall(function()
        vim.cmd [[silent! %s/\s\+$//e]]
        vim.cmd [[silent! %s/\n\{3,\}/\r\r/e]]
      end)
      vim.fn.setpos(".", save_cursor)
    end)
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
