# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
# History Configuration
# =============================================================================
HISTCONTROL=ignoreboth:erasedups
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# =============================================================================
# Shell Options
# =============================================================================
shopt -s checkwinsize  # Check window size after each command
set -o vi  # Enable vi mode

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
# Prompt Configuration
# =============================================================================
# make less more friendly for non-text input files (Linux only)
if $IS_LINUX && [ -x /usr/bin/lesspipe ]; then
    eval "$(SHELL=/bin/sh lesspipe)"
fi

# set variable identifying the chroot you work in (Debian/Ubuntu)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Git status for prompt
function __git_ps1_branch() {
    local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ -z "$branch" ]] && return

    local status=""

    # Modified files
    git diff --quiet 2>/dev/null || status+="*"

    # Staged files
    git diff --cached --quiet 2>/dev/null || status+="+"

    # Untracked files
    [[ -n $(git ls-files --others --exclude-standard 2>/dev/null | head -1) ]] && status+="?"

    # Ahead/behind upstream
    local counts=$(git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null)
    if [[ -n "$counts" ]]; then
        local behind=${counts%%	*}
        local ahead=${counts##*	}
        [[ $ahead -gt 0 ]] && status+="↑$ahead"
        [[ $behind -gt 0 ]] && status+="↓$behind"
    fi

    # Stash
    [[ -n $(git stash list 2>/dev/null | head -1) ]] && status+="$"

    echo " ($branch$status)"
}

# Colored prompt
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    # One Half Dark: green=#98c379, blue=#61afef, yellow=#e5c07b
    if [[ "${COLORTERM:-}" =~ ^(truecolor|24bit)$ ]]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[38;2;152;195;121m\]\u\[\033[00m\]: \[\033[38;2;97;175;239m\]\w\[\033[38;2;229;192;123m\]$(__git_ps1_branch)\[\033[00m\] \$ '
    else
        # 256-color fallback: green=150, blue=75, yellow=180
        PS1='${debian_chroot:+($debian_chroot)}\[\033[38;5;150m\]\u\[\033[00m\]: \[\033[38;5;75m\]\w\[\033[38;5;180m\]$(__git_ps1_branch)\[\033[00m\] \$ '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u: \w$(__git_ps1_branch) \$ '
fi
unset color_prompt

# Set terminal title
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u: \w\a\]$PS1"
    ;;
esac

# =============================================================================
# Color Support
# =============================================================================
if $IS_LINUX && [ -x /usr/bin/dircolors ]; then
    # Linux: use dircolors
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
elif $IS_MACOS; then
    # macOS: use -G flag for color
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
# Functions
# =============================================================================

# ghq + peco repository selector (Ctrl+])
function peco-src () {
    local selected_dir=$(ghq list -p | peco --query "$READLINE_LINE")
    if [ -n "$selected_dir" ]; then
        READLINE_LINE=""
        history -s "cd ${selected_dir}"
        cd "$selected_dir"
        stty sane
        clear
        exec $SHELL
    fi
    READLINE_LINE=""
    clear
}
if command -v peco &> /dev/null && command -v ghq &> /dev/null; then
    bind -x '"\C-]": peco-src'
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

    for region in $regions; do
        clusters=$(aws eks list-clusters --region "$region" --output text --query 'clusters[*]' 2>/dev/null)

        if [[ -z "$clusters" ]]; then
            continue
        fi

        echo "Found EKS clusters in region: $region"
        for cluster in $clusters; do
            if [[ -n "$cluster" ]]; then
                command="aws eks update-kubeconfig --name $cluster --region $region"
                echo "  Running: $command"
                eval $command
            fi
        done
    done
}

# Copy stdin to Windows clipboard (UTF-8 → UTF-16LE for clip.exe)
if $IS_WSL; then
    function copy() {
        iconv -f UTF-8 -t UTF-16LE | clip.exe
    }
fi

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
    eval "$(command direnv hook bash)"
    direnv "$@"
}

# Lazy load Google Cloud SDK
gcloud() {
    local sdk_path=""
    if $IS_MACOS; then
        # Common macOS locations
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
        [ -f "$sdk_path/path.bash.inc" ] && source "$sdk_path/path.bash.inc"
        [ -f "$sdk_path/completion.bash.inc" ] && source "$sdk_path/completion.bash.inc"
    fi
    unset -f gcloud
    gcloud "$@"
}

# Bash completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    elif $IS_MACOS && [ -f "$(brew --prefix 2>/dev/null)/etc/bash_completion" ]; then
        . "$(brew --prefix)/etc/bash_completion"
    fi
fi

# Git alias completions
if [ -f /usr/share/bash-completion/completions/git ]; then
    source /usr/share/bash-completion/completions/git
    __git_complete gb _git_branch
    __git_complete gs _git_switch
    __git_complete gst _git_status
    __git_complete gp _git_push
    __git_complete gpl _git_pull
    __git_complete ga _git_add
    __git_complete gc _git_commit
    __git_complete gm _git_merge
fi

# VSCode shell integration
[[ "$TERM_PROGRAM" == "vscode" ]] && [ -x "$(command -v code)" ] && . "$(code --locate-shell-integration-path bash)"

# iTerm2 shell integration (macOS)
if $IS_MACOS; then
    test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

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
PROMPT_COMMAND="update_terminal_title"

# Load local customizations (not tracked in git)
[ -f ~/.bashrc.local ] && . ~/.bashrc.local

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
