---
name: daily-report
description: "Daily Report Generator"
allowed-tools: Bash, Read, Grep, Glob
---

# Daily Report Generator

Generate a concise daily report based on today's work activities.

## Steps

1. Run `git log --all --author="$(git config user.name)" --since="midnight" --oneline` to find today's commits
2. Summarize key achievements from commits and conversation
3. Identify the most important task for tomorrow based on context
4. Note any insights, blockers, or learnings

## Output Format

Generate the report in this exact format (keep each section to 1-3 bullet points max):

```
1. Key Achievements
- [Main accomplishment 1]
- [Main accomplishment 2]

2. Priority Task for Tomorrow
- [Most important next task]

3. Insights & Issues

What I did
- [Brief summary]

What I learned
- [Key learning]

What's next
- [Immediate next steps]
```

## After Generation

Copy the generated report to clipboard using: `echo "<report>" | pbcopy`

Notify user that the report has been copied to clipboard.
