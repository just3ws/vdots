-- lua/editor/mason.lua — editor-only tool provisioning.
--
-- Tool-source split (one source of truth per tool):
--   * Mason  — tools used ONLY inside Neovim: the LSP servers below.
--   * zdots Brewfile — everything the shell or CI also runs: stylua, selene,
--     luacheck, shellcheck, shfmt, prettier(d), rubocop, standardrb, ...
--
-- Headless / CI runs skip Mason entirely — no editor, no need for servers,
-- and no point triggering async downloads on a throwaway runner.

local M = {}

-- Mason package names (not lspconfig names). Mirrors the vim.lsp.enable{} list
-- in init.lua, minus ruby_lsp / standardrb which are per-project bundler gems.
M.servers = {
  "lua-language-server",
  "gopls",
  "basedpyright",
  "yaml-language-server",
  "terraform-ls",
  "marksman", -- markdown LSP — handy when editing the read-aloud docs
  "vtsls", -- TypeScript/JavaScript LSP (monorepo-aware)
  "sqls", -- SQL LSP — Drizzle migrations + raw .sql files
  "js-debug-adapter", -- DAP adapter for Node/Vitest debugging
}

function M.setup()
  if vim.env.CI or #vim.api.nvim_list_uis() == 0 then
    return
  end
  local ok, mason = pcall(require, "mason")
  if not ok then
    return
  end
  mason.setup { PATH = "prepend" } -- put mason/bin ahead of $PATH before vim.lsp.enable

  local ok_i, installer = pcall(require, "mason-tool-installer")
  if ok_i then
    installer.setup { ensure_installed = M.servers, run_on_start = true }
  end
end

return M
