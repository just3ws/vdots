# plugin-review

Review plugin health, updates, and potential consolidation.

## Steps

1. Parse `lua/plugins/init.lua` and `lua/plugins/ale.lua` for all plugins

2. For each plugin, check:
   - Is it still maintained? (last commit date via GitHub API)
   - Are there known deprecations or successors?
   - Is it actually used? (grep for require/commands/mappings)

3. Check `lazy-lock.json` against latest versions

4. Identify consolidation opportunities:
   - Overlapping functionality (e.g., two text-object plugins)
   - Vim plugins with native Neovim alternatives
   - Plugins superseded by Neovim core features

5. Report:
   - **Unmaintained**: No commits in 2+ years
   - **Unused**: No references found in config
   - **Superseded**: Better alternatives exist
   - **Update available**: Newer version in lock file

## Do Not
- Automatically update or remove plugins
- Present findings and let user decide
