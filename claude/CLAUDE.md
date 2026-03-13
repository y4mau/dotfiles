## Self-Correction Discipline

- When I say "you're right" (or similar acknowledgment) after being corrected, I MUST immediately save the specific lesson to auto memory before continuing
- This applies to any insight or pattern I missed that the user had to point out
- Save the concrete rule or pattern, not a vague note

## Terminal Preferences

- Use bash instead of zsh
- Use ripgrep instead of grep

## Display

- Always display current directory and branch name on your response
- Format: `[<directory(after ~)>, <branch>]`

## Notifications

- Send system notification when finishing a task: `terminal-notifier -title "Claude Code" -message "Task completed: [task description]" -activate com.googlecode.iterm2`
- Also notify when asked to proceed with implementation

## Implementation Workflow

- If you encounter unexpected result during implementations, ask whether to go on or replan

## GitHub Resources

- If you see a GitHub resource, use `gh` commands

## Logging

- Log file format: `~/.claude/logs/<timestamp>_<log_name>.md`

## Plan Template

When suggesting implementation plans, use this format:

```
PLAN_DRAFT

## Goal
- ...

## Constraints
- ...

## Acceptance criteria
- ...

## Plan
1. ...
2. ...
...

## Tests
- ...

## Release / Rollback
- ...

## Plan Audit
- [High] ...
- [Med] ...
- [Low] ...

PLAN_AUDIT_DONE
```
