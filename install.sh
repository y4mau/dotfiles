#!/bin/bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
LOCAL_BIN="$HOME/.local/bin"

# -----------------------------------------------------------------------------
# Argument parsing
# -----------------------------------------------------------------------------
INSTALL_PACKAGES=true

while [[ $# -gt 0 ]]; do
  case "$1" in
    --no-packages)
      INSTALL_PACKAGES=false
      shift
      ;;
    *)
      echo "Unknown option: $1" >&2
      echo "Usage: $0 [--no-packages]" >&2
      exit 1
      ;;
  esac
done

# -----------------------------------------------------------------------------
# Platform & architecture detection
# -----------------------------------------------------------------------------
OS="$(uname -s)"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64)  ARCH_NORMALIZED="amd64" ;;
  aarch64) ARCH_NORMALIZED="arm64" ;;
  arm64)   ARCH_NORMALIZED="arm64" ;;
  *)       ARCH_NORMALIZED="$ARCH" ;;
esac

case "$OS" in
  Darwin) OS_NORMALIZED="darwin" ;;
  Linux)  OS_NORMALIZED="linux" ;;
  *)      OS_NORMALIZED="$(echo "$OS" | tr '[:upper:]' '[:lower:]')" ;;
esac

# -----------------------------------------------------------------------------
# Helper functions
# -----------------------------------------------------------------------------
info() {
  echo "[INFO] $*"
}

warn() {
  echo "[WARN] $*" >&2
}

has() {
  command -v "$1" &>/dev/null
}

# Run command with sudo if not root
maybe_sudo() {
  if [[ $EUID -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

# Install binary from GitHub release
# Usage: install_github_release <owner/repo> <binary_name> <asset_pattern>
# asset_pattern uses {os} and {arch} as placeholders
install_github_release() {
  local repo="$1"
  local binary="$2"
  local pattern="$3"

  if has "$binary"; then
    info "$binary is already installed"
    return 0
  fi

  info "Installing $binary from GitHub ($repo)..."

  local tmpdir
  tmpdir="$(mktemp -d)"
  trap "rm -rf '$tmpdir'" RETURN

  # Get latest release tag
  local tag
  tag=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | grep '"tag_name"' | cut -d'"' -f4)
  if [[ -z "$tag" ]]; then
    warn "Failed to get latest release for $repo"
    return 1
  fi

  # Build asset URL
  local version="${tag#v}"
  local asset
  asset=$(echo "$pattern" | sed "s/{os}/$OS_NORMALIZED/g; s/{arch}/$ARCH_NORMALIZED/g; s/{version}/$version/g; s/{tag}/$tag/g")
  local url="https://github.com/$repo/releases/download/$tag/$asset"

  info "Downloading $url"

  # Download and extract
  local archive="$tmpdir/$asset"
  if ! curl -fsSL -o "$archive" "$url"; then
    warn "Failed to download $url"
    return 1
  fi

  cd "$tmpdir"
  case "$asset" in
    *.tar.gz|*.tgz)
      tar -xzf "$archive"
      ;;
    *.zip)
      unzip -q "$archive"
      ;;
    *)
      warn "Unknown archive format: $asset"
      return 1
      ;;
  esac

  # Find and install binary
  local found_binary
  found_binary=$(find "$tmpdir" -type f -name "$binary" | head -1)
  if [[ -z "$found_binary" ]]; then
    warn "Binary $binary not found in archive"
    return 1
  fi

  mkdir -p "$LOCAL_BIN"
  cp "$found_binary" "$LOCAL_BIN/$binary"
  chmod +x "$LOCAL_BIN/$binary"

  info "$binary installed to $LOCAL_BIN/$binary"
}

