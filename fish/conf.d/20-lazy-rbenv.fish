# Lazy load rbenv
# PATH for shims is added in 01-path.fish; full init runs on first use

if command -q rbenv
    function rbenv --wraps rbenv
        functions -e rbenv
        command rbenv init - fish | source
        rbenv $argv
    end
end
