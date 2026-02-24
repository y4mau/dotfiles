#!/bin/bash
set -euo pipefail

# -----------------------------------------------------------------------------
# bootstrap.sh - Bootstrap dotfiles on a clean WSL2/Ubuntu environment
#
# Installs prerequisites, clones the repo (if needed), and runs install.sh.
# Idempotent — safe to run multiple times.
# -----------------------------------------------------------------------------

DOTFILES_REPO="https://github.com/y4mau/dotfiles.git"
DOTFILES_DIR="$HOME/ghq/github.com/y4mau/dotfiles"

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

maybe_sudo() {
  if [[ $EUID -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

# -----------------------------------------------------------------------------
# Install prerequisites
# -----------------------------------------------------------------------------
install_prerequisites() {
  local packages=()

  has git   || packages+=(git)
  has curl  || packages+=(curl)
  has unzip || packages+=(unzip)

  if [[ ${#packages[@]} -eq 0 ]]; then
    info "All prerequisites already installed"
    return 0
  fi

  info "Installing prerequisites: ${packages[*]}"
  maybe_sudo apt-get update -qq
  maybe_sudo apt-get install -y "${packages[@]}"
}

# -----------------------------------------------------------------------------
# Install GitHub CLI
# -----------------------------------------------------------------------------
install_gh() {
  if has gh; then
    info "GitHub CLI is already installed"
    return 0
  fi

  info "Installing GitHub CLI..."
  local keyring="/usr/share/keyrings/githubcli-archive-keyring.gpg"
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | maybe_sudo dd of="$keyring" 2>/dev/null
  maybe_sudo chmod go+r "$keyring"
  echo "deb [arch=$(dpkg --print-architecture) signed-by=$keyring] https://cli.github.com/packages stable main" \
    | maybe_sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  maybe_sudo apt-get update -qq
  maybe_sudo apt-get install -y gh
}

# -----------------------------------------------------------------------------
# Authenticate with GitHub
# -----------------------------------------------------------------------------
ensure_gh_auth() {
  if gh auth status &>/dev/null; then
    info "Already authenticated with GitHub"
    return 0
  fi

  info "GitHub authentication required for private repo access"
  gh auth login
  gh auth setup-git
}

# -----------------------------------------------------------------------------
# Clone or update repository
# -----------------------------------------------------------------------------
setup_repo() {
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    info "Dotfiles repo already exists at $DOTFILES_DIR, pulling latest..."
    git -C "$DOTFILES_DIR" pull --ff-only || warn "Pull failed, continuing with existing version"
  else
    info "Cloning dotfiles repo to $DOTFILES_DIR..."
    mkdir -p "$(dirname "$DOTFILES_DIR")"
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
info "Starting dotfiles bootstrap..."

install_prerequisites
install_gh
ensure_gh_auth
setup_repo

info "Running install.sh..."
bash "$DOTFILES_DIR/install.sh"

info "Bootstrap complete!"
