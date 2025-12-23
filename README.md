# dotfiles

Personal development environment configuration files.

## Structure

```
dotfiles/
├── shell/              # Shell configuration files
│   ├── .zshrc          # Zsh configuration
│   ├── .bashrc         # Bash configuration
│   └── .zprofile       # Zsh profile
├── git/                # Git configuration
│   └── .gitconfig      # Git settings
├── vim/                # Vim configuration
│   └── .vimrc          # Vim settings
├── claude/             # Claude Code CLI configuration
│   ├── CLAUDE.md       # Workflow guidelines and instructions
│   ├── settings.json   # Claude Code settings
│   ├── statusline-command.sh  # Custom status line script
│   ├── agents/         # Custom subagents
│   ├── commands/       # Custom slash commands
│   └── hooks/          # Pre/post execution hooks
├── codex/              # OpenAI Codex CLI configuration
│   └── config.toml     # Codex settings and MCP servers
└── config/             # Application-specific configs
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

# Create symlinks for Claude Code config
mkdir -p ~/.claude
ln -sf ~/dotfiles/claude/CLAUDE.md ~/.claude/CLAUDE.md
ln -sf ~/dotfiles/claude/settings.json ~/.claude/settings.json
ln -sf ~/dotfiles/claude/statusline-command.sh ~/.claude/statusline-command.sh
ln -sf ~/dotfiles/claude/agents ~/.claude/agents
ln -sf ~/dotfiles/claude/commands ~/.claude/commands
ln -sf ~/dotfiles/claude/hooks ~/.claude/hooks

# Create symlinks for Codex CLI config
mkdir -p ~/.codex
ln -sf ~/dotfiles/codex/config.toml ~/.codex/config.toml
```

### Customization

After installation, customize these files:
- `git/.gitconfig`: Update `[user]` section with your name and email
- `shell/.zshrc` / `shell/.bashrc`:
  - Uncomment and configure cloud SDK paths
  - Add any company-specific profiles
  - Set environment variables for credentials
- `claude/settings.local.json`: Create from `.example` and add local permissions

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
- terminal-notifier (for task completion notifications)
- jq (for JSON processing in scripts)

### For Claude Code

- [Claude Code CLI](https://claude.ai/claude-code)
- ccusage (optional, for token usage tracking)

### For Codex CLI

- [OpenAI Codex CLI](https://github.com/openai/codex)
- MCP servers (chrome-devtools, figma, github)

## Claude Code Configuration

### Custom Subagents

| Agent | Description |
|-------|-------------|
| `google-sheets-reader` | Read data from Google Sheets with multiple auth methods |
| `pr-review-implementer` | Address PR review comments systematically |
| `issue-sync-updater` | Update GitHub issues with implementation status |
| `tdd-test-designer` | Design tests following TDD methodology |
| `requirements-generator-v5` | Generate comprehensive requirement documents |

### Custom Commands

| Command | Description |
|---------|-------------|
| `/commit` | Git commit following Conventional Commits v1.0.0 |
| `/rebuild_commit_tree` | Reorganize commits into meaningful units |
| `/daily-report` | Generate daily work report |

### Hooks

| Hook | Description |
|------|-------------|
| `ai-principles-reminder.sh` | Enforce AI operation principles |
| `thinking-mode-reminder.sh` | Auto-declare thinking mode based on context |

## Notes

- The `.gitignore` file is configured to prevent committing sensitive data
- Always review changes before committing to ensure no secrets are leaked
- Use environment variables for sensitive configuration
- Claude Code and Codex sensitive files (credentials, history, etc.) are gitignored
