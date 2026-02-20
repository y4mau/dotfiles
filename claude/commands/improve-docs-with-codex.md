---
description: Improve created or updated documents by requesting Codex CLI review and repeating fixation until no concerns remain
argument-hint: "<file-path(s)> [--max-iterations=5]"
allowed-tools:
  - Bash(git rev-parse:*)
  - Bash(git diff:*)
  - Bash(git status:*)
  - Bash(codex exec:*)
  - Read
  - Edit
  - Glob
---

## Context
- Repo check: !`git rev-parse --is-inside-work-tree`
- Current branch: !`git branch --show-current`
- Working directory: !`pwd`

## Task
You will iteratively improve documents by requesting reviews from Codex CLI and applying fixes until no concerns remain.

### Step 1) Identify target documents
- If the user provided file path(s) as argument: `$ARGUMENTS`
- If no argument provided, detect created or updated documents from git status:
  - Run `git diff --name-only --diff-filter=AM HEAD` for staged files
  - Run `git diff --name-only --diff-filter=AM` for unstaged files
  - Run `git status --porcelain` to catch untracked new files
  - Filter to document files only (`.md`, `.txt`, `.rst`, `.adoc`, `.org`, `.html`)
- If no documents found, ask the user which file to review.

### Step 2) Read document content
- Read each target document in full using the Read tool.
- Understand the document's purpose, structure, and audience.

### Step 3) Review-fix loop (max iterations: 5, or user-specified `--max-iterations`)

For each iteration:

#### 3a) Request Codex review
Run:
`codex exec "<PROMPT>"`

Where `<PROMPT>` instructs Codex to:
- Read the target document: `cat <file-path>`
- Review strictly for the following aspects:
  - **Clarity**: Is the writing clear and unambiguous?
  - **Accuracy**: Are technical details, commands, and examples correct?
  - **Completeness**: Are there missing sections, steps, or explanations?
  - **Structure**: Is the document well-organized with proper headings and flow?
  - **Grammar & style**: Are there grammatical errors, typos, or inconsistent style?
  - **Formatting**: Is Markdown/markup syntax correct and consistent?
  - **Links & references**: Are references valid and up to date?
- Output a structured Markdown review with sections:
  - `## Verdict`: Either `NO_CONCERNS` or `HAS_CONCERNS`
  - `## Blocking issues` (must fix)
  - `## Non-blocking suggestions` (nice to have)
  - For each issue: file path, line range, description, and suggested fix

#### 3b) Parse review result
- If the Verdict is `NO_CONCERNS` → exit the loop and proceed to Step 4.
- If the Verdict is `HAS_CONCERNS`:
  - Display the review to the user with iteration number (e.g., "Iteration 1/5").
  - Apply fixes for all **blocking issues** using the Edit tool.
  - Apply fixes for **non-blocking suggestions** using the Edit tool.
  - After applying all fixes, continue to the next iteration.

#### 3c) Check iteration limit
- If max iterations reached and concerns still remain, display the remaining issues to the user and stop.

### Step 4) Final summary
After the loop completes, output:
- Total iterations performed
- Number of issues fixed per iteration
- Final verdict from Codex
- List of all changes made (grouped by file)

### Important
- Always preserve the original document's intent and voice.
- Do not make stylistic changes beyond what Codex flags.
- If Codex suggests a change that would alter meaning, flag it to the user instead of auto-applying.
- If a document is very large (>500 lines), review it section by section.
- After all fixes are applied, ensure the file has a final newline.

Now execute steps 1–4.
