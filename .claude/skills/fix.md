# fix

Work on a specific task from TODO.md.

## Usage

`/fix P0-1` or `/fix 1` (task number)

## Steps

1. Read TODO.md and find the specified task
2. Show the task details to the user
3. Read the affected file(s)
4. Propose the exact change with a diff preview
5. Ask for confirmation before applying
6. Apply the change
7. Run `/nvim-validate` equivalent checks
8. If valid, stage and commit with the suggested commit message from TODO.md
9. Update TODO.md to mark task complete with date and commit hash

## Rules

- One task per invocation
- Always show diff before applying
- Always validate after applying
- Never bundle multiple tasks
- If task has dependencies (blockedBy), check those first
