-- Mason bootstrap -------------------------------------------------------------
local mason = require "mason"
local mason_lspconfig = require "mason-lspconfig"

mason.setup()
mason_lspconfig.setup {
  ensure_installed = { "ruby_lsp", "gopls", "lua_ls", "vimls" },
  automatic_installation = true,
}

-- Capabilities ----------------------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Keymaps on attach -----------------------------------------------------------
local function on_attach(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
  end
  map("n", "gd", vim.lsp.buf.definition, "Go to definition")
  map("n", "K", vim.lsp.buf.hover, "Hover")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
  map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
  map("n", "<leader>e", vim.diagnostic.open_float, "Show diagnostic")
  map("n", "<leader>q", vim.diagnostic.setloclist, "Diagnostics list")
end

-- nvim-cmp setup --------------------------------------------------------------
local cmp = require "cmp"

cmp.setup {
  snippet = { expand = function(_) end },
  mapping = cmp.mapping.preset.insert {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm { select = true },
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        buffer = "[Buf]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
}


-- Diagnostics configured in ui/diagnostics.lua (single source of truth)

-- Server configurations (new API) --------------------------------------------
vim.lsp.config.ruby_lsp = {
  cmd = { vim.fn.stdpath "data" .. "/mason/bin/ruby-lsp" },
  filetypes = { "ruby" },
  capabilities = capabilities,
  on_attach = on_attach,
}

vim.lsp.config.gopls = {
  cmd = { vim.fn.stdpath "data" .. "/mason/bin/gopls" },
  filetypes = { "go", "gomod" },
  settings = {
    gopls = {
      usePlaceholders = true,
      completeUnimported = true,
      analyses = { unusedparams = true },
    },
  },
  capabilities = capabilities,
  on_attach = on_attach,
}

vim.lsp.config.lua_ls = {
  cmd = { vim.fn.stdpath "data" .. "/mason/bin/lua-language-server" },
  filetypes = { "lua" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}

vim.lsp.config.vimls = {
  cmd = { vim.fn.stdpath "data" .. "/mason/bin/vim-language-server", "--stdio" },
  filetypes = { "vim" },
  capabilities = capabilities,
  on_attach = on_attach,
}

-- Enable servers --------------------------------------------------------------
vim.lsp.enable "ruby_lsp"
vim.lsp.enable "gopls"
vim.lsp.enable "lua_ls"
vim.lsp.enable "vimls"
