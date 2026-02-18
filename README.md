# Vdots

My Neovim dotfiles.

## Installation

```shell
cd
mkdir -p ~/.local/share/nvim
git clone git@github.com:just3ws/vdots.git ~/.config/nvim
```

## Development

```shell
# Run smoke + unit tests
./test/run.sh

# Lint/format checks
./test/lint.sh

# Apply formatting
stylua .
```

## Search + Explorer Compatibility

- `:Rg` and `:Ack` now run ripgrep into the quickfix list (native workflow).
- NERDTree is first-class again (`:NERDTreeToggle`, `:NERDTreeFind`).
- Explorer keymaps: `;-e` (toggle), `;-ef` (toggle + focus file), plus compatibility aliases `;n` and `;ef`.
