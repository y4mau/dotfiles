# Markdown preview in browser
# Requires: cd ~/ghq/github.com/y4mau/markdown.mbt && pnpm vite

function mdpreview
    set -l abs (realpath $argv[1] 2>/dev/null)
    if test -z "$abs"; or not test -f "$abs"
        echo "mdpreview: file not found: $argv[1]" >&2
        return 1
    end

    set -l url "http://localhost:5173/?file=$abs"

    if command -q xdg-open
        xdg-open $url
    else if command -q cmd.exe
        cmd.exe /c start "" $url 2>/dev/null
    else
        echo $url
    end
end
