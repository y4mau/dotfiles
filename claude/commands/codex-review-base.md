---
description: Review diff between base branch and HEAD using Codex CLI
argument-hint: "[base-branch (optional; default: origin/main|main|origin/master|master)]"
allowed-tools:
  - Bash(git rev-parse:*)
  - Bash(git branch:*)
  - Bash(git show-ref:*)
  - Bash(git fetch:*)
  - Bash(git diff:*)
  - Bash(codex exec:*)
---

## Context
- Repo check: !`git rev-parse --is-inside-work-tree`
- Current branch: !`git branch --show-current`
- Branch tracking info: !`git branch -vv`
- Remote branches: !`git branch -r`

## Task
You will ask Codex CLI to review the code changes between a **base branch** and **HEAD**.

### Step 1) Decide BASE
- If the user provided an argument, use it as BASE: `$1`
- Otherwise select the first existing ref in this order:
  1. `origin/main`
  2. `main`
  3. `origin/master`
  4. `master`

If the chosen BASE is missing locally, run: `git fetch origin --prune` and re-check.

### Step 2) Show quick diff overview (BASE...HEAD)
Use triple-dot diff (merge-base) unless user explicitly asks otherwise.
Include:
- `git diff --stat BASE...HEAD`
- `git diff --name-only BASE...HEAD`

### Step 2.5) Gather supplemental context
Before calling Codex, check the current conversation for any relevant context that would help the reviewer. Build a `CONTEXT` block (may be empty) containing:

- **Background**: important context about the branch purpose or architecture decisions
- **Prior concerns**: issues previously raised by Codex or human reviewers in this session
- **Resolutions**: which concerns were addressed, which were deferred, and why

Format as a plain-text block. If there is no relevant prior context, leave `CONTEXT` empty.

### Step 3) Codex review (read-only)
Run Codex CLI and ask it to review the patch. Do NOT apply changes automatically.

Run:
`codex exec "<PROMPT>"`

Where <PROMPT> does:
- State the resolved BASE ref (e.g. "Base branch: origin/main") so the reviewer knows the comparison point
- Run: `git diff --patch BASE...HEAD`
- If CONTEXT is non-empty, include it verbatim under a "## Supplemental context" heading before the review instructions
- Strict review for correctness, security, performance, readability, compatibility, missing tests
- Output Markdown with sections:
  - Summary
  - Blocking issues
  - Non-blocking suggestions
  - Tests to add
  - Risk assessment (low/medium/high) with reasons

### Important
- Keep everything read-only (no commits, no formatting, no edits) unless the user explicitly requests changes.
- If the diff is huge, propose reviewing file-by-file.

Now execute steps 1–3.

