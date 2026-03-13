---
name: copy-pr-description
description: "Copy PR Description"
allowed-tools: Bash, Read, Grep, Glob
---

# Copy PR Description

Generate a PR description in Japanese and copy it to clipboard.

## Steps

1. Check if `.github/pull_request_template.md` exists
2. If template exists, use its structure as the format
3. Detect base branch (origin/main or main)
4. Run `git log --oneline <base>...HEAD` to get commits
5. Run `git diff --stat <base>...HEAD` to get changed files
6. Generate PR description based on commits and changes

## Template Handling

If `.github/pull_request_template.md` exists:
- Read the template structure
- Fill in sections based on commits and changes
- Keep section headers as-is (do NOT translate English headers to Japanese)

If no template exists, use this default format:

```
## 概要

- [変更内容1]
- [変更内容2]

## 変更内容

- `path/to/file` - 説明
- `path/to/file` - 説明

## テスト項目

- [ ] テスト項目1
- [ ] テスト項目2
```

## Copy to Clipboard

Use PowerShell's Set-Clipboard for proper Japanese encoding on WSL:

```bash
powershell.exe -Command "Set-Clipboard -Value '<description>'"
```

## Notes

- Always use Japanese for the description
- Do NOT include Claude Code signature line
- Keep it concise and focused
- Escape backticks in PowerShell command with backslash
- Respect the project's PR template structure when available
