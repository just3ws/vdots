local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local cmp = require("cmp")

mason.setup()
mason_lspconfig.setup({
  ensure_installed = { "ruby_lsp", "gopls", "lua_ls", "vimls" },
  automatic_installation = true,
})

-- Filetype mapping
local server_filetypes = {
  ruby_lsp = { "ruby" },
  gopls = { "go", "gomod" },
  lua_ls = { "lua" },
  vimls = { "vim" },
}

-- Keymaps when a server attaches
local function on_attach(_, bufnr)
  local opts = { buffer = bufnr, silent = true, noremap = true }
  local map = vim.keymap.set
  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
  map("n", "gr", vim.lsp.buf.references, opts)
  map("n", "<leader>rn", vim.lsp.buf.rename, opts)
  map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  map("n", "[d", vim.diagnostic.goto_prev, opts)
  map("n", "]d", vim.diagnostic.goto_next, opts)
  map("n", "<leader>e", vim.diagnostic.open_float, opts)
  map("n", "<leader>q", vim.diagnostic.setloclist, opts)
end

-- nvim-cmp integration
cmp.setup({
  mapping = {
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
})

-- Cmdline completions
cmp.setup.cmdline({ "/", "?" }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = { { name = "buffer" } },
})
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
})

-- Capabilities for all LSPs
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Launch servers dynamically when relevant filetypes are opened
for server, patterns in pairs(server_filetypes) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = patterns,
    callback = function(args)
      local cfg = vim.lsp.config[server] or {}
      vim.lsp.start({
        name = server,
        cmd = cfg.cmd or { vim.fn.stdpath("data") .. "/mason/bin/" .. server },
        root_dir = cfg.root_dir or vim.fs.root(args.buf, { ".git", "go.mod", "Gemfile" }),
        capabilities = capabilities,
        on_attach = on_attach,
        settings = cfg.settings or {},
      })
    end,
  })
end

vim.lsp.config.lua_ls = {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
    },
  },
}
