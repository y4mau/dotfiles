#!/bin/bash
# ===========================================================================
# Dotfiles validation test suite
#
# Usage:
#   ./tests/validate.sh            # Run all tests
#   ./tests/validate.sh --quick    # Skip optional tools (shellcheck, etc.)
#   ./tests/validate.sh --verbose  # Show passed test details
# ===========================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PASS=0
FAIL=0
SKIP=0
VERBOSE=false
QUICK=false
ERRORS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --verbose) VERBOSE=true; shift ;;
    --quick)   QUICK=true; shift ;;
    *)         echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# ── Helpers ────────────────────────────────────────────────────────────────
pass() {
  ((PASS++))
  if $VERBOSE; then echo "  PASS  $1"; fi
}

fail() {
  ((FAIL++))
  ERRORS+=("$1")
  echo "  FAIL  $1"
}

skip() {
  ((SKIP++))
  echo "  SKIP  $1"
}

section() {
  echo
  echo "── $1 ──"
}

has() {
  command -v "$1" &>/dev/null
}

# ── 1. File existence ─────────────────────────────────────────────────────
section "File existence"

expected_files=(
  # Shell
  shell/.shellrc
  shell/.bashrc
  shell/.bash_profile
  shell/.zshrc
  shell/.zprofile
  shell/.dircolors
  # Fish
  fish/config.fish
  fish/conf.d/00-platform.fish
  fish/conf.d/01-path.fish
  fish/conf.d/02-env.fish
  fish/conf.d/03-colors.fish
  fish/conf.d/10-aliases.fish
  fish/conf.d/40-integrations.fish
  fish/conf.d/50-dotfiles-update.fish
  fish/functions/peco-src.fish
  fish/functions/copy.fish
  # Git
  git/.gitconfig
  # Vim
  vim/.vimrc
  # Tmux
  tmux/.tmux.conf
  # Starship
  starship/starship.toml
  # Claude
  claude/CLAUDE.md
  claude/settings.json
  # Codex
  codex/config.toml
  # Scripts
  install.sh
  bootstrap.sh
)

for f in "${expected_files[@]}"; do
  if [[ -f "$DOTFILES_DIR/$f" ]]; then
    pass "$f exists"
  else
    fail "$f is missing"
  fi
done

# ── 2. Non-empty files ────────────────────────────────────────────────────
section "Non-empty files"

for f in "${expected_files[@]}"; do
  filepath="$DOTFILES_DIR/$f"
  if [[ -f "$filepath" ]]; then
    if [[ -s "$filepath" ]]; then
      pass "$f is non-empty"
    else
      fail "$f is empty"
    fi
  fi
done

# ── 3. Bash/sh syntax ────────────────────────────────────────────────────
section "Bash syntax (bash -n)"

bash_files=(
  install.sh
  bootstrap.sh
  shell/.bashrc
  shell/.bash_profile
  shell/.zprofile
  bin/git-worktree-jump.sh
  tmux/scripts/paste-clipboard.sh
  tmux/scripts/paste-screenshot-path.sh
  claude/hooks/ai-principles-reminder.sh
  claude/hooks/thinking-mode-reminder.sh
  claude/statusline-command.sh
)

# shellrc is cross-shell (bash+zsh) and uses zsh-specific syntax (&!);
# bash -n will always fail on it, so we list it separately for reference
cross_shell_files=(
  shell/.shellrc
)

for f in "${bash_files[@]}"; do
  filepath="$DOTFILES_DIR/$f"
  if [[ -f "$filepath" ]]; then
    if errors=$(bash -n "$filepath" 2>&1); then
      pass "$f syntax OK"
    else
      fail "$f has bash syntax errors: $(echo "$errors" | head -1)"
    fi
  else
    skip "$f not found"
  fi
done

for f in "${cross_shell_files[@]}"; do
  filepath="$DOTFILES_DIR/$f"
  if [[ -f "$filepath" ]]; then
    # Cross-shell files may use zsh-specific syntax; check with zsh if available
    if has zsh; then
      if zsh -n "$filepath" 2>/dev/null; then
        pass "$f syntax OK (checked with zsh, cross-shell file)"
      else
        fail "$f has syntax errors in zsh"
      fi
    else
      skip "$f (cross-shell, needs zsh to validate)"
    fi
  fi
done

# ── 4. Zsh syntax ────────────────────────────────────────────────────────
section "Zsh syntax (zsh -n)"

zsh_files=(
  shell/.zshrc
)

