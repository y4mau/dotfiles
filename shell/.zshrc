# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# Platform Detection
# =============================================================================
IS_MACOS=false
IS_WSL=false
IS_LINUX=false

if [[ "$OSTYPE" == "darwin"* ]]; then
  IS_MACOS=true
elif grep -qi microsoft /proc/version 2>/dev/null; then
  IS_WSL=true
  IS_LINUX=true
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  IS_LINUX=true
fi

# =============================================================================
# Dotfiles Auto-Update
# =============================================================================
_DOTFILES_DIR="$HOME/ghq/github.com/y4mau/dotfiles"
_DOTFILES_UPDATED_MARKER="$HOME/.dotfiles_updated"

# Show notice if dotfiles were updated in a previous session
if [[ -f "$_DOTFILES_UPDATED_MARKER" ]]; then
    echo "[dotfiles] Updated to latest origin/main: $(cat "$_DOTFILES_UPDATED_MARKER")"
    rm -f "$_DOTFILES_UPDATED_MARKER"
fi

# Background check for dotfiles updates
(
    if [[ -d "$_DOTFILES_DIR/.git" ]]; then
        git -C "$_DOTFILES_DIR" fetch origin main --quiet 2>/dev/null
        local_head=$(git -C "$_DOTFILES_DIR" rev-parse HEAD 2>/dev/null)
        remote_head=$(git -C "$_DOTFILES_DIR" rev-parse origin/main 2>/dev/null)
        if [[ -n "$local_head" && -n "$remote_head" && "$local_head" != "$remote_head" ]]; then
            git -C "$_DOTFILES_DIR" pull --ff-only origin main --quiet 2>/dev/null
            if [[ $? -eq 0 ]]; then
                git -C "$_DOTFILES_DIR" log --oneline "${local_head}..HEAD" 2>/dev/null > "$_DOTFILES_UPDATED_MARKER"
            fi
        fi
    fi
) &!

# =============================================================================
# History Configuration
# =============================================================================
HISTSIZE=1000
SAVEHIST=2000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt APPEND_HISTORY

# =============================================================================
# Shell Options
# =============================================================================
bindkey -v  # Enable vi mode

# =============================================================================
# PATH Configuration
# =============================================================================
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

# Homebrew (macOS)
if $IS_MACOS; then
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# npm global bin (if exists)
if command -v npm &> /dev/null; then
  export PATH="$(npm config get prefix)/bin:$PATH"
fi

# Lazy load rbenv (faster shell startup)
export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
rbenv() {
  unset -f rbenv
  eval "$(command rbenv init -)"
  rbenv "$@"
}

# nvm (if installed)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pnpm (platform-aware)
if $IS_MACOS; then
  export PNPM_HOME="$HOME/Library/pnpm"
else
  export PNPM_HOME="$HOME/.local/share/pnpm"
fi
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# =============================================================================
# Environment Variables
# =============================================================================
export EDITOR=vim
export LESS='-R'

# Browser (WSL2 uses wslview to open in Windows)
if $IS_WSL; then
  export BROWSER=wslview
fi

