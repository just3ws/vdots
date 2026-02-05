# nvim-validate

Validate the Neovim configuration for errors.

## Steps

1. Run syntax check on all Lua files:
```bash
find lua -name "*.lua" -exec luac -p {} \;
```

2. Run luacheck for lint errors:
```bash
luacheck . --config .luacheckrc
```

3. Test Neovim startup for runtime errors:
```bash
nvim --headless -c 'lua print("Config loaded OK")' -c 'qa!' 2>&1
```

4. Check for common issues:
   - Modules that export `setup()` but aren't called
   - Duplicate keymaps (grep for same lhs in different files)
   - Deprecated Neovim APIs (vim.fn.sign_define, etc.)

5. Report findings with file:line references.

If errors found, suggest fixes but don't apply without confirmation.
