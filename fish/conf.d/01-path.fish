# PATH configuration
# Uses fish_add_path which deduplicates automatically

fish_add_path -g $HOME/.local/bin
fish_add_path -g $HOME/go/bin
fish_add_path -g /usr/local/go/bin
fish_add_path -g $HOME/.npm-global/bin
fish_add_path -g $HOME/.moon/bin

# Homebrew (macOS)
if test "$IS_MACOS" = true
    if test -f /opt/homebrew/bin/brew
        eval (/opt/homebrew/bin/brew shellenv)
    else if test -f /usr/local/bin/brew
        eval (/usr/local/bin/brew shellenv)
    end
end

# rbenv shims (actual init is lazy-loaded)
fish_add_path -g $HOME/.rbenv/shims
fish_add_path -g $HOME/.rbenv/bin

# pnpm (platform-aware)
if test "$IS_MACOS" = true
    set -gx PNPM_HOME $HOME/Library/pnpm
else
    set -gx PNPM_HOME $HOME/.local/share/pnpm
end
fish_add_path -g $PNPM_HOME

# bun
set -gx BUN_INSTALL $HOME/.bun
fish_add_path -g $BUN_INSTALL/bin

# fnm (Fast Node Manager)
if test -d $HOME/.local/share/fnm
    fish_add_path -g $HOME/.local/share/fnm
else if test -d $HOME/.fnm
    fish_add_path -g $HOME/.fnm
end