# =============================================================================
# Color Support
# =============================================================================
if $IS_LINUX && [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
elif $IS_MACOS; then
  export CLICOLOR=1
  export LSCOLORS=GxFxCxDxBxegedabagaced
  alias ls='ls -G'
fi

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# =============================================================================
# Aliases
# =============================================================================
# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Shell
alias exsh='exec $SHELL'
alias es='exec $SHELL'

# Git aliases
alias gb='git branch'
alias gs='git switch'
alias gsp='git-switch-peco'
alias gp='git push'
alias gpl='git pull'
alias gst='git status'
alias ga='git add'
alias gc='git commit'
alias gm='git merge'
alias grom='git fetch && git rebase origin/master'
alias gsh='git_branch_history.sh'

# Git worktree jump with peco
alias gwj='source ~/bin/git-worktree-jump.sh'

# Tools
alias bers="bundle exec rspec"
alias pex='pet exec'
alias ped='pet edit'

# Claude Code aliases
alias cb="claude --permission-mode bypassPermissions"
alias ccb="claude -c --permission-mode bypassPermissions"

# Gemini CLI
alias gemini='npx https://github.com/google-gemini/gemini-cli'

# GCloud aliases (gca instead of ga to avoid conflict with git add)
alias gca='gcloud auth list --format="value(account)" | peco | xargs -I {} gcloud config set account {}'
alias gpr='gcloud projects list --format="value(project_id)" | peco | xargs -I {} gcloud config set project {}'

# AWS aliases
alias apr='export AWS_PROFILE=$(aws configure list-profiles | peco --prompt "AWS Profile > ")'

# Kubectl aliases
alias ka='kubectl config get-contexts -o name | peco | xargs -I {} kubectl config use-context {}'
alias k='kubectl'

# Devcontainer aliases
alias dewf='devcontainer exec --workspace-folder .'

# Open file with editor using peco
if command -v peco &> /dev/null; then
  if $IS_MACOS && command -v cursor &> /dev/null; then
    alias cind='cursor "$(find . -type f | peco)"'
  elif command -v code &> /dev/null; then
    alias cind='code "$(find . -type f | peco)"'
  else
    alias vind='vim "$(find . -type f | peco)"'
  fi
fi

# Clipboard (platform-aware)
if $IS_MACOS; then
  # macOS has pbcopy/pbpaste built-in
  :
elif $IS_WSL; then
  alias pbcopy='clip.exe'
  alias pbpaste='powershell.exe -command "Get-Clipboard" | tr -d "\r"'
elif command -v xclip &> /dev/null; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

# =============================================================================
# Git Alias Completions (zsh)
# =============================================================================
compdef _git gb=git-branch
compdef _git gs=git-switch
compdef _git gp=git-push
compdef _git gst=git-status
compdef _git gpl=git-pull
compdef _git ga=git-add
compdef _git gc=git-commit
compdef _git gm=git-merge

# =============================================================================
# Functions
# =============================================================================

# ghq + fzf/peco repository selector (Ctrl+])
function peco-src () {
  local selected_dir
  if command -v fzf &> /dev/null; then
    if [[ -n "$TMUX" ]]; then
      selected_dir=$(ghq list -p | fzf --tmux 80%,60% --query "$LBUFFER")
    else
      selected_dir=$(ghq list -p | fzf --query "$LBUFFER")
    fi
  else
    selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  fi
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  else
    zle reset-prompt
  fi
}
if (command -v fzf &> /dev/null || command -v peco &> /dev/null) && command -v ghq &> /dev/null; then
  zle -N peco-src
  bindkey '^]' peco-src
fi

# git switch with peco
function git-switch-peco() {
  local branch
  branch=$(git branch --all | grep -v '\->' | peco | sed 's/.* //')
  if [ -n "$branch" ]; then
    git switch "$branch"
  fi
}

# Get credentials for all GKE clusters
function get-gke-cluster-credentials {
  clusters=$(gcloud container clusters list --format="value(name, location)")
  echo "$clusters" | while read -r line; do
    if [[ -n "$line" ]]; then
      cluster_name=$(echo $line | awk '{print $1}')
      cluster_location=$(echo $line | awk '{print $2}')

      command="gcloud container clusters get-credentials $cluster_name --region $cluster_location"
      echo "Running command: $command"
      eval $command
    fi
  done
}

# Get credentials for all EKS clusters across all enabled regions
function get-eks-cluster-credentials {
  local regions=$(aws ec2 describe-regions --query 'Regions[*].RegionName' --output text 2>/dev/null)

  for region in ${=regions}; do
    clusters=$(aws eks list-clusters --region "$region" --output text --query 'clusters[*]' 2>/dev/null)

    if [[ -z "$clusters" ]]; then
      continue
    fi

    echo "Found EKS clusters in region: $region"
    for cluster in ${=clusters}; do
      if [[ -n "$cluster" ]]; then
        command="aws eks update-kubeconfig --name $cluster --region $region"
        echo "  Running: $command"
        eval $command
      fi
    done
  done
}

# Real-time clock in YYYY-MM-DD format
function clock() {
  trap 'tput cnorm; printf "\n"; trap - INT' INT
  (
    while true; do
      tput civis
      printf "\r$(LC_TIME=en_US.UTF-8 date '+%Y-%m-%d %H:%M:%S %a %Z')"
      sleep 1
    done
  )
}

# =============================================================================
# Tool Integrations (Lazy Loading)
# =============================================================================

# Lazy load direnv (faster shell startup)
direnv() {
  unset -f direnv
  eval "$(command direnv hook zsh)"
  direnv "$@"
}

# Lazy load Google Cloud SDK
gcloud() {
  local sdk_path=""
  if $IS_MACOS; then
    for path in "$HOME/Downloads/google-cloud-sdk" "$HOME/google-cloud-sdk" "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"; do
      if [ -d "$path" ]; then
        sdk_path="$path"
        break
      fi
    done
  else
    sdk_path="$HOME/google-cloud-sdk"
  fi

  if [ -n "$sdk_path" ]; then
    [ -f "$sdk_path/path.zsh.inc" ] && source "$sdk_path/path.zsh.inc"
    [ -f "$sdk_path/completion.zsh.inc" ] && source "$sdk_path/completion.zsh.inc"
  fi
  unset -f gcloud
  gcloud "$@"
}

# VSCode shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && [ -x "$(command -v code)" ] && . "$(code --locate-shell-integration-path zsh)"

# iTerm2 shell integration (macOS)
if $IS_MACOS; then
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi

# Kiro shell integration
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# =============================================================================
# Terminal Title (optimized with caching)
# =============================================================================
_last_pwd=""
_cached_git_branch=""

function update_terminal_title() {
  if [[ "$PWD" != "$_last_pwd" ]]; then
    _last_pwd="$PWD"
    local directory=${PWD##*/}
    _cached_git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [[ -n "$_cached_git_branch" ]]; then
      echo -ne "\033]0;${directory} (${_cached_git_branch})\007"
    else
      echo -ne "\033]0;${directory}\007"
    fi
  fi
}
precmd_functions+=(update_terminal_title)

# Load local customizations (not tracked in git)
[ -f ~/.zshrc.local ] && . ~/.zshrc.local

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
