#!/usr/bin/env bash
# Move or swap current tmux window with target and follow focus

TARGET="$1"

if [ -z "$TARGET" ]; then
  echo "Usage: tmux-swap-and-follow.sh <window-number>"
  exit 1
fi

# Check if target window exists
if tmux list-windows -F '#{window_index}' | grep -q "^${TARGET}$"; then
  # Target exists: swap windows
  tmux swap-window -t "$TARGET" && tmux select-window -t "$TARGET"
else
  # Target doesn't exist: move to that index
  tmux move-window -t "$TARGET" && tmux select-window -t "$TARGET"
fi
