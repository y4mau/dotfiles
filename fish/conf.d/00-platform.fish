# Platform detection
# Sets global variables: IS_MACOS, IS_WSL, IS_LINUX

set -g IS_MACOS false
set -g IS_WSL false
set -g IS_LINUX false

switch (uname -s)
    case Darwin
        set -g IS_MACOS true
    case Linux
        if test -f /proc/version; and string match -qi microsoft (cat /proc/version)
            set -g IS_WSL true
            set -g IS_LINUX true
        else
            set -g IS_LINUX true
        end
end