# -----------------------------------------------------------------------------
# Package installation
# -----------------------------------------------------------------------------
install_packages() {
  info "Installing packages..."

  # Ensure ~/.local/bin exists and is on PATH for this session
  mkdir -p "$LOCAL_BIN"
  export PATH="$LOCAL_BIN:$PATH"

  # -------------------------------------------------------------------------
  # Platform-specific packages
  # -------------------------------------------------------------------------
  if [[ "$OS" == "Darwin" ]]; then
    # macOS: use Homebrew
    if has brew; then
      local brew_packages=()
      has peco   || brew_packages+=(peco)
      has ghq    || brew_packages+=(ghq)
      has direnv || brew_packages+=(direnv)

      if [[ ${#brew_packages[@]} -gt 0 ]]; then
        info "Installing via Homebrew: ${brew_packages[*]}"
        brew install "${brew_packages[@]}" || warn "Some Homebrew packages failed to install"
      else
        info "All Homebrew packages already installed"
      fi
    else
      warn "Homebrew not found. Please install it first: https://brew.sh"
    fi

  elif [[ "$OS" == "Linux" ]]; then
    # Linux: use apt for direnv, GitHub releases for peco/ghq
    if has apt-get; then
      if ! has direnv; then
        info "Installing direnv via apt..."
        maybe_sudo apt-get update -qq
        maybe_sudo apt-get install -y direnv || warn "Failed to install direnv"
      else
        info "direnv is already installed"
      fi
    else
      warn "apt-get not found, skipping direnv installation"
    fi

    # peco from GitHub releases
    install_github_release "peco/peco" "peco" "peco_{os}_{arch}.tar.gz" || true

    # ghq from GitHub releases
    install_github_release "x-motemen/ghq" "ghq" "ghq_{os}_{arch}.zip" || true
  fi

  # -------------------------------------------------------------------------
  # npm packages (cross-platform)
  # -------------------------------------------------------------------------
  if has npm; then
    # claude-code
    if ! has claude; then
      info "Installing @anthropic-ai/claude-code via npm..."
      npm install -g @anthropic-ai/claude-code || warn "Failed to install claude-code"
    else
      info "claude is already installed"
    fi

    # codex
    if ! has codex; then
      info "Installing @openai/codex via npm..."
      npm install -g @openai/codex || warn "Failed to install codex"
    else
      info "codex is already installed"
    fi
  else
    warn "npm not found, skipping npm packages (claude-code, codex)"
  fi

  info "Package installation complete"
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
if [[ "$INSTALL_PACKAGES" == "true" ]]; then
  install_packages
fi

# -----------------------------------------------------------------------------
# Symlink setup
# -----------------------------------------------------------------------------
info "Setting up symlinks..."

# Shell configs
ln -sf "$DOTFILES_DIR/shell/.shellrc" ~/.shellrc
ln -sf "$DOTFILES_DIR/shell/.bashrc" ~/.bashrc
ln -sf "$DOTFILES_DIR/shell/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/shell/.zprofile" ~/.zprofile

# Git config
ln -sf "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig
if [ ! -f /.dockerenv ]; then
  ln -sf "$DOTFILES_DIR/git/.gitconfig.local" ~/.gitconfig.local
fi

# Vim config
ln -sf "$DOTFILES_DIR/vim/.vimrc" ~/.vimrc

# Tmux config
ln -sf "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

# Claude Code config (optional - create dir if needed)
if [ -d "$DOTFILES_DIR/claude" ]; then
  mkdir -p ~/.claude
  ln -sf "$DOTFILES_DIR/claude/CLAUDE.md" ~/.claude/CLAUDE.md
  ln -sf "$DOTFILES_DIR/claude/settings.json" ~/.claude/settings.json
  [ -f "$DOTFILES_DIR/claude/statusline-command.sh" ] && ln -sf "$DOTFILES_DIR/claude/statusline-command.sh" ~/.claude/statusline-command.sh
  [ -d "$DOTFILES_DIR/claude/agents" ] && ln -sfn "$DOTFILES_DIR/claude/agents" ~/.claude/agents
  [ -d "$DOTFILES_DIR/claude/commands" ] && ln -sfn "$DOTFILES_DIR/claude/commands" ~/.claude/commands
  [ -d "$DOTFILES_DIR/claude/hooks" ] && ln -sfn "$DOTFILES_DIR/claude/hooks" ~/.claude/hooks
fi

# Custom bin scripts
if [ -d "$DOTFILES_DIR/bin" ]; then
  mkdir -p ~/bin
  for script in "$DOTFILES_DIR/bin"/*; do
    [ -f "$script" ] && ln -sf "$script" ~/bin/
  done
fi

echo "Dotfiles installed successfully!"
