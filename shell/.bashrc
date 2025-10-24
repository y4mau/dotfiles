# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bashrc.pre.bash"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# PATH Configuration
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# NOTE: Source company-specific profile if exists
# source ~/.tok2/profile

# Set ghq & peco shortcut as '^]'
function peco-src () {
  local selected_dir=$(ghq list -p | peco --query "$READLINE_LINE")
  if [ -n "$selected_dir" ]; then
    READLINE_LINE="cd ${selected_dir}"
    READLINE_POINT=${#READLINE_LINE}
    history -s "$READLINE_LINE"
  fi
  clear
}
bind -x '"\C-]": peco-src'

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

# git branch history
# ref: https://zenn.dev/koakuma_ageha/articles/d185ecd5000dcf
# path=/usr/local/bin/git_branch_history.sh
alias gsh='git_branch_history.sh'

alias pbcopy="nkf -w | __CF_USER_TEXT_ENCODING=0x$(printf %x $(id -u)):0x08000100:14 pbcopy"
alias bers="bundle exec rspec"

# mkdir + touch
# https://qiita.com/ta1m1kam/items/d22249c348dd71cb6652
alias mduch='sh /usr/local/bin/mduch.sh'

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
eval "$(direnv hook bash)"

# pnpm
export PNPM_HOME="/Users/keigo.yamauchi/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/keigo.yamauchi/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/Users/keigo.yamauchi/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/keigo.yamauchi/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/keigo.yamauchi/Downloads/google-cloud-sdk/completion.bash.inc'; fi

# NOTE: Local environment files that may contain sensitive data
# . "$HOME/.local/bin/env"

# NOTE: Removed credentials path - set GOOGLE_APPLICATION_CREDENTIALS in your local environment
# cline settings
# export GOOGLE_APPLICATION_CREDENTIALS='/path/to/your/credentials.json'
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path bash)"

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

# Set the title before each prompt (bash equivalent of precmd)
PROMPT_COMMAND="set_iterm_tab_title"

# iTerm2 shell integration (bash version)
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

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

# Basic bash configurations
set -o vi  # Enable vi mode
shopt -s histappend  # Append to history file
shopt -s checkwinsize  # Check window size after each command
export HISTCONTROL=ignoredups:erasedups  # Avoid duplicate history entries
export HISTSIZE=1000
export HISTFILESIZE=2000

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Simple colored PS1 prompt
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"

# Amazon Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/bashrc.post.bash" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/bashrc.post.bash"
export PATH=~/.npm-global/bin:$PATH
