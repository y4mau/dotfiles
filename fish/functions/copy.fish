# Copy stdin to Windows clipboard (UTF-8 -> UTF-16LE for clip.exe)
# WSL only

function copy
    iconv -f UTF-8 -t UTF-16LE | clip.exe
end
