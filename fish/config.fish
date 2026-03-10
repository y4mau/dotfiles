# Fish shell entry point
# conf.d/ files are sourced automatically before this file

if not status is-interactive
    return
end

# Vi keybindings
fish_vi_key_bindings

# Bind Ctrl+] to peco-src (must be after fish_vi_key_bindings to avoid being reset)
if command -q ghq; and begin; command -q fzf; or command -q peco; end
    bind -M default \x1d peco-src
    bind -M insert \x1d peco-src
end

# Starship prompt
if command -q starship
    starship init fish | source
end

# Local customizations (outside symlink)
test -f ~/.fishrc.local; and source ~/.fishrc.local
