#!/bin/bash
# Paste the latest screenshot file path into the current tmux pane
WIN_USER=$(powershell.exe -command '[System.Environment]::UserName' 2>/dev/null | tr -d '\r')
SCREENSHOT_DIR="/mnt/c/Users/${WIN_USER}/Pictures/Screenshots"
latest=$(ls -t "$SCREENSHOT_DIR" 2>/dev/null | head -1)
if [ -n "$latest" ]; then
  tmux set-buffer -- "${SCREENSHOT_DIR}/${latest}"
  tmux paste-buffer
fi
