# dotfiles

Personal development environment configuration files.

## Structure

```
dotfiles/
├── shell/          # Shell configuration files
│   ├── .zshrc      # Zsh configuration
│   ├── .bashrc     # Bash configuration
│   └── .zprofile   # Zsh profile
├── git/            # Git configuration
│   └── .gitconfig  # Git settings
├── vim/            # Vim configuration
│   └── .vimrc      # Vim settings
└── config/         # Application-specific configs
```

## Security

This repository has been sanitized to remove:
- API keys and credentials
- Personal email addresses and names (replaced with placeholders)
- Company-specific configurations
- Cloud project IDs
- History files

Before using these dotfiles:
1. Review all configuration files
2. Replace placeholder values with your own
3. Add any sensitive environment variables to `.envrc` (which is gitignored)

## Installation

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/kei9o/dotfiles.git ~/dotfiles

# Create symlinks for shell configs
ln -sf ~/dotfiles/shell/.zshrc ~/.zshrc
ln -sf ~/dotfiles/shell/.bashrc ~/.bashrc
ln -sf ~/dotfiles/shell/.zprofile ~/.zprofile

# Create symlinks for git config
ln -sf ~/dotfiles/git/.gitconfig ~/.gitconfig

# Create symlinks for vim config
ln -sf ~/dotfiles/vim/.vimrc ~/.vimrc
```

### Customization

After installation, customize these files:
- `git/.gitconfig`: Update `[user]` section with your name and email
- `shell/.zshrc` / `shell/.bashrc`:
  - Uncomment and configure cloud SDK paths
  - Add any company-specific profiles
  - Set environment variables for credentials

## Prerequisites

These dotfiles assume you have the following installed:
- Oh My Zsh (for zsh configuration)
- Powerlevel10k theme
- rbenv (Ruby version manager)
- direnv (environment variable manager)
- peco (interactive filtering tool)
- ghq (repository management)
- nvm (Node version manager)
- pnpm (Package manager)

## Notes

- The `.gitignore` file is configured to prevent committing sensitive data
- Always review changes before committing to ensure no secrets are leaked
- Use environment variables for sensitive configuration
