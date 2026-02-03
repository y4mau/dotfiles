#!/bin/bash
# Git worktree jump with peco
# Usage: source ~/bin/git-worktree-jump.sh

cwd="$(pwd)"
selected=$(git worktree list 2>/dev/null | sed "s|^$cwd |./ |" | peco --query "$1" | awk '{print $1}')

if [[ -n "$selected" ]]; then
  if [[ "$selected" == "./" ]]; then
    cd "$cwd"
  else
    cd "$selected"
  fi
fi
