# audit

Re-run the Neovim configuration audit to find issues.

## Checks

### Critical

- Keymaps defined multiple times with same lhs
- Modules required multiple times
- Options set in multiple files
- `setup()` functions that are never called
- Missing enabled options (undofile, backup) when dirs are configured

### Functional

- Deprecated Neovim APIs (vim.fn.sign_define, vim.lsp.diagnostic.*)
- Plugin specs with incorrect fields (build on wrong plugin)
- Missing plugin dependencies
- Snippet expand as no-op in nvim-cmp

### Style

- Redundant settings
- Misleading comments
- Dead code (commented requires, unused variables)

## Output

- Group findings by severity (Critical → Style)
- Include file:line references
- Compare against TODO.md - note which issues are already tracked
- Suggest new tasks for untracked issues
