# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="agnoster"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Lazy load rbenv
export PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
rbenv() {
  unset -f rbenv
  eval "$(command rbenv init -)"
  rbenv "$@"
}

# NOTE: Source company-specific profile if exists
# source ~/.tok2/profile

# set ghq & peco shortcut as '^]'
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle clear-screen
}
zle -N peco-src
bindkey '^]' peco-src

# NOTE: Company-specific AWS functions removed for security
# 複数インスタンスログイン
# function toku-ec2-start-multi-session() {
#      xpanes -c 'envchain aws-bargain aws ssm start-session --target {}' $(envchain aws-bargain aws ec2 describe-instances --output text --query "Reservations[].Instances[?State.Name=='running'].[InstanceId,Tags[?Key=='Name'].Value|[0],PrivateIpAddress]" | peco | awk '{print $1}' | tr '\n' ' ')
# }

# aliases
# git commands
alias pex='pet exec'
alias ped='pet edit'
alias exsh='exec $SHELL'
alias gb='git branch'
alias gsp='git-switch-peco'
alias gs='git switch'
alias gp='git push'
alias gpl='git pull'
alias ga='git add'
alias gc='git commit'
alias gm='git merge'
alias grom='git fetch && git rebase origin/master'

# git branch history
# ref: https://zenn.dev/koakuma_ageha/articles/d185ecd5000dcf
# path=/usr/local/bin/git_branch_history.sh
alias gsh='git_branch_history.sh'

alias pbcopy="nkf -w | __CF_USER_TEXT_ENCODING=0x$(printf %x $(id -u)):0x08000100:14 pbcopy"
alias bers="bundle exec rspec"

# mkdir + touch
# https://qiita.com/ta1m1kam/items/d22249c348dd71cb6652
alias mduch='sh /usr/local/bin/mduch.sh'

# Claude Code with bypass permissions
alias cb="claude --permission-mode bypassPermissions"

# Claude Code with continue (-c) and bypass permissions
alias ccb="claude -c --permission-mode bypassPermissions"

# color output
export LESS='-R'

# git switch with peco
function git-switch-peco() {
  local branch
  branch=$(git branch --all | grep -v '\->' | peco | sed 's/.* //')
  if [ -n "$branch" ]; then
    git switch "$branch"
  fi
}

# direnv config
export EDITOR=vim
# Lazy load direnv
direnv() {
  unset -f direnv
  eval "$(command direnv hook zsh)"
  direnv "$@"
}


# pnpm
export PNPM_HOME="/Users/keigo.yamauchi/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Lazy load Google Cloud SDK
gcloud() {
  if [ -f '/Users/keigo.yamauchi/Downloads/google-cloud-sdk/path.zsh.inc' ]; then
    source '/Users/keigo.yamauchi/Downloads/google-cloud-sdk/path.zsh.inc'
  fi
  if [ -f '/Users/keigo.yamauchi/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then
    source '/Users/keigo.yamauchi/Downloads/google-cloud-sdk/completion.zsh.inc'
  fi
  unset -f gcloud
  gcloud "$@"
}

# NOTE: Local environment files that may contain sensitive data
# . "$HOME/.local/bin/env"

# NOTE: Removed credentials path - set GOOGLE_APPLICATION_CREDENTIALS in your local environment
# cline settings
# export GOOGLE_APPLICATION_CREDENTIALS='/path/to/your/credentials.json'
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

export PATH=$(npm config get prefix)/bin:$PATH

# Function to set iTerm2 tab title
function set_iterm_tab_title() {
  local directory=${PWD##*/}
  local git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

  if [[ -n "$git_branch" ]]; then
    echo -ne "\033]0;${directory} (${git_branch})\007"
  else
    echo -ne "\033]0;${directory}\007"
  fi
}

# Optimized precmd with caching
_last_pwd=""
_cached_git_branch=""
precmd() {
  # Only update title if directory changed
  if [[ "$PWD" != "$_last_pwd" ]]; then
    _last_pwd="$PWD"
    _cached_git_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    set_iterm_tab_title
  fi
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# NOTE: Set your own Google Cloud project ID
# gemini cli settings
# export GOOGLE_CLOUD_PROJECT="your-project-id"
alias gemini='npx https://github.com/google-gemini/gemini-cli'

# Real-time clock in YYYY-MM-DD format
function clock() {
  # Restore cursor when the function is interrupted (Ctrl+C)
  trap 'tput cnorm; printf "\n"; trap - INT' INT

  ( # Run the loop in a subshell
    while true; do
      tput civis # Hide cursor on each iteration
      printf "\r$(LC_TIME=en_US.UTF-8 date '+%Y-%m-%d %H:%M:%S %a %Z')"
      sleep 1
    done
  )
}


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# claude code monitor
# alias ccusage='npx ccusage@latest blocks --live'

# git worktree jump with peco
alias gwj='source ~/bin/git-worktree-jump.sh'


[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

export PATH=~/.npm-global/bin:$PATH
export PATH=~/.npm-global/bin:$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
