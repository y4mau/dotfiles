---
description: Review and fix a PR with Codex CLI (5 iterations)
argument-hint: "<pr-number>"
allowed-tools:
  - Bash(gh:*)
  - Bash(git:*)
  - Bash(codex exec:*)
  - Bash(npx eslint:*)
  - Bash(npm run lint:*)
  - Bash(cd:*)
  - Bash(ls:*)
  - Bash(pwd:*)
  - Bash(terminal-notifier:*)
  - Read
  - Edit
  - Glob
  - Grep
---

## Context
- Repo check: !`git rev-parse --is-inside-work-tree`
- Current branch: !`git branch --show-current`
- Repo root: !`git rev-parse --show-toplevel`
- Working directory: !`pwd`

## Task
You will review and fix a PR using Codex CLI across 5 iterations. The PR number is provided as `$1`.

**IMPORTANT:** This is a multi-iteration review+fix workflow. You MUST complete all 5 iterations.

---

### Step 1) Fetch PR metadata

Run:
```bash
gh pr view $1 --json number,title,headRefName,baseRefName,files,body
```

Extract:
- `PR_NUMBER`: the PR number
- `PR_TITLE`: the PR title
- `HEAD_BRANCH`: the PR's head branch name
- `BASE_BRANCH`: the PR's base branch name (usually `main`)
- `CHANGED_FILES`: list of changed files
- `PR_BODY`: the PR description

Display: PR number, title, head branch, base branch, and number of changed files.

---

### Step 2) Switch to PR branch via worktree

Follow the CLAUDE.md worktree convention: `<repo-root>/.worktrees/<branch-name>`

1. Check if worktree already exists at `<repo-root>/.worktrees/<HEAD_BRANCH>`.
2. If it exists, `cd` into it.
3. If not, create a new worktree:
   ```bash
   git fetch origin
   git worktree add <repo-root>/.worktrees/<HEAD_BRANCH> origin/<HEAD_BRANCH>
   ```
4. Ensure `.worktrees/` is in `.git/info/exclude`.
5. Run `git fetch origin` and ensure the branch is up to date with remote.
6. Confirm current branch and working directory.

All subsequent commands MUST run in the worktree directory.

---

### Step 3) Iterations 1-2: First Codex review + apply fixes

#### 3a) Run Codex review (iteration 1)

Run:
```bash
codex exec "<PROMPT>" 2>&1
```

Where `<PROMPT>` is:

```
You are a senior code reviewer. Review the patch between <BASE_BRANCH> and HEAD.

Base branch: origin/<BASE_BRANCH>

Run: git diff --patch origin/<BASE_BRANCH>...HEAD

## PR context
- PR #<PR_NUMBER>: <PR_TITLE>
- Branch: <HEAD_BRANCH>
- Changed files: <CHANGED_FILES list>

## Review instructions

Perform a strict code review of the full diff. Check for:
- Correctness (logic bugs, edge cases, missing null checks)
- Security (XSS, injection, unsafe patterns)
- Performance (unnecessary re-renders, missing memoization, bundle size)
- Readability (naming, structure, duplication)
- Compatibility (browser support, React patterns, Next.js best practices)
- A11y (WCAG compliance, keyboard navigation, screen reader support)
- Missing tests (note: flag what SHOULD be tested)

Output your review in Markdown with these sections:
## Summary
## Blocking issues
## Non-blocking suggestions
## Tests to add
## Risk assessment
(low/medium/high with reasons)

For each issue, provide:
- File path and line range
- Description of the problem
- Suggested fix (code snippet if possible)
```

#### 3b) Apply fixes from iteration 1

1. Display the review results to the user with label "Iteration 1/5".
2. Apply all **blocking issues** using Edit tool.
3. Apply **non-blocking suggestions** that are low-effort and clearly beneficial.
4. For non-blocking items that are out of scope or high-effort, mark as DEFERRED with reason.
5. Run lint on changed files: `npx eslint <changed-files>`
6. Commit per meaningful minimum unit following Conventional Commits.
   - Use specific `git add <files>` (never `git add .`)
   - Group related fixes into logical commits
   - Add `Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>` footer

#### 3c) Iteration 2 (continued fixes if needed)

If there were many fixes in iteration 1 that couldn't all be applied at once, continue applying remaining fixes. If all fixes from iteration 1 were applied, skip to Step 4.

---

### Step 4) Iteration 3: Second Codex review pass

#### 4a) Build supplemental context

Accumulate context from iterations 1-2:
- What was fixed (with RESOLVED status)
- What was deferred (with DEFERRED status and reason)
- What is out of scope

#### 4b) Run Codex review (iteration 3)

Run:
```bash
codex exec "<PROMPT>" 2>&1
```

Where `<PROMPT>` is:

