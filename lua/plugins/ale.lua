return {
  "dense-analysis/ale",
  event = { "BufReadPre", "BufNewFile" }, -- Load ALE when opening any file
  config = function()
    -- Filetype detection for uncommon extensions
    vim.filetype.add {
      extension = {
        ["gql"] = "graphql", -- .gql files as GraphQL
        ["graphqls"] = "graphql", -- .graphqls (schema) as GraphQL
        ["properties"] = "dosini", -- .properties as INI (dosini)
        ["slim"] = "slim", -- .slim templates
      },
    }

    -- Specify linters (ALE will only run these for the given filetypes).
    -- Omit tools already covered by an LSP server to avoid duplicate diagnostics:
    --   ruby_lsp handles RuboCop, lua_ls handles Lua diagnostics.
    vim.g.ale_linters = {
      slim = { "slimlint" }, -- Slim: Slim-Lint (no LSP)
      javascript = { "eslint" }, -- JS: ESLint (no JS LSP configured)
      typescript = { "eslint" }, -- TS: ESLint (no TS LSP configured)
      graphql = { "eslint" }, -- GraphQL: ESLint (GraphQL-ESLint plugin)
      yaml = { "yamllint" }, -- YAML: yamllint (no LSP)
      markdown = { "markdownlint" }, -- Markdown: markdownlint (no LSP)
      go = { "golangci-lint" }, -- Go: golangci-lint (gopls doesn't run it)
      dosini = { "pyinilint" }, -- .ini/.properties: pyinilint (no LSP)
    }

    -- Specify fixers/formatters for each filetype.
    -- trim_whitespace removed from * — BufWritePre autocmd already handles it.
    vim.g.ale_fixers = {
      ["*"] = { "remove_trailing_lines" },
      ruby = { "rubocop" }, -- Ruby: RuboCop auto-correct
      slim = {}, -- Slim: (no auto-fixer available)
      javascript = { "prettier" }, -- JS: Prettier
      typescript = { "prettier" }, -- TS: Prettier
      graphql = { "prettier" }, -- GraphQL: Prettier
      yaml = { "prettier" }, -- YAML: Prettier
      markdown = { "prettier" }, -- Markdown: Prettier
      lua = { "stylua" }, -- Lua: StyLua
      go = { "gofmt", "goimports" }, -- Go: gofmt + goimports
      json = { "prettier" },
      sh = { "shfmt" },
    }

    -- Lint on save and insert leave
    vim.g.ale_lint_on_text_changed = "never"
    vim.g.ale_lint_on_insert_leave = 1
    vim.g.ale_lint_on_save = 1

    -- Use floating windows for diagnostics
    vim.g.ale_open_list = 0
    vim.g.ale_echo_msg_error_str = "E"
    vim.g.ale_echo_msg_warning_str = "W"
    vim.g.ale_echo_msg_format = "[%linter%] %s [%severity%]"

    -- Enable automatic fixing on save (format on save)
    vim.g.ale_fix_on_save = 1 -- Set to 0 if you prefer manual :ALEFix
  end,
}
