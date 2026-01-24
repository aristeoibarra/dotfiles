#!/usr/bin/env bash
# Obsidian daily note status for tmux status bar
VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/aristeo"
TODAY=$(date +%Y-%m-%d)
DAILY_NOTE="$VAULT/daily/$TODAY.md"

if [[ ! -f "$DAILY_NOTE" ]]; then
  echo "DN --"
  exit 0
fi

# Count sections still with placeholder dots (unfilled)
total_sections=$(grep -c '^##' "$DAILY_NOTE" 2>/dev/null || echo 0)
empty_sections=$(grep -c '^\.\.\.\.\.\.\.\.\.\.\.' "$DAILY_NOTE" 2>/dev/null || echo 0)

if [[ $empty_sections -gt 0 ]]; then
  filled=$((total_sections - empty_sections))
  echo "DN ${filled}/${total_sections}"
else
  echo "DN ok"
fi
