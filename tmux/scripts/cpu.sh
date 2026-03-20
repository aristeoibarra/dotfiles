#!/usr/bin/env bash
# CPU usage for tmux status bar (macOS only)
# Uses top snapshot instead of scanning all processes with ps
top -l 1 -n 0 2>/dev/null | awk '/CPU usage/ {printf "%.0f%%", $3+$5}'
