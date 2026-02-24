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
# Source shared configuration
# =============================================================================
[ -f ~/.shellrc ] && . ~/.shellrc

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
# Functions (zsh-specific)
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

# Kiro terminal integration
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
