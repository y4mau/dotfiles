# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
# Source shared configuration
# =============================================================================
[ -f ~/.shellrc ] && . ~/.shellrc

# =============================================================================
# Prompt Configuration
# =============================================================================
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

# Set terminal title in PS1
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u: \w\a\]$PS1"
    ;;
esac

# =============================================================================
# Bash Completion
# =============================================================================
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

# =============================================================================
# Functions (bash-specific)
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

# markdown.mbt playground: open any markdown file in browser
# Requires: cd ~/ghq/github.com/y4mau/markdown.mbt && pnpm vite
function mdpreview () {
    local abs
    abs=$(realpath "$1" 2>/dev/null)
    if [[ -z "$abs" || ! -f "$abs" ]]; then
        echo "mdpreview: file not found: $1" >&2
        return 1
    fi
    local url="http://localhost:5173/?file=${abs}"
    if command -v xdg-open &>/dev/null; then
        xdg-open "$url"
    elif command -v cmd.exe &>/dev/null; then
        cmd.exe /c start "" "$url" 2>/dev/null
    else
        echo "$url"
    fi
}
