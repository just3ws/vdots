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

    -- Specify linters (ALE will only run these for the given filetypes)
    vim.g.ale_linters = {
      ruby = { "rubocop" }, -- Ruby: RuboCop linter
      slim = { "slimlint" }, -- Slim: Slim-Lint
      javascript = { "eslint" }, -- JS: ESLint
      typescript = { "eslint" }, -- TS: ESLint (with tsserver/TS plugin)
      graphql = { "eslint" }, -- GraphQL: ESLint (GraphQL-ESLint plugin)
      yaml = { "yamllint" }, -- YAML: yamllint
      markdown = { "markdownlint" }, -- Markdown: markdownlint
      lua = { "luacheck" }, -- Lua: luacheck
      go = { "golangci-lint" }, -- Go: GolangCI-Lint
      dosini = { "pyinilint" }, -- .ini/.properties: pyinilint
    }

    -- Specify fixers/formatters for each filetype
    vim.g.ale_fixers = {
      ["*"] = { "remove_trailing_lines", "trim_whitespace" },
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
