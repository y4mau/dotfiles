# ghq + fzf/peco repository selector

function peco-src
    set -l selected_dir

    if command -q fzf
        if test -n "$TMUX"; and command -q fzf-tmux
            set selected_dir (ghq list -p | fzf-tmux -p 80%,60% --query (commandline -b))
        else
            set selected_dir (ghq list -p | fzf --query (commandline -b))
        end
    else if command -q peco
        set selected_dir (ghq list -p | peco --query (commandline -b))
    end

    if test -n "$selected_dir"
        cd $selected_dir
        commandline -r ""
        commandline -f repaint
    else
        commandline -f repaint
    end
end
