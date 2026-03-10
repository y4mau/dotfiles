# Fish shell entry point
# conf.d/ files are sourced automatically before this file

if not status is-interactive
    return
end

# Vi keybindings
fish_vi_key_bindings

# Bind Ctrl+] to peco-src (repository selector) in both default and insert modes
if command -q ghq; and begin; command -q fzf; or command -q peco; end
    bind \c] peco-src
    bind -M insert \c] peco-src
end

# Starship prompt
if command -q starship
    starship init fish | source
end

# Local customizations (outside symlink)
test -f ~/.fishrc.local; and source ~/.fishrc.local
