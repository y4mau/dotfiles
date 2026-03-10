# Terminal title with git branch
# Fish calls this automatically to set the terminal title

function fish_title
    set -l directory (basename $PWD)
    set -l branch (git rev-parse --abbrev-ref HEAD 2>/dev/null)

    if test -n "$branch"
        echo "$directory ($branch)"
    else
        echo "$directory"
    end
end
