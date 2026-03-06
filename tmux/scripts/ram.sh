#!/usr/bin/env bash
# RAM usage for tmux status bar (macOS only)
used_mem=$(vm_stat | grep ' active\|wired ' | sed 's/[^0-9]//g' | paste -sd ' ' - | awk -v pagesize="$(pagesize)" '{printf "%d\n", ($1+$2) * pagesize / 1048576}')
total_mem=$(sysctl -n hw.memsize | awk '{printf "%.0fGB", $0/1024/1024/1024}')
if ((used_mem < 1024)); then
  echo "${used_mem}MB/${total_mem}"
else
  echo "$((used_mem / 1024))GB/${total_mem}"
fi
