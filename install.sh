#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Shell configs
ln -sf "$DOTFILES_DIR/shell/.bashrc" ~/.bashrc
ln -sf "$DOTFILES_DIR/shell/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/shell/.zprofile" ~/.zprofile

# Git config
ln -sf "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig

# Vim config
ln -sf "$DOTFILES_DIR/vim/.vimrc" ~/.vimrc

# Claude Code config (optional - create dir if needed)
if [ -d "$DOTFILES_DIR/claude" ]; then
  mkdir -p ~/.claude
  ln -sf "$DOTFILES_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md
  ln -sf "$DOTFILES_DIR/claude/settings.json" ~/.claude/settings.json
  [ -f "$DOTFILES_DIR/claude/statusline-command.sh" ] && ln -sf "$DOTFILES_DIR/claude/statusline-command.sh" ~/.claude/statusline-command.sh
  [ -d "$DOTFILES_DIR/claude/agents" ] && ln -sf "$DOTFILES_DIR/claude/agents" ~/.claude/agents
  [ -d "$DOTFILES_DIR/claude/commands" ] && ln -sf "$DOTFILES_DIR/claude/commands" ~/.claude/commands
  [ -d "$DOTFILES_DIR/claude/hooks" ] && ln -sf "$DOTFILES_DIR/claude/hooks" ~/.claude/hooks
fi

echo "Dotfiles installed successfully!"