if has zsh; then
  for f in "${zsh_files[@]}"; do
    filepath="$DOTFILES_DIR/$f"
    if [[ -f "$filepath" ]]; then
      if zsh -n "$filepath" 2>/dev/null; then
        pass "$f syntax OK"
      else
        fail "$f has zsh syntax errors"
      fi
    else
      skip "$f not found"
    fi
  done
else
  skip "zsh not available"
fi

# ── 5. Fish syntax ────────────────────────────────────────────────────────
section "Fish syntax (fish --no-execute)"

if has fish; then
  while IFS= read -r filepath; do
    rel="${filepath#"$DOTFILES_DIR/"}"
    if fish --no-execute "$filepath" 2>/dev/null; then
      pass "$rel syntax OK"
    else
      fail "$rel has fish syntax errors"
    fi
  done < <(find "$DOTFILES_DIR/fish" -name '*.fish' -type f)
else
  skip "fish not available"
fi

# ── 6. JSON validity ─────────────────────────────────────────────────────
section "JSON validity"

json_files=(
  claude/settings.json
)

for f in "${json_files[@]}"; do
  filepath="$DOTFILES_DIR/$f"
  if [[ -f "$filepath" ]]; then
    if python3 -c "import json; json.load(open('$filepath'))" 2>/dev/null; then
      pass "$f is valid JSON"
    else
      fail "$f is invalid JSON"
    fi
  else
    skip "$f not found"
  fi
done

# ── 7. TOML validity ─────────────────────────────────────────────────────
section "TOML validity"

toml_files=(
  starship/starship.toml
  codex/config.toml
)

can_check_toml=false
if python3 -c "import tomllib" 2>/dev/null || python3 -c "import tomli" 2>/dev/null; then
  can_check_toml=true
fi

for f in "${toml_files[@]}"; do
  filepath="$DOTFILES_DIR/$f"
  if [[ -f "$filepath" ]]; then
    if $can_check_toml; then
      if python3 -c "
import sys
try:
    import tomllib
except ImportError:
    import tomli as tomllib
with open('$filepath', 'rb') as fh:
    tomllib.load(fh)
" 2>/dev/null; then
        pass "$f is valid TOML"
      else
        fail "$f is invalid TOML"
      fi
    else
      skip "$f (no TOML parser available)"
    fi
  else
    skip "$f not found"
  fi
done

# ── 8. Git config validity ───────────────────────────────────────────────
section "Git config validity"

if has git; then
  gitconfig="$DOTFILES_DIR/git/.gitconfig"
  if [[ -f "$gitconfig" ]]; then
    if git config --file "$gitconfig" --list &>/dev/null; then
      pass "git/.gitconfig is parseable"
    else
      fail "git/.gitconfig is not parseable by git"
    fi
  fi
else
  skip "git not available"
fi

# ── 9. Shebang lines ─────────────────────────────────────────────────────
section "Shebang lines"

shebang_required=(
  install.sh
  bootstrap.sh
  bin/git-worktree-jump.sh
  tmux/scripts/paste-clipboard.sh
  tmux/scripts/paste-screenshot-path.sh
  claude/hooks/ai-principles-reminder.sh
  claude/hooks/thinking-mode-reminder.sh
)

for f in "${shebang_required[@]}"; do
  filepath="$DOTFILES_DIR/$f"
  if [[ -f "$filepath" ]]; then
    firstline=$(head -1 "$filepath")
    if [[ "$firstline" == "#!"* ]]; then
      pass "$f has shebang"
    else
      fail "$f missing shebang line"
    fi
  else
    skip "$f not found"
  fi
done

# ── 10. Script executability ─────────────────────────────────────────────
section "Script executability"

executable_scripts=(
  install.sh
  bootstrap.sh
  bin/git-worktree-jump.sh
  tmux/scripts/paste-clipboard.sh
  tmux/scripts/paste-screenshot-path.sh
  claude/hooks/ai-principles-reminder.sh
  claude/hooks/thinking-mode-reminder.sh
  claude/statusline-command.sh
)

for f in "${executable_scripts[@]}"; do
  filepath="$DOTFILES_DIR/$f"
  if [[ -f "$filepath" ]]; then
    if [[ -x "$filepath" ]]; then
      pass "$f is executable"
    else
      fail "$f is not executable (missing chmod +x)"
    fi
  else
    skip "$f not found"
  fi
done

# ── 11. Fish conf.d ordering ─────────────────────────────────────────────
section "Fish conf.d ordering"

