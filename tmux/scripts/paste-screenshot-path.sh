#!/bin/bash
# Paste the latest screenshot file path into the current tmux pane
WIN_USER=$(powershell.exe -command '[System.Environment]::UserName' 2>/dev/null | tr -d '\r')
SCREENSHOT_DIR="/mnt/c/Users/${WIN_USER}/Pictures/Screenshots"
latest=$(find "$SCREENSHOT_DIR" -maxdepth 1 -type f -printf '%T@ %f\n' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
if [ -n "$latest" ]; then
  tmux set-buffer -- "${SCREENSHOT_DIR}/${latest}"
  tmux paste-buffer
fi
