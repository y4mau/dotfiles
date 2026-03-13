---
name: commit
description: "Git Commit Message Format Guide"
allowed-tools: Bash, Read, Grep, Glob
---

# Git Commit

Execute git commit for current changes following Conventional Commits v1.0.0.

## Rules

See `rules/git-commit.md` for the full Conventional Commits specification.

## Process

1. Run `git status` and `git diff --cached` to understand staged changes
2. If nothing is staged, identify logical groups and stage them separately
3. Commit separately per meaningful minimum units — each commit = ONE logical change
4. If changes serve different purposes, split into multiple commits
5. Write commit message in imperative mood, lowercase, no emoji, no period
6. Limit first line to 72 characters

## Commit Granularity

- Each commit should be the smallest unit that still makes sense on its own
- If you can describe it with "and" (e.g., "add X and fix Y"), split it
- Split: refactor + feature, fix + test, different modules for different reasons
- Keep together only if changes are tightly coupled

## Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Types

`feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

## Examples

```
feat: add user authentication system
fix(api): handle empty response body in user endpoint
refactor: extract service logic to separate class
```