if [[ -d "$DOTFILES_DIR/fish/conf.d" ]]; then
  prev_prefix=-1
  ordering_ok=true
  while IFS= read -r filepath; do
    filename="$(basename "$filepath")"
    # Extract numeric prefix
    if [[ "$filename" =~ ^([0-9]+)- ]]; then
      prefix="${BASH_REMATCH[1]}"
      # Remove leading zeros for numeric comparison
      prefix_num=$((10#$prefix))
      if [[ $prefix_num -lt $prev_prefix ]]; then
        fail "fish/conf.d ordering: $filename has prefix $prefix_num but previous was $prev_prefix"
        ordering_ok=false
      fi
      prev_prefix=$prefix_num
    else
      fail "fish/conf.d/$filename missing numeric prefix"
      ordering_ok=false
    fi
  done < <(find "$DOTFILES_DIR/fish/conf.d" -name '*.fish' -type f | sort)

  if $ordering_ok; then
    pass "fish/conf.d files have valid numeric ordering"
  fi
else
  skip "fish/conf.d directory not found"
fi

# ── 12. Fish function naming ─────────────────────────────────────────────
section "Fish function naming"

if [[ -d "$DOTFILES_DIR/fish/functions" ]]; then
  while IFS= read -r filepath; do
    filename="$(basename "$filepath" .fish)"
    # Fish requires function name to match filename
    if grep -q "^function $filename" "$filepath" 2>/dev/null; then
      pass "fish/functions/$filename.fish defines function '$filename'"
    else
      fail "fish/functions/$filename.fish does not define function '$filename'"
    fi
  done < <(find "$DOTFILES_DIR/fish/functions" -name '*.fish' -type f)
else
  skip "fish/functions directory not found"
fi

# ── 13. install.sh symlink sources exist ─────────────────────────────────
section "install.sh symlink sources"

# Files that exist only locally (not tracked in git) — expected to be absent
local_only_files=(
  "git/.gitconfig.local"
)

# Extract symlink source paths from install.sh (lines with ln -sf)
while IFS= read -r line; do
  # Match: ln -sf "$DOTFILES_DIR/some/path" target
  if [[ "$line" =~ \$DOTFILES_DIR/([^\"[:space:]]+) ]]; then
    rel="${BASH_REMATCH[1]}"
    # Skip patterns with variables or wildcards
    [[ "$rel" == *'$'* ]] && continue
    [[ "$rel" == *'*'* ]] && continue

    # Skip known local-only files
    is_local=false
    for lf in "${local_only_files[@]}"; do
      [[ "$rel" == "$lf" ]] && is_local=true && break
    done
    if $is_local; then
      pass "symlink source $rel (local-only, not tracked)"
      continue
    fi

    fullpath="$DOTFILES_DIR/$rel"
    if [[ -e "$fullpath" ]]; then
      pass "symlink source $rel exists"
    else
      fail "symlink source $rel referenced in install.sh does not exist"
    fi
  fi
done < <(grep 'ln -sf' "$DOTFILES_DIR/install.sh" 2>/dev/null)

# ── 14. No secrets in tracked files ──────────────────────────────────────
section "Security: no secrets in tracked files"

if has git; then
  secrets_found=false

  # Check tracked files for common secret patterns
  secret_patterns=(
    'AKIA[0-9A-Z]{16}'                    # AWS access key
    'sk-[a-zA-Z0-9]{20,}'                 # OpenAI/Stripe secret key
    'ghp_[a-zA-Z0-9]{36}'                 # GitHub personal access token
    'gho_[a-zA-Z0-9]{36}'                 # GitHub OAuth token
    'xoxb-[0-9]+-[0-9]+-[a-zA-Z0-9]+'    # Slack bot token
    'xoxp-[0-9]+-[0-9]+-[a-zA-Z0-9]+'    # Slack user token
    'sk-ant-[a-zA-Z0-9-]+'               # Anthropic API key
  )

  tracked_files=$(cd "$DOTFILES_DIR" && git ls-files 2>/dev/null)
  for pattern in "${secret_patterns[@]}"; do
    while IFS= read -r file; do
      [[ -z "$file" ]] && continue
      filepath="$DOTFILES_DIR/$file"
      [[ -f "$filepath" ]] || continue
      # Skip test file itself and binary files
      [[ "$file" == tests/* ]] && continue
      if grep -qE "$pattern" "$filepath" 2>/dev/null; then
        fail "Possible secret ($pattern) found in $file"
        secrets_found=true
      fi
    done <<< "$tracked_files"
  done

  if ! $secrets_found; then
    pass "No secrets detected in tracked files"
  fi
else
  skip "git not available"
fi

# ── 15. .gitignore covers sensitive paths ────────────────────────────────
section "Security: .gitignore coverage"

gitignore="$DOTFILES_DIR/.gitignore"
if [[ -f "$gitignore" ]]; then
  required_ignores=(
    '*.key'
    '*.pem'
    '*.env'
    '.ssh/'
    '.aws/'
    'claude/settings.local.json'
  )

  for pattern in "${required_ignores[@]}"; do
    if grep -qF "$pattern" "$gitignore"; then
      pass ".gitignore contains $pattern"
    else
      fail ".gitignore missing $pattern"
    fi
  done
else
  fail ".gitignore not found"
fi

# ── 16. ShellCheck (optional) ────────────────────────────────────────────
section "ShellCheck lint"

if $QUICK; then
  skip "shellcheck (--quick mode)"
elif has shellcheck; then
  for f in "${bash_files[@]}"; do
    filepath="$DOTFILES_DIR/$f"
    if [[ -f "$filepath" ]]; then
      # SC1090: Can't follow sourced files
      # SC1091: Not following sourced files
      # SC2034: Variable appears unused (common in dotfiles)
      if shellcheck -e SC1090,SC1091,SC2034 -s bash "$filepath" 2>/dev/null; then
        pass "$f shellcheck clean"
      else
        fail "$f has shellcheck warnings"
      fi
    fi
  done
else
  skip "shellcheck not installed (brew install shellcheck)"
fi

# ── 17. Tmux config validity ────────────────────────────────────────────
section "Tmux config validity"

tmux_conf="$DOTFILES_DIR/tmux/.tmux.conf"
if [[ -f "$tmux_conf" ]]; then
  # Basic structural check: no unclosed quotes, valid set/bind commands
  if grep -cE '^\s*(set|set-option|bind|bind-key|unbind|source)' "$tmux_conf" &>/dev/null; then
    pass "tmux/.tmux.conf contains valid tmux directives"
  else
    fail "tmux/.tmux.conf may be malformed (no recognizable directives)"
  fi
else
  skip "tmux/.tmux.conf not found"
fi

# ── 18. Vim config validity ──────────────────────────────────────────────
section "Vim config validity"

vimrc="$DOTFILES_DIR/vim/.vimrc"
if [[ -f "$vimrc" ]]; then
  # Check for basic vim directives
  if grep -cE '^\s*(set |let |call |syntax |filetype |Plug )' "$vimrc" &>/dev/null; then
    pass "vim/.vimrc contains valid vim directives"
  else
    fail "vim/.vimrc may be malformed (no recognizable directives)"
  fi
else
  skip "vim/.vimrc not found"
fi

# ── 19. No trailing whitespace in configs ────────────────────────────────
section "Trailing whitespace"

config_extensions=("*.fish" "*.sh" "*.toml" "*.json" "*.conf")
trailing_ws_found=false

for ext in "${config_extensions[@]}"; do
  while IFS= read -r filepath; do
    [[ -z "$filepath" ]] && continue
    rel="${filepath#"$DOTFILES_DIR/"}"
    # Skip test files
    [[ "$rel" == tests/* ]] && continue
    if grep -qP '\S\s+$' "$filepath" 2>/dev/null; then
      fail "$rel has trailing whitespace"
      trailing_ws_found=true
    fi
  done < <(find "$DOTFILES_DIR" -name "$ext" -not -path '*/\.*' -type f 2>/dev/null)
done

if ! $trailing_ws_found; then
  pass "No trailing whitespace in config files"
fi

# ── 20. Starship config has required modules ─────────────────────────────
section "Starship config modules"

starship_conf="$DOTFILES_DIR/starship/starship.toml"
if [[ -f "$starship_conf" ]]; then
  required_modules=(character directory git_branch git_status)
  for mod in "${required_modules[@]}"; do
    if grep -q "^\[$mod\]" "$starship_conf"; then
      pass "starship.toml has [$mod] module"
    else
      fail "starship.toml missing [$mod] module"
    fi
  done
else
  skip "starship.toml not found"
fi

# ── Summary ───────────────────────────────────────────────────────────────
echo
echo "════════════════════════════════════════"
echo "  PASS: $PASS  |  FAIL: $FAIL  |  SKIP: $SKIP"
echo "════════════════════════════════════════"

if [[ ${#ERRORS[@]} -gt 0 ]]; then
  echo
  echo "Failures:"
  for err in "${ERRORS[@]}"; do
    echo "  - $err"
  done
fi

echo
exit "$FAIL"
