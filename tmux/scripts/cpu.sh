#!/usr/bin/env bash
# CPU usage for tmux status bar (macOS only)
cpuvalue=$(ps -A -o %cpu | awk -F. '{s+=$1} END {print s}')
cpucores=$(sysctl -n hw.logicalcpu)
echo "$((cpuvalue / cpucores))%"
