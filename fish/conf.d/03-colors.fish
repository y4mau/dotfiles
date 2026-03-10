# Color support for ls and grep

if test "$IS_LINUX" = true; and test -x /usr/bin/dircolors
    if test -r ~/.dircolors
        eval (dircolors -c ~/.dircolors)
    else
        eval (dircolors -c)
    end
    alias ls 'ls --color=auto'
else if test "$IS_MACOS" = true
    set -gx CLICOLOR 1
    set -gx LSCOLORS GxFxCxDxBxegedabagaced
    alias ls 'ls -G'
end

alias grep 'grep --color=auto'
alias fgrep 'fgrep --color=auto'
alias egrep 'egrep --color=auto'
