---
description: Testing, linting, TDD, and code comment conventions
globs:
---

# Code Quality

## Development Process

- Follow test-driven development (TDD)
- When starting implementation, plan based on TDD methods proposed by t-wada

## Before Committing

- Run rubocop -a on specific files you changed (narrow scope)
- Run rspec on related spec files
- Run eslint when needed

## Code Review

- When receiving `review [pr_url]`, check file changes match the description
- If you create or modify specs, describe updated test cases in a toggle block

## Comments

- Do not add unnecessary comments
- Required comments must have prefix: `TODO`, `FIXME`, or `NOTE`
- Do not add specs for private methods — test through public methods
