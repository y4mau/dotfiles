#!/bin/bash
# Paste the latest screenshot file path into the current tmux pane
SCREENSHOT_DIR="/mnt/c/Users/keigo.yamauchi/Pictures/Screenshots"
latest=$(ls -t "$SCREENSHOT_DIR" 2>/dev/null | head -1)
if [ -n "$latest" ]; then
  tmux set-buffer -- "${SCREENSHOT_DIR}/${latest}"
  tmux paste-buffer
fi
