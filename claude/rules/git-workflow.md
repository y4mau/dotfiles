---
description: Git push policy, worktree workflow, and branching conventions
globs:
---

# Git Workflow

## Push Policy

- If remote belongs to **y4mau** (including forks) → push without asking
- All other repositories → always ask before pushing
- `pr-review-implementer` agent can push without asking regardless of ownership

## Worktree Workflow

- Start new implementations in a new git worktree
- Location pattern: `<repo>/.worktrees/<branch-name>`
- First time setup: add `.worktrees/` to `.git/info/exclude`
- Call worktree setup agent when creating new worktree env
- Commit per meaningful minimum units, push, create PR

## Commit Discipline

- Commit per meaningful minimum units — one logical change per commit
- Do not commit changes with multiple purposes in a single commit
- In planning, include committing per meaningful minimum units
