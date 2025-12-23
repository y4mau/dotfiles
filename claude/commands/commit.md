# Git Commit Message Format Guide

Based on Conventional Commits v1.0.0 specification and CLAUDE.md guidelines

## instruction
execute git commit for current changes.

## commit rules
1. commit separately per meaningful and minimum units
   - Each commit should represent ONE logical change
   - Split changes into multiple commits if they serve different purposes
   - A commit should be the smallest unit that still makes sense on its own
   - If changes can be logically separated (e.g., refactor + feature, fix + test), commit them separately
2. follow Conventional Commits v1.0.0 specification strictly
3. do NOT use emojis in commit messages

## Basic Format

```
<type>: <description>
```

### Example
```
feat: add user authentication validation
```

## Commit Types

| Type | Description |
|------|-------------|
| `feat` | A new feature for the user |
| `fix` | A bug fix for the user |
| `docs` | Documentation only changes |
| `style` | Formatting, missing semi colons, etc; no code change |
| `refactor` | Refactoring production code |
| `perf` | A code change that improves performance |
| `test` | Adding missing tests; no production code change |
| `build` | Changes to build system or dependencies |
| `ci` | Changes to CI configuration files and scripts |
| `chore` | Updating tasks etc; no production code change |
| `revert` | Reverts a previous commit |

## Best Practices

### Message Guidelines (from CLAUDE.md)
- Do NOT use emojis in commit messages
- Use lowercase for type and scope
- Start description with lowercase letter
- No period at the end of the description
- Use imperative mood ("add" not "adds" or "added")
- Limit the first line to 72 characters total
- Separate title from body with a blank line
- Wrap body at 72 characters
- Link to Issue number when possible (#123)
- Keep commits granular but meaningful
- Commit per meaningful and minimum units (one logical change per commit)

### Language Considerations
- Write commit messages in English (as per CLAUDE.md examples)
- Maintain consistency within the team

### Commit Granularity
- Commit per meaningful and minimum units
- Each commit should represent ONE single logical change
- Do not commit changes with multiple purposes in a single commit
- Split into separate commits when:
  - Changes serve different purposes (e.g., refactoring + new feature)
  - Changes affect different components/modules independently
  - One change is a prerequisite for another (commit prerequisites first)
- A commit should be the smallest unit that still makes sense on its own
- If you can describe the commit with "and" (e.g., "add feature X and fix bug Y"), split it into two commits

### Scope (Optional)
The scope provides additional contextual information and is contained within parentheses.
- Keep it short and relevant
- Examples: `api`, `parser`, `core`, `ui`, `auth`, `db`
- Can be omitted for broad changes

## Examples

```
feat: add user authentication system
fix: resolve login validation error
refactor: extract service logic to separate class
test: add unit tests for user service
docs: update API documentation
style: fix code formatting issues
chore: update dependencies
perf: improve database query performance
revert: revert commit abc123

# With scope:
feat(auth): add two-factor authentication
fix(api): handle empty response body in user endpoint
refactor(core): update user authentication flow
```

## When to Split Commits

### Good: Multiple Commits
```
feat: add user authentication validation
fix: resolve login error when email is empty
test: add unit tests for authentication service
```

### Bad: Single Commit with Multiple Purposes
```
feat: add user authentication and fix login bug and add tests
```

### Decision Guide
- Split if: Changes can be reviewed/tested independently
- Split if: One change is a bug fix, another is a feature
- Split if: Changes affect different files/modules for different reasons
- Keep together if: Changes are tightly coupled and don't make sense separately

## Important Rules Summary

From CLAUDE.md Conventional Commits v1.0.0:
- Do NOT use emojis in commit messages
- Use lowercase for type and scope
- Start description with lowercase letter
- No period at the end of the description
- Use imperative mood
- Separate subject from body with blank line
- Wrap body at 72 characters
- Explain 'what' and 'why' in the body, not 'how'

## Template for Complex Commits

```
<type>(<scope>): <description>

<body explaining what and why>

<footer with breaking changes, closes, etc.>
```

### Example
```
feat(auth): add two-factor authentication

Implement two-factor authentication to enhance account security
- Adds Google Authenticator support
- Provides backup code generation
- Improves user account protection

Closes #123
```

### Breaking Changes
Breaking changes MUST be indicated in the footer with `BREAKING CHANGE:` prefix or by appending '!' character after the type/scope.

Example:
```
feat!: remove support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6
```
