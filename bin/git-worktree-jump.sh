#!/bin/bash
# Git worktree jump with peco
# Usage: source ~/bin/git-worktree-jump.sh

selected=$(git worktree list 2>/dev/null | peco --query "$1" | awk '{print $1}')

if [[ -n "$selected" ]]; then
  cd "$selected"
fi
