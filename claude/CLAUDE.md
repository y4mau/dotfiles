## Git Workflow Memories

### PR Description Template
- After running `git push`, generate a PR description following this format:

```
## Issue
- [usually branch name has issue number like ky/<issue number>/... but you may remain blank if you cannot identify the number]

## Purpose
- [describe why you need to change codes and what the changes accomplish in few lines.]

## Changes
- [list changes grouped by meaningful units]

## Results
- [usually put the results for example, screenshots for frontend update, logs for backend or batch update, and so on.]

## Tests
- [optional. if changes affects conventional tests and updated them, write how tests changed]
```
- After generating the description in English, output the description in Japanese
- After generation of PR description, copy to clipboard and output notice message
- When generating PR description, write headings in English and body in Japanese, and do not write 'Generated with...'
- **Purpose Section Guidelines:**
  - Purpose section is to explain what the PR accomplishes
  - Focus on functionality based on differences between base and the PR's branch
  - Do not describe chore changes like "fix" based on additional instructions after implementation
- **Changes Section Guidelines:**
  - Explain how to accomplish purpose technically
  - Summarize meaningful units from changes
  - Do not describe changes as they appear in files changed

### Git Commit Message Guidelines

#### Conventional Commits Specification v1.0.0

We follow the Conventional Commits specification (https://www.conventionalcommits.org/en/v1.0.0/) for all commit messages. This provides a structured format that enables automation and improves readability.

**Format:**
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Important Rules:**
- Do NOT use emojis in commit messages
- The first line is the commit title (type + optional scope + description)
- Use lowercase for type and scope
- Start description with lowercase letter
- No period at the end of the description
- Use imperative mood in description ("add" not "adds" or "added")
- Limit the first line to 72 characters total
- Separate title from body with a blank line
- Wrap body at 72 characters

#### Commit Types (Required)

- **feat:** A new feature for the user, not a new feature for build script
- **fix:** A bug fix for the user, not a fix to a build script
- **docs:** Documentation only changes
- **style:** Formatting, missing semi colons, etc; no code change
- **refactor:** Refactoring production code, eg. renaming a variable
- **perf:** A code change that improves performance
- **test:** Adding missing tests, refactoring tests; no production code change
- **build:** Changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **ci:** Changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **chore:** Updating grunt tasks etc; no production code change
- **revert:** Reverts a previous commit

#### Scope (Optional)

The scope provides additional contextual information and is contained within parentheses.
- Keep it short and relevant
- Examples: `api`, `parser`, `core`, `ui`, `auth`, `db`
- Can be omitted for broad changes

#### Description Rules

- Use imperative, present tense: "change" not "changed" nor "changes"
- Don't capitalize first letter
- No period (.) at the end
- Limit to 72 characters minus the type and scope

#### Body Rules (Optional)

- Use imperative, present tense
- Include motivation for the change and contrast with previous behavior
- Wrap at 72 characters
- Can use bullet points (use `-` or `*`)

#### Footer Rules (Optional)

- Reference GitHub issues: `Closes #123`, `Fixes #456`
- Note breaking changes: `BREAKING CHANGE: <description>`
- Multiple footers are allowed

#### Breaking Changes

Breaking changes MUST be indicated in the footer with `BREAKING CHANGE:` prefix or by appending `!` after the type/scope.

Example:
```
feat!: remove support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6
```

#### Commit Message Examples

Simple feature:
```
feat: add email notifications for new posts
```

With scope:
```
fix(api): handle empty response body in user endpoint
```

With body:
```
refactor: update user authentication flow

replace password-based auth with OAuth2 implementation
to improve security and user experience

- remove password storage and validation
- add OAuth2 provider integration
- update session management
```

Breaking change:
```
feat(api)!: change user endpoint response format

BREAKING CHANGE: user endpoint now returns data wrapped
in a 'data' object instead of returning the user directly

Closes #789
```

Bug fix with details:
```
fix: prevent race condition in data sync

add mutex lock to prevent concurrent updates to user
preferences which was causing data corruption when
multiple devices synced simultaneously

Fixes #234
```

### Terminal Preferences
- Use bash instead of zsh
- Use ripgrep instead of grep
- Consider to use ripgrep instead of grep command

### Code Review and Testing
- Run rubocop -a and tests related to changes before completing a task
- Run rubocop before commit
- If you receive 'review [pr_url]', check file changes are just the right amount against description
- Before committing, ensure to pass related specs and rubocop
- When running rubocop, narrow down specific files which you changed
- Before git commit, run rspec and rubocop on related files

### Linting
- Run eslint if you need

### Development Process
- Follow test driven development
- When you start implement, start planning based on TDD methods proposed by t-wada

### Pull Request Guidelines
- Ensure to generate just the right amount title when you generate pull request
- If you create PR, ensure to be draft
- If you create several PRs for easy-review, write dependencies on each PRs' description
- When writing description for topic branch's PR, describe all commits are reviewed on the top of description

### Task Completion Notifications
- Send system notification when you finish a task using terminal-notifier
- Use the following command: `terminal-notifier -title "Claude Code" -message "Task completed: [task description]" -activate com.googlecode.iterm2`
- This allows users to click the notification to open iTerm2
- Note: Requires terminal-notifier to be installed via Homebrew (`brew install terminal-notifier`)

### Implementation Notification
- When asked to proceed with implementation, notify via system notification with terminal-notifier

### Code Comments
- TODO: do not add unnecessary comments and ensure to add prefix like 'TODO' 'FIXME' 'NOTE' to needed comments
- Do not add specs for private methods because it should be confirmed by calling public methods

### Git Worktree Workflow
- If you start new implementation, checkout new git worktree and start implementation there
- If working directory does not exist, create new git worktree env and implement there
- Worktree location pattern: `<path-to-main-directory>/.worktrees/<branch-name>`
- First time setup: Add `.worktrees/` to `.git/info/exclude`
- Contain creating worktree (if working branch does not exist) and commit per meaningful units, push, create pr
- Implement in branch-specific worktree env

### Specification and Testing
- If you create or modified specs, describe updated test cases in toggle block

### File Handling
- Ensure that all files has final newline
- Make sure updated files has final newline at the end
- You must check created or updated file has final newline and if it missing, add it.

### Display Directory and Branch Information
- Always display current directory and branch name on your response
- directory and branch name display format is [<directory(after ~), <branch>>]

### Commit Guidelines
- You must commit per meaningful minimum units. Do not commit which has several purpose.
- In planning for implementation tasks, contain committing per meaningful minimum units on the plan
- Follow Conventional Commits v1.0.0 specification strictly (see Git Commit Message Guidelines above)
- When using /commit command or git commit, do NOT use emojis
- Use lowercase for type and scope: `<type>: <description>` (e.g., `feat: add user authentication`)
- Start description with lowercase letter, no period at end

### Git Push Workflow
- Ask me if you run git push (exception: pr-review-implementer agent can push without asking)
- pr-review-implementer is allowed to push automatically when addressing review comments

### File Handling Updates
- Must: insert final newline at the end of every file

### Documentation
- Use Mermaid diagrams as needed when creating documents to visualize flows, architectures, relationships, and other structures
- Choose the appropriate Mermaid diagram type (flowchart, sequence, class, ER, state, etc.) based on the content
- Use `<br/>` instead of `\n` for line breaks in Mermaid node labels
- Use code blocks (not Mermaid) for directory structures
- Use dark-mode-friendly colors in Mermaid diagrams (avoid pure black backgrounds, prefer soft/muted tones such as `#2d333b`, `#58a6ff`, `#3fb950`, `#d29922`, `#f85149`)
- **Mermaid Width Control:**
  - Prefer `TD` (top-down) direction over `LR` to avoid horizontal overflow
  - Keep node labels under 4 words; use `<br/>` to wrap longer text vertically
  - Maximum 4 nodes at the same depth level; split into subgraphs if more
  - Avoid long edge labels; keep them under 3 words or omit

### Kubernetes
- Always specify `--context` and `--namespace` (or `-n`) when executing kubectl commands

### GitHub Resource Workflow
- If you see github resource, use gh commands

### Thinking Workflow
- think hard unless I instruct to use another mode

### Thinking Mode
- if you in plan mode, declare to use ultrathink first every your actions
- if you are in plan mode, declare to use ultrathink first every your actions
- default thinking mode is megathink. use ultrathink if you are in plan mode. declare thinking mode every first line of your response.

### Implementation Workflow
- if you encounter unexpected result during implementations, ask me whether you go on or replan

### Megathink Mode
- if you are not in plan mode, use megathink mode as default
- use megathink mode if you are in plan mode otherwise use think mode
- if you are instructed to log, follow this file format: `~/.claude/logs/<timestamp>_<log_name>.md`
- to run the rspec tests, use this command: bundle exec rspec path/to/spec
- if you encounter ruby's version issue, try rbenv exec
- do not use unnecessary arguments if there is default value on factory definition in rspec
- use toggled block when you write large code block on description of an issue or a pull request
- call worktree setup agent when you attempt to create new worktree env
