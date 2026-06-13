# Native Consolidation Auditor

This skill helps identify plugins that can be replaced by native Neovim features.

## Audit Workflow

When auditing a plugin:

1. **Analyze Plugin Functionality**: Read the plugin's README and `lazy.nvim` spec in `lua/plugins/`.
2. **Search Neovim Documentation**: Use `:help` and online Neovim docs to see if the core has equivalent features (e.g., `:help listchars`, `:help treesitter`, `:help LSP`).
3. **Compare Effort vs. Gain**:
    - High effort (e.g., complex UI) -> Keep.
    - Low effort / Built-in equivalent -> Candidate for Native Refactor.
4. **Propose Plan**: Present the user with a recommendation based on:
    - Native alternative availability.
    - Complexity of replacement.
    - Potential impact on workflow.

## Guidelines

- Prioritize stability. Do not suggest a refactor if it degrades the current workflow.
- Focus on "native-first" configuration via `vim.opt`, `vim.keymap`, and built-in Lua APIs.
- Document any regressions or loss of functionality during the audit.
