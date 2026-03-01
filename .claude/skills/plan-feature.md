# plan-feature

Plan the implementation of a new feature or integration.

## Usage

`/plan-feature AI code completion` or `/plan-feature snippet system`

## Steps

1. Research the feature:
   - What plugins/approaches exist?
   - What's the current Neovim ecosystem best practice?
   - What are the tradeoffs?

2. Analyze current config:
   - What existing plugins/config might conflict?
   - What patterns should the new feature follow? (Nord colors, leader mappings, etc.)
   - Where should new code live?

3. Create implementation plan:
   - List specific changes needed
   - Note any TODO.md tasks that should be done first
   - Identify config that should be removed/changed
   - Suggest keymaps (check for conflicts)

4. Present options if multiple approaches exist:
   - Comparison table with pros/cons
   - Recommendation with rationale

5. If approved, create tasks in TODO.md

## Do Not

- Implement without approval
- Recommend plugins without checking maintenance status
- Ignore existing patterns in the config
