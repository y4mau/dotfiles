# Background dotfiles auto-update

set -l dotfiles_dir $HOME/ghq/github.com/y4mau/dotfiles
set -l marker $HOME/.dotfiles_updated

# Show notice if dotfiles were updated in a previous session
if test -f $marker
    echo "[dotfiles] Updated to latest origin/main: "(cat $marker)
    rm -f $marker
end

# Background check for dotfiles updates using sh (avoids fish child process and job warning)
if status is-interactive; and test -d $dotfiles_dir/.git
    command sh -c '
        git -C "$1" fetch origin main --quiet 2>/dev/null
        local_head=$(git -C "$1" rev-parse HEAD 2>/dev/null)
        remote_head=$(git -C "$1" rev-parse origin/main 2>/dev/null)
        if [ -n "$local_head" ] && [ -n "$remote_head" ] && [ "$local_head" != "$remote_head" ]; then
            git -C "$1" pull --ff-only origin main --quiet 2>/dev/null
            if [ $? -eq 0 ]; then
                git -C "$1" log --oneline "${local_head}..HEAD" 2>/dev/null > "$2"
            fi
        fi
    ' _ $dotfiles_dir $marker &
    disown
end
