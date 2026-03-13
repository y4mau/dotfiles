---
description: Conventional Commits v1.0.0 specification for commit messages
globs:
---

# Git Commit Message Guidelines

Follow [Conventional Commits v1.0.0](https://www.conventionalcommits.org/en/v1.0.0/).

## Format

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

## Rules

- Do NOT use emojis
- Use lowercase for type and scope
- Start description with lowercase letter, no period at end
- Use imperative mood: "add" not "adds" or "added"
- Limit first line to 72 characters total
- Separate title from body with a blank line
- Wrap body at 72 characters

## Types

| Type | Description |
|------|-------------|
| `feat` | A new feature for the user |
| `fix` | A bug fix for the user |
| `docs` | Documentation only changes |
| `style` | Formatting; no code change |
| `refactor` | Refactoring production code |
| `perf` | Performance improvement |
| `test` | Adding/refactoring tests; no production code change |
| `build` | Build system or external dependencies |
| `ci` | CI configuration changes |
| `chore` | Maintenance tasks; no production code change |
| `revert` | Reverts a previous commit |

## Scope (Optional)

Short and relevant: `api`, `parser`, `core`, `ui`, `auth`, `db`. Omit for broad changes.

## Commit Granularity

- One logical change per commit
- If you can describe it with "and", split it
- Split: refactor + feature, fix + test, different modules for different reasons
- Keep together only if changes are tightly coupled

## Breaking Changes

Indicate with `!` after type/scope or `BREAKING CHANGE:` footer.

## Examples

```
feat: add user authentication system
fix(api): handle empty response body in user endpoint
feat!: remove support for Node 6
```
