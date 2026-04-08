-- Mason bootstrap -------------------------------------------------------------
local mason = require "mason"
local mason_lspconfig = require "mason-lspconfig"

mason.setup()

-- Tools to ensure installed --------------------------------------------------
require("mason-tool-installer").setup {
  ensure_installed = {
    "ruby-lsp",
    "standardrb",
    "rubocop",
    "debugpy", -- For DAP (via dap-ruby)
    "stylua",
    "selene",
    "gopls",
    "goimports",
  },
  auto_update = true,
  run_on_start = true,
}

-- Capabilities ----------------------------------------------------------------
-- Blink.cmp handles capabilities automatically if we use its provide function
local capabilities = require("blink.cmp").get_lsp_capabilities()

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

-- Server configurations ------------------------------------------------------
local servers = {
  gopls = {
    settings = {
      gopls = {
        usePlaceholders = true,
        completeUnimported = true,
        analyses = { unusedparams = true },
      },
    },
  },
  lua_ls = {
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
  },
  ruby_lsp = {
    cmd = { "bundle", "exec", "ruby-lsp" },
    init_options = {
      formatter = "auto",
      indexing = {
        enabled = true,
      },
    },
  },
  vimls = {},
}

local function setup_ruby_lsp_mappings(bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = "RubyLSP: " .. desc })
  end
  -- Ruby-LSP specific features (often uses standard LSP calls but sometimes specific ones)
  map("n", "<leader>ih", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, "Toggle Inlay Hints")
end

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  handlers = {
    function(server_name)
      local opts = vim.tbl_deep_extend("force", {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          if server_name == "ruby_lsp" then
            setup_ruby_lsp_mappings(bufnr)
          end
        end,
      }, servers[server_name] or {})
      require("lspconfig")[server_name].setup(opts)
    end,
  },
}
