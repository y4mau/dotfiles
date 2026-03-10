#!/bin/bash
# Paste Windows clipboard content into the current tmux pane
content=$(powershell.exe -command "Get-Clipboard" 2>/dev/null | tr -d '\r')
if [ -n "$content" ]; then
  tmux set-buffer -- "$content"
  tmux paste-buffer
fi
