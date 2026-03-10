# Lazy load direnv

if command -q direnv
    function direnv --wraps direnv
        functions -e direnv
        direnv hook fish | source
        direnv $argv
    end
end
