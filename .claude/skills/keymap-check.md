# keymap-check

Check for keymap conflicts and document current bindings.

## Steps

1. Extract all keymaps from:
   - `lua/editor/keymaps/init.lua`
   - `lua/editor/nerdtree.lua`
   - `lua/editor/telescope.lua`
   - `lua/lsp/init.lua` (on_attach)
   - `lua/editor/treesitter.lua` (incremental_selection)
   - `lua/plugins/init.lua` (plugin-specific like Copilot)
   - `after/plugin/*.lua`

2. Build a map of: `mode + lhs -> [locations]`

3. Report:
   - **Conflicts**: Same mode+lhs defined in multiple places
   - **Shadows**: Mappings that shadow Vim defaults (document intentional ones)
   - **Gaps**: Common operations without bindings

4. Generate a markdown table of all bindings grouped by category:
   - Navigation
   - File tree
   - Search (Telescope)
   - LSP
   - Git
   - Editing

## Output Format

```markdown
## Conflicts
| Binding | Mode | Location 1 | Location 2 |
|---------|------|------------|------------|

## All Bindings
| Binding | Mode | Action | Source |
|---------|------|--------|--------|
```
