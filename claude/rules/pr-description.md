---
description: PR description template and pull request guidelines
globs:
---

# PR Description

## Template

After `git push`, generate a PR description in this format:

```
## Issue
- [branch name usually has issue number like ky/<issue number>/...]

## Purpose
- [what the PR accomplishes in a few lines]

## Changes
- [list changes grouped by meaningful units]

## Results
- [screenshots for frontend, logs for backend/batch, etc.]

## Tests
- [optional: how tests changed]
```

## Writing Guidelines

- **Purpose section:** explain what the PR accomplishes based on diff from base branch. Do not describe chore "fix" changes from post-implementation instructions
- **Changes section:** explain how purpose is accomplished technically. Summarize by meaningful units, not by files changed
- Write headings in English, body in Japanese
- Do not write "Generated with..."
- After generating in English, also output in Japanese
- Copy to clipboard and notify user

## PR Rules

- Generate concise, right-sized PR titles
- Always create PRs as **draft**
- For multi-PR sets, write dependencies in each PR's description
- For topic branch PRs, describe all commits being reviewed at the top
