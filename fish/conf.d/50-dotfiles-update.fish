# Background dotfiles auto-update

set -l dotfiles_dir $HOME/ghq/github.com/y4mau/dotfiles
set -l marker $HOME/.dotfiles_updated

# Show notice if dotfiles were updated in a previous session
if test -f $marker
    echo "[dotfiles] Updated to latest origin/main: "(cat $marker)
    rm -f $marker
end

# Background check for dotfiles updates (fish auto-disowns background jobs)
if test -d $dotfiles_dir/.git
    fish -c "
        git -C $dotfiles_dir fetch origin main --quiet 2>/dev/null
        set -l local_head (git -C $dotfiles_dir rev-parse HEAD 2>/dev/null)
        set -l remote_head (git -C $dotfiles_dir rev-parse origin/main 2>/dev/null)
        if test -n \"\$local_head\"; and test -n \"\$remote_head\"; and test \"\$local_head\" != \"\$remote_head\"
            git -C $dotfiles_dir pull --ff-only origin main --quiet 2>/dev/null
            and git -C $dotfiles_dir log --oneline \"\$local_head..HEAD\" 2>/dev/null >$marker
        end
    " &
end
