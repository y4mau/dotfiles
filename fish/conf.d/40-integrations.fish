# Tool integrations

# VSCode shell integration
if test "$TERM_PROGRAM" = vscode; and command -q code
    source (code --locate-shell-integration-path fish)
end

# iTerm2 shell integration (macOS)
if test "$IS_MACOS" = true
    test -e $HOME/.iterm2_shell_integration.fish; and source $HOME/.iterm2_shell_integration.fish
end

# lesspipe (Linux)
if test "$IS_LINUX" = true; and test -x /usr/bin/lesspipe
    eval (env SHELL=/bin/sh lesspipe)
end
