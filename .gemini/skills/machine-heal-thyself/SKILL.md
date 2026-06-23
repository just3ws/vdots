---
name: machine-heal-thyself
description: Automatically diagnoses and remediates Neovim :checkhealth warnings and errors. Use when the user reports issues, the environment is unstable, or after major configuration changes to ensure health.
---

# Machine, Heal Thyself

## Goal
Automate the resolution of Neovim `:checkhealth` warnings and errors by leveraging `vdots-doctor` diagnostics.

## Prerequisites
- `vdots-doctor` (available in `bin/`)
- `jq` (for parsing JSON)

## Workflow

1. **Diagnose**: Run `./bin/vdots-doctor --json` to get the current health status and the path to the raw healthcheck file.
2. **Analyze**: Parse the raw healthcheck file (provided in the `vdots-doctor` output) for `WARNING` and `ERROR` patterns.
3. **Map**: Map identified issues to known remediation steps (e.g., missing treesitter parsers -> `TSInstall <lang>`, missing system tools -> suggest install command).
4. **Plan**: Propose a plan to the user:
   - Specific commands to fix issues (e.g., `:TSInstall`, config updates).
   - Expected outcome.
5. **Act**: Execute the approved remediation steps.
6. **Verify**: Re-run `./bin/vdots-doctor` to confirm the warning/error is resolved.

## Guidelines
- **Idempotency**: Remediation steps must be safe to run multiple times.
- **Safety**: Only propose actions that are reversible or clearly documented within the repo.
- **Documentation**: For issues that require manual system intervention (e.g., missing system-level binaries like `gs` or `tectonic`), clearly document the recommendation for the user.
- **Native-First**: Prefer native Neovim commands (`:TSInstall`, `vim.opt` changes) over external script hacks.
