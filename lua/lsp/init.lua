-- Mason bootstrap -------------------------------------------------------------
require("mason").setup()

-- Non-LSP tools managed by Mason (Ruby tools are global gems, not here)
require("mason-tool-installer").setup {
  ensure_installed = { "debugpy", "stylua", "selene", "goimports" },
  auto_update = true,
  run_on_start = true,
}

-- Keymaps on attach -----------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
    end
    map("n", "gd",          vim.lsp.buf.definition,     "Go to definition")
    map("n", "K",           vim.lsp.buf.hover,           "Hover")
    map("n", "gr",          vim.lsp.buf.references,      "References")
    map("n", "<leader>rn",  vim.lsp.buf.rename,          "Rename")
    map("n", "<leader>ca",  vim.lsp.buf.code_action,     "Code action")
    map("n", "[d",          vim.diagnostic.goto_prev,    "Prev diagnostic")
    map("n", "]d",          vim.diagnostic.goto_next,    "Next diagnostic")
    map("n", "<leader>d",   vim.diagnostic.open_float,   "Show diagnostic")
    map("n", "<leader>q",   vim.diagnostic.setloclist,   "Diagnostics list")
    if client.name == "ruby_lsp" then
      map("n", "<leader>ih", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, "RubyLSP: Toggle Inlay Hints")
    end
  end,
})

-- Global defaults -------------------------------------------------------------
vim.lsp.config("*", {
  capabilities = require("blink.cmp").get_lsp_capabilities(),
})

-- Server-specific overrides ---------------------------------------------------
-- nvim-lspconfig ships lsp/*.lua with default cmd/filetypes/root_markers;
-- we only need to specify settings that differ from those defaults.

vim.lsp.config("gopls", {
  settings = {
    gopls = {
      usePlaceholders = true,
      completeUnimported = true,
      analyses = { unusedparams = true },
    },
  },
})

vim.lsp.config("lua_ls", {
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
})

-- Ruby servers: global gems managed outside Mason (see ~/.mise.toml postinstall
-- hook). Run `:MasonUninstall ruby-lsp standardrb` if they were previously
-- installed via Mason to avoid the old broken binaries being found first.
vim.lsp.config("ruby_lsp", {
  init_options = {
    formatter = "auto",
  },
})

vim.lsp.enable({ "ruby_lsp", "standardrb" })

-- Mason-managed LSP servers ---------------------------------------------------
-- automatic_enable = true calls vim.lsp.enable() for every installed package.
require("mason-lspconfig").setup {
  ensure_installed = { "gopls", "lua_ls", "vimls", "stylelint_lsp" },
  automatic_enable = true,
}
