# =============================================================================
# Fish shell entry point
# conf.d/ files are sourced automatically before this file
# =============================================================================

if not status is-interactive
    return
end

# =============================================================================
# Vi Keybindings
# =============================================================================
fish_vi_key_bindings

# =============================================================================
# Key Bindings (must be after fish_vi_key_bindings to avoid being reset)
# =============================================================================
if command -q ghq; and begin; command -q fzf; or command -q peco; end
    bind -M default \x1d peco-src
    bind -M insert \x1d peco-src
end

# =============================================================================
# Starship Prompt
# =============================================================================
if command -q starship
    starship init fish | source
end

# =============================================================================
# Local Customizations
# =============================================================================
test -f ~/.fishrc.local; and source ~/.fishrc.local
