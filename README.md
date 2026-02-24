# dotfiles

Personal development environment configuration files.

## Supported Platforms

- **macOS** (Intel & Apple Silicon)
- **WSL2** (Windows Subsystem for Linux)
- **Linux** (Debian/Ubuntu)

Shell configurations auto-detect the platform and adjust behavior accordingly.

## Structure

```
dotfiles/
├── shell/              # Shell configuration files
│   ├── .shellrc        # Shared shell configuration (sourced by both)
│   ├── .bashrc         # Bash-specific configuration
│   ├── .zshrc          # Zsh-specific configuration
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
├── tmux/               # tmux configuration
│   └── .tmux.conf      # tmux settings
├── codex/              # OpenAI Codex CLI configuration
│   └── config.toml     # Codex settings and MCP servers
├── config/             # Application-specific configs
├── bootstrap.sh        # Bootstrap script for clean WSL2 setup
├── install.sh          # Setup script for Linux/macOS/WSL
└── install-windows.ps1 # Setup script for Windows (Claude Code symlinks)
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

### Quick Setup (Clean WSL2)

On a fresh WSL2 Ubuntu where only `apt` is available, run these commands **inside the WSL terminal** (not PowerShell):

```bash
sudo apt update
sudo apt install -y curl
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
sudo apt update
sudo apt install -y git gh
gh auth login
gh auth setup-git
git clone https://github.com/y4mau/dotfiles.git ~/ghq/github.com/y4mau/dotfiles
bash ~/ghq/github.com/y4mau/dotfiles/bootstrap.sh
```

> **Note:** `gh auth login` opens an interactive flow — choose HTTPS and authenticate via browser. This configures git credentials for the private repo.


### Linux / macOS / WSL

```bash
git clone https://github.com/y4mau/dotfiles.git ~/ghq/github.com/y4mau/dotfiles
bash ~/ghq/github.com/y4mau/dotfiles/install.sh
```

### Windows (PowerShell)

Sets up symlinks in `%USERPROFILE%\.claude\` pointing to the dotfiles repo on WSL.
Requires **Developer Mode** enabled or running as **Administrator**.

```powershell
\\wsl.localhost\Ubuntu-24.04\home\y4mau\ghq\github.com\y4mau\dotfiles\install-windows.ps1
```

> **Note:** WSL must be running for the symlinks to resolve.

### VS Code Devcontainers

Dotfiles are automatically installed when creating a devcontainer if you add the following to your VS Code settings:

```json
{
  "dotfiles.repository": "y4mau/dotfiles",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "install.sh"
}
```

### Customization

After installation, customize these files:
- `git/.gitconfig`: Update `[user]` section with your name and email
- `shell/.shellrc`: Shared config (aliases, PATH, env vars, tool integrations)
  - Uncomment and configure cloud SDK paths
  - Add any company-specific profiles
  - Set environment variables for credentials
- `claude/settings.local.json`: Create from `.example` and add local permissions

## Prerequisites

### Required

- **peco** - interactive filtering tool (for `Ctrl+]`, `gsp`, `cind`)
- **ghq** - repository management (for `Ctrl+]`)

### Optional (lazy-loaded if installed)

- **rbenv** - Ruby version manager
- **nvm** - Node version manager
- **direnv** - environment variable manager
- **gcloud** - Google Cloud SDK
- **pnpm** - Package manager

### For Zsh

- Oh My Zsh
- Powerlevel10k theme

### Other Tools

- terminal-notifier (macOS, for task completion notifications)
- jq (for JSON processing in scripts)
- wslu (WSL2, for `wslview` browser support)

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

## Shell Configuration

### Cross-Platform Features

The `.shellrc` uses platform detection (`IS_MACOS`, `IS_WSL`, `IS_LINUX`) to handle:

| Feature | macOS | WSL2/Linux |
|---------|-------|------------|
| Homebrew | `/opt/homebrew` or `/usr/local` | skipped |
| pnpm path | `~/Library/pnpm` | `~/.local/share/pnpm` |
| ls colors | `-G` + `CLICOLOR` | `dircolors` + `--color=auto` |
| Clipboard | `pbcopy` (native) | `clip.exe` / `powershell` |
| Browser | default | `wslview` |
| gcloud SDK | `~/Downloads/`, `~/`, Caskroom | `~/google-cloud-sdk` |
| Bash completion | `brew --prefix` | `/usr/share/bash-completion` |
| iTerm2 | shell integration | skipped |
| `cind` alias | `cursor` | `code` |

### Shell Aliases

| Alias | Command | Description |
|-------|---------|-------------|
| `es` / `exsh` | `exec $SHELL` | Reload shell |
| `gb` | `git branch` | List branches |
| `gs` | `git switch` | Switch branch |
| `gsp` | `git-switch-peco` | Switch branch with peco |
| `gp` | `git push` | Push to remote |
| `gpl` | `git pull` | Pull from remote |
| `ga` | `git add` | Stage files |
| `gc` | `git commit` | Commit changes |
| `gm` | `git merge` | Merge branch |
| `grom` | `git fetch && git rebase origin/master` | Rebase on master |
| `gwj` | git-worktree-jump | Jump to worktree with peco |
| `cb` | `claude --permission-mode bypassPermissions` | Claude Code bypass |
| `ccb` | `claude -c --permission-mode bypassPermissions` | Claude continue + bypass |
| `cind` | Open file with peco | Interactive file opener |
| `pbcopy` / `pbpaste` | Clipboard | Cross-platform clipboard |

### Key Bindings

| Key | Function |
|-----|----------|
| `Ctrl+]` | `peco-src` - ghq repository selector |

### Lazy Loading

For faster shell startup, these tools are lazy-loaded (initialized on first use):
- `rbenv`
- `direnv`
- `gcloud`

### Dotfiles Auto-Update

On each shell startup, a background process checks `origin/main` for updates and pulls them automatically (`--ff-only`). If updates were applied, the next shell session displays a notice with the updated commits.

### Local Customizations

Add machine-specific settings to `~/.bashrc.local` or `~/.zshrc.local` (not tracked in git):

```bash
# Example ~/.bashrc.local or ~/.zshrc.local
export GOOGLE_CLOUD_PROJECT="my-project-id"
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/credentials.json"
source ~/.company-profile
```

## Notes

- The `.gitignore` file is configured to prevent committing sensitive data
- Always review changes before committing to ensure no secrets are leaked
- Use environment variables for sensitive configuration
- Claude Code and Codex sensitive files (credentials, history, etc.) are gitignored
