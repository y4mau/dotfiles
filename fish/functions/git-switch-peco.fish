# git switch with peco

function git-switch-peco
    set -l branch (git branch --all | grep -v '\->' | peco | string trim)
    if test -n "$branch"
        git switch $branch
    end
end
