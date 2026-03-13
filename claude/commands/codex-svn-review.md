---
description: Write SVN code to a codex workspace and invoke Codex CLI review
argument-hint: "<workspace-path>"
allowed-tools:
  - Bash(git:*)
  - Bash(codex exec:*)
  - Bash(ls:*)
  - Bash(pwd:*)
  - Bash(dir:*)
  - Bash(cat:*)
  - Bash(mkdir:*)
  - Read
  - Write
  - Glob
  - Grep
---

## Context
- Working directory: !`pwd`

## Task
You will populate a Codex workspace with code for review, invoke Codex CLI to perform the review, and save the results.

The workspace path is provided as argument: `$ARGUMENTS`

---

### Step 1) Validate workspace

1. Set `WORKSPACE` to the argument `$ARGUMENTS`.
2. Verify the path exists and contains `AGENTS.md`.
3. If not found, ask the user for the correct workspace path.
4. Display the workspace path and its current contents.

Run:
```
ls <WORKSPACE>/
ls <WORKSPACE>/review-targets/
ls <WORKSPACE>/context/
```

---

### Step 2) Clear previous review targets (if any)

Check if `review-targets/` contains files other than `.gitkeep`.

If non-empty, ask the user:
> "review-targets/ contains files from a previous session. Clear them before starting? (y/n)"

If yes, remove all files in `review-targets/` except `.gitkeep`.

---

### Step 3) Gather code to review

Ask the user how they want to provide code:

**Option A: Paste code snippets**
- Ask for a filename (e.g., `PlayerController.cpp`)
- Ask user to paste the code
- Write to `review-targets/<filename>`
- Repeat until user says "done"

**Option B: Provide file paths**
- User provides local file paths
- Read each file and copy content to `review-targets/`
- Preserve original filenames

**Option C: Provide a diff**
- User pastes a diff/patch
- Write to `review-targets/changes.diff`

After gathering, display the list of files in `review-targets/`.

---

### Step 4) Gather additional context (optional)

Ask the user:
> "Do you want to add any additional context? (conventions, domain rules, review focus)"

If yes:
- Ask what kind of context (conventions, domain rules, or general notes)
- Write to the appropriate file in `context/`:
  - `context/conventions.md` for coding conventions
  - `context/domain-rules.md` for domain-specific rules
  - `context/review-description.md` for review scope and focus

---

### Step 5) Create review description

Create `context/review-description.md` with:
- What is being reviewed (list of files)
- Why it's being reviewed (ask user for brief description)
- Any specific areas of concern

---

### Step 6) Stage files

Run from the workspace directory:
```
git add -A
```

Do NOT commit yet — Codex can read staged files.

---

### Step 7) Invoke Codex review

Run from the workspace directory:

```
codex exec "<PROMPT>"
```

Where `<PROMPT>` is:

```
You are reviewing code in this workspace. Follow the instructions in AGENTS.md.

1. Read AGENTS.md for review criteria and output format.
2. Read all files in context/ for project conventions, domain rules, and review scope.
3. Read all files in review-targets/ — this is the code to review.
4. Perform a thorough code review following AGENTS.md criteria.
5. Output your review in the format specified in AGENTS.md.

Important:
- Be specific with file paths and line numbers.
- Provide code snippets for suggested fixes.
- Classify issues as Blocking or Non-blocking.
```

Capture the full output from Codex.

---

### Step 8) Save results

Generate a timestamp: `YYYY-MM-DD_HHMMSS`

Save the Codex output to: `results/<timestamp>_review.md`

Add a header to the results file:
```markdown
# Code Review — <timestamp>

## Reviewed Files
<list of files in review-targets/>

## Review Context
<brief description from Step 5>

---

<Codex output>
```

---

### Step 9) Commit review session

Run from the workspace directory:
```
git add -A
git commit -m "chore: review session <timestamp>"
```

---

### Step 10) Display results and next steps

Display the full review results to the user.

Then ask:
> "Would you like to run another review round? (y/n)"

If yes, go back to Step 2.
If no, proceed to notification.

---

## Important Rules

- **Never push**: Workspace repos are local-only.
- **Stage before review**: Codex needs `git add -A` to see files.
- **Preserve context**: Don't overwrite `context/` files unless user confirms.
- **Final newline**: Ensure all written files have a final newline.
- **Cross-platform**: Use `git` commands which work on both bash and PowerShell. Avoid bash-specific syntax.
- **Results history**: Each review session creates a new timestamped file in `results/`. Never overwrite previous results.

Now execute steps 1–11 for workspace `$ARGUMENTS`.
