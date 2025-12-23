# Rebuild Commit Tree

Based on Conventional Commits v1.0.0 specification and CLAUDE.md guidelines

## instruction
Rebuild the commit tree by organizing commits into meaningful and minimal units while preserving the final code state.

## commit rules
1. commit separately per meaningful and minimum units (CRITICAL RULE)
2. follow Conventional Commits v1.0.0 specification strictly
3. do NOT use emojis in commit messages
4. preserve the final code state exactly
5. each commit should represent a single logical change
6. do not commit changes with multiple purposes
7. do NOT add unnecessary comments (follow CLAUDE.md rules)
8. ensure code is clean before committing

## parameters
- base: The base branch or commit SHA where the current branch diverged from (optional - will auto-detect if not provided)

## process
1. Detect current branch and ensure it's not main/master
2. Identify the base commit (auto-detect or use provided parameter)
3. Create a backup branch for safety
4. Soft reset to the base commit
5. Analyze all changes and plan logical commit units
6. Stage and commit changes in meaningful minimal units:
   - Group related changes together
   - Separate unrelated changes into different commits
   - Each commit should have a single clear purpose
7. Review staged files and remove redundant comments before each commit
8. Create commits with appropriate messages following commit rules

## safety checks
- Never run on main/master branch
- Always create a backup branch first
- Ensure all changes are committed before starting
- Verify the final code state matches the original

## commit message format

When creating the final commit, follow Conventional Commits v1.0.0:

```
<type>(<scope>): <description>

<body explaining what was implemented>

<footer if applicable>
```

### Message Guidelines (from CLAUDE.md)
- Do NOT use emojis in commit messages
- Use lowercase for type and scope
- Start description with lowercase letter
- No period at the end of the description
- Use imperative mood ("add" not "adds" or "added")
- Limit the first line to 72 characters total
- Separate title from body with a blank line
- Wrap body at 72 characters

## commit granularity guidelines

When rebuilding commits:
- Each commit should do ONE thing well
- If you find yourself using "and" in the commit message, consider splitting
- Group related file changes that serve the same purpose
- Separate infrastructure changes from feature implementation
- Example breakdown for recipe generator:
  1. `feat: add csv parser with encoding support`
  2. `feat: add image upload functionality`
  3. `feat: implement recipe card component`
  4. `refactor: consolidate upload UI components`
  5. `build: add genjyuu gothic font dependency`

## comment cleanup guidelines

Before creating each commit:
- Remove redundant single-line comments that state the obvious
- Remove commented-out code
- Keep only essential comments that explain complex logic
- Follow CLAUDE.md rule: "DO NOT ADD ***ANY*** COMMENTS unless asked"
- Ensure interfaces and types are self-documenting without comments

## example workflow

```bash
# 1. Check current branch
git branch --show-current

# 2. Find base (auto-detect)
git merge-base HEAD origin/main  # or specified base

# 3. Create backup
git branch backup-<branch-name>

# 4. Soft reset to base
git reset --soft <base-commit>

# 5. Plan commit breakdown based on logical units
# Example: CSV parsing, image handling, UI components, etc.

# 6. Create first commit - CSV parser
git add apps/staff-admin/lib/recipe-parser.ts
git add apps/staff-admin/lib/recipe-constants.ts
git commit -m "feat: add csv parser with japanese encoding support"

# 7. Create second commit - Image management
git add apps/staff-admin/hooks/useImageManagement.ts
git add apps/staff-admin/lib/recipe-utils.ts
git commit -m "feat: add image upload and management functionality"

# 8. Create third commit - UI components
git add apps/staff-admin/app/recipe-generator/page.tsx
git add apps/staff-admin/lib/recipe-theme.ts
git commit -m "feat: implement recipe card generator ui"

# 9. Create fourth commit - Dependencies
git add package-lock.json apps/staff-admin/package.json
git commit -m "build: add genjyuu gothic font dependency"
```

## example commit messages

Simple feature:
```
feat: implement recipe generator functionality
```

With scope and body:
```
feat(staff-admin): add recipe card generator

Implement complete recipe card generation system including:
- CSV file parsing with encoding detection
- Image upload and matching
- Recipe card rendering
- A4 landscape format support
```

Complex changes:
```
feat(recipe-generator): implement full recipe card system

Add comprehensive recipe card generation functionality to staff-admin
- Parse CSV files with Japanese encoding support
- Handle multi-line fields in CSV data
- Upload and manage recipe images
- Match images to recipes by ID or name
- Generate A4 landscape recipe cards
- Add theme configuration for styling

This replaces the manual recipe card creation process
```

## warnings
- This rewrites history - do not use if commits have been pushed and shared
- Always verify the final state matches the original before force pushing
- Keep the backup branch until you're certain the rebuild was successful
- Each commit should represent a single logical change - avoid mixing purposes
- The commit granularity rule is CRITICAL - this is not about squashing everything into one commit, but organizing into meaningful minimal units
