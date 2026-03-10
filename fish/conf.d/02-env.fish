# Environment variables

set -gx EDITOR vim
set -gx LESS -R
set -gx NVM_DIR $HOME/.nvm

# Browser (WSL2 uses wslview to open in Windows)
if test "$IS_WSL" = true
    set -gx BROWSER wslview
end
