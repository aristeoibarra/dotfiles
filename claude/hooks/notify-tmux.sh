#!/bin/bash

# Smart notification — context-aware with duration threshold
# Hook event: Stop (Claude finished responding)
# Skips if user is watching Claude's pane or response was quick (<10s)

THRESHOLD_SEC=10

# Read hook data from stdin
input=""
while IFS= read -r -t 1 line || [[ -n "$line" ]]; do
  input+="$line"
done

# Parse session ID for per-session state tracking
session_id=$(echo "$input" | jq -r '.session_id // empty' 2>/dev/null)
STATE_FILE="/tmp/claude-notify-${session_id:-default}"

# Duration threshold: skip quick responses
now=$(date +%s)
if [[ -f "$STATE_FILE" ]]; then
  last_ts=$(cat "$STATE_FILE")
  elapsed=$((now - last_ts))
else
  elapsed=$THRESHOLD_SEC # First stop in session: allow notification
fi
echo "$now" > "$STATE_FILE"

[[ "$elapsed" -lt "$THRESHOLD_SEC" ]] && exit 0

# If in tmux, check if user is watching Claude's pane
if [[ -n "$TMUX" ]]; then
  # Check frontmost app first — tmux doesn't change active pane when user switches apps
  front_app=$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)

  # Alacritty focused → check if user is in Claude's pane
  # Use list-clients to get the real active pane (works across sessions/windows)
  if [[ "$front_app" == "alacritty" || "$front_app" == "Alacritty" ]]; then
    claude_pane="$TMUX_PANE"
    active_pane=$(tmux list-clients -F '#{client_activity} #{pane_id}' 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2)
    [[ "$claude_pane" == "$active_pane" ]] && exit 0
  fi
fi

# Build notification context
notify_title="Claude"
notify_body="Respuesta lista"

if [[ -n "$TMUX" ]]; then
  tmux_session=$(tmux display-message -t "${TMUX_PANE}" -p '#{session_name}' 2>/dev/null)
  pane_path=$(tmux display-message -t "${TMUX_PANE}" -p '#{pane_current_path}' 2>/dev/null)
  project=$(basename "$pane_path" 2>/dev/null)

  [[ -n "$tmux_session" ]] && notify_title="Claude · ${tmux_session}"

  # Format duration
  if [[ "$elapsed" -ge 3600 ]]; then
    duration="$((elapsed / 3600))h$((elapsed % 3600 / 60))m"
  elif [[ "$elapsed" -ge 60 ]]; then
    duration="$((elapsed / 60))m"
  else
    duration="${elapsed}s"
  fi

  [[ -n "$project" ]] && notify_body="${project} — ${duration}"
fi

# Notify: sound + macOS notification
afplay /System/Library/Sounds/Glass.aiff &
osascript -e "display notification \"${notify_body}\" with title \"${notify_title}\"" 2>/dev/null
