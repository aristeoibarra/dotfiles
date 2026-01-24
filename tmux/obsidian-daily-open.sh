#!/usr/bin/env bash
# Open today's daily note in nvim, creating from template if needed
VAULT="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/aristeo"
TODAY=$(date +%Y-%m-%d)
DAY_NAME=$(date +%A)
DAILY_NOTE="$VAULT/daily/$TODAY.md"
TEMPLATE="$VAULT/template-daily.md"

if [[ ! -f "$DAILY_NOTE" ]]; then
  mkdir -p "$VAULT/daily"
  sed -e "s/{{date}}/$TODAY/g" -e "s/{{date:dddd}}/$DAY_NAME/g" "$TEMPLATE" > "$DAILY_NOTE"
fi

exec /opt/homebrew/bin/nvim "$DAILY_NOTE"
