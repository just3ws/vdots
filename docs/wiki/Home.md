# vdots

vdots is the Neovim platform in the personal-OS ecosystem — a Lua-native configuration for Neovim 0.12+ targeting Ruby/Rails, Go, and TypeScript development. It manages plugins via the built-in `vim.pack` API (no external plugin manager), integrates with the [zdots](https://github.com/just3ws/zdots/wiki) shell platform for context ingestion and task management, and ships a health CLI (`vdots-doctor`) parallel to zdots-doctor.

## The ecosystem

zdots, adots, vdots, and `my` form one personal-OS ecosystem.

| Repo | Path | Role | Wiki |
|------|------|------|------|
| zdots | `~/.config/zsh` | Shell platform: observability, AI stack, services | [zdots wiki](https://github.com/just3ws/zdots/wiki) |
| adots | `~` (bare at `~/.homegit`) | Home dotfiles + agent coordination | [adots wiki](https://github.com/just3ws/adots/wiki) |
| **vdots** | `~/.config/nvim` | **This repo** — Neovim platform: LSP, plugins, editor config | (self) |
| my | `~/my` | Private "Cerebral Control Plane" — local-only, no public wiki | [My-System](https://github.com/just3ws/adots/wiki/My-System) (adots wiki) |

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