```
You are a senior code reviewer performing a SECOND review pass. Review the patch between origin/<BASE_BRANCH> and HEAD.

Base branch: origin/<BASE_BRANCH>

Run: git diff --patch origin/<BASE_BRANCH>...HEAD

## Supplemental context

**Background**: PR #<PR_NUMBER> (<HEAD_BRANCH>) — <PR_TITLE>

**Prior concerns from iteration 1 (status):**
<list each concern with RESOLVED/DEFERRED status>

**Resolutions**: <describe what was fixed and how>

**Out of scope**: <list deferred items with reasons>

## Review instructions

This is the SECOND review pass. Focus on:
- Verify that all previously reported fixes were applied correctly
- Check for regressions introduced by the fixes
- Any NEW issues not caught in the first pass
- CSS consistency and correctness
- Verify semantic attributes are syntactically correct

Output your review in Markdown with these sections:
## Summary
## Blocking issues
## Non-blocking suggestions
## Tests to add
## Risk assessment
(low/medium/high with reasons)
```

#### 4c) Apply fixes from iteration 3

Same process as 3b:
1. Display review with label "Iteration 3/5".
2. Apply blocking issues immediately.
3. Apply low-effort non-blocking suggestions.
4. Defer high-effort or out-of-scope items.
5. Lint changed files.
6. Commit per meaningful minimum unit.

---

### Step 5) Iteration 4: Third Codex review pass

#### 5a) Update supplemental context

Add iteration 3 results to the accumulated context.

#### 5b) Run Codex review (iteration 4)

Run:
```bash
codex exec "<PROMPT>" 2>&1
```

Where `<PROMPT>` is:

```
You are a senior code reviewer performing a THIRD review pass. Review the patch between origin/<BASE_BRANCH> and HEAD.

Base branch: origin/<BASE_BRANCH>

Run: git diff --patch origin/<BASE_BRANCH>...HEAD

## Supplemental context

**Background**: PR #<PR_NUMBER> (<HEAD_BRANCH>) — <PR_TITLE>

**Prior concerns from iteration 1 (status):**
<list each concern with RESOLVED/DEFERRED status>

**Prior concerns from iteration 3 (status):**
<list each concern with RESOLVED/DEFERRED status>

**Resolutions**: <describe all fixes applied so far>

**Out of scope**: <list all deferred items>

## Review instructions

This is the THIRD review pass. Focus on:
- Verify ALL previously reported fixes were applied correctly
- Check for regressions introduced by any fixes
- Catch any remaining issues not found in earlier passes
- Final polish items

Output your review in Markdown with these sections:
## Summary
## Blocking issues
## Non-blocking suggestions
## Tests to add
## Risk assessment
(low/medium/high with reasons)
```

#### 5c) Apply fixes from iteration 4

Same process:
1. Display review with label "Iteration 4/5".
2. Apply fixes, lint, commit.

---

### Step 6) Iteration 5: Final read-only verification

This iteration is **read-only** — no edits allowed. Run verification checks:

```bash
git log origin/<BASE_BRANCH>..HEAD --oneline
npm run lint 2>&1
git diff --name-only origin/<BASE_BRANCH>...HEAD
```

Output a **PASS/FAIL report** in this format:

```
## Final Verification (Iteration 5/5)

| Check         | Result |
|---------------|--------|
| Lint           | PASS/FAIL (details) |
| Diff clean     | PASS/FAIL (changed files list) |
| Commits        | N commits (list) |
| Blocking fixes | N applied |
| Deferred items | N (list) |

**Overall: PASS / FAIL**
```

If FAIL, describe what needs attention before merging.

---

### Step 7) Push changes

**Ask the user for confirmation before pushing** (per CLAUDE.md rules).

If confirmed:
```bash
git push origin <HEAD_BRANCH>
```

---

### Step 8) Post PR comment (Japanese summary)

Post a Japanese summary comment on the PR:

```bash
gh pr comment <PR_NUMBER> --body "$(cat <<'EOF'
## Codex レビュー対応（5イテレーション完了）

Codex CLI によるコードレビューを実施し、指摘事項を5回のイテレーションで修正しました。

### 適用した修正

<group fixes by category, e.g.:>

**<Category name in Japanese>**
- <fix description in Japanese>

### コミット一覧
```
<git log --oneline output>
```

### Codex レビュー結果
- **パス1**: ブロッキングN件 + 非ブロッキングN件 → 対応状況
- **パス2**: ブロッキングN件 + 非ブロッキングN件 → 対応状況
- **パス3**: ブロッキングN件 + 非ブロッキングN件 → 対応状況

### スコープ外（今後対応）
- <deferred item in Japanese>
EOF
)"
```

---

### Step 9) Notify completion

```bash
terminal-notifier -title "Claude Code" -message "Task completed: Codex review+fix PR #$1 (5 iterations)" -activate com.googlecode.iterm2
```

---

## Important Rules

- **Commits**: Always commit per meaningful minimum unit. Never bundle unrelated fixes.
- **Lint**: Run eslint on changed files before each commit.
- **Context accumulation**: Each Codex review pass MUST include supplemental context from all previous iterations.
- **Deferred items**: Clearly track items marked as DEFERRED with reasons. Include them in supplemental context.
- **No over-fixing**: Only apply fixes that Codex flags. Do not make additional changes.
- **Final newline**: Ensure all edited files have a final newline.
- **Push confirmation**: Always ask user before pushing.
- **Japanese comment**: Post the final summary in Japanese with English section headings.

Now execute steps 1–9 for PR `$1`.
