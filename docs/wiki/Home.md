# vdots

vdots is the Neovim platform in the personal-OS ecosystem — a Lua-native configuration for Neovim 0.12+ targeting Ruby/Rails, Go, and TypeScript development. It manages plugins via the built-in `vim.pack` API (no external plugin manager), integrates with the zdots shell platform for context ingestion and task management, and ships a health CLI (`vdots-doctor`) parallel to zdots-doctor.

## Personal-OS Ecosystem

| Repo | Path | Role |
|------|------|------|
| zdots | `~/.config/zsh` | Shell platform: observability, AI stack, services |
| **vdots** | `~/.config/nvim` | **This repo** — Neovim platform: LSP, plugins, editor config |
| adots | `~` (bare at `~/.homegit`) | Home dotfiles + agent coordination |
| my | `~/my` | Private local-only control plane |

## Quick Reference

```bash
# Install
git clone git@github.com:just3ws/vdots.git ~/.config/nvim

# Health check
./bin/vdots-doctor          # human output
./bin/vdots-doctor --json   # machine output

# Sync plugins (inside Neovim)
:PackSync

# Run tests / lint
./test/run.sh
./test/lint.sh
stylua .
```

## Wiki Index

- [Architecture](Architecture.md) — entrypoint, module layout, plugin manager, load order
- [Plugins](Plugins.md) — every plugin and its role
- [LSP-and-Tooling](LSP-and-Tooling.md) — language servers, formatters, linters
- [Keymaps](Keymaps.md) — leader key, all notable bindings
