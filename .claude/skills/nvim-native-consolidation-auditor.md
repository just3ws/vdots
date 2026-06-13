# Native Consolidation Auditor

Skill: Audits plugin stack for native Neovim replacements and validates environmental health.

## Audit Workflow

### 1. Environmental Health
ALWAYS begin by running: `nvim --headless "+checkhealth" "+qall"`
Analyze the output.

### 2. Plugin Functionality
For a target plugin:
1. **Analyze Plugin Functionality**: Read README and `lazy.nvim` spec in `lua/plugins/`.
2. **Search Neovim Documentation**: Use `:help` and online Neovim docs to verify native equivalence.

### 3. Analysis & Documentation
Categorize findings from both environmental health and plugin analysis:

- **Actionable Internal Fixes**: Create a specific, step-by-step plan for changes needed *within* the repo (e.g., config changes, replacing plugin with native code, fixing test path issues).
- **External Environment Observations**: Document system-level, path, or Neovim-core issues that cannot be fixed within this repository (e.g., system dependencies, missing CLI tools, Neovim version bugs).

### 4. Propose Plan
Present to the user:
- Summary of `checkhealth` findings.
- Prioritized list of actionable internal fixes.
- List of external issues for awareness.

## Guidelines

- Stability first. No refactor if it degrades workflow.
- Focus "native-first" config via `vim.opt`, `vim.keymap`, built-in Lua APIs.
- "Fix your world and let others handle the rest" — prioritize repo-fixable tasks.
