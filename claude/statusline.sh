#!/bin/bash

# Dynamic theme colors — reads from the centralized theme system
hex_to_ansi() {
  local hex="${1#\#}"
  local r=$((16#${hex:0:2}))
  local g=$((16#${hex:2:2}))
  local b=$((16#${hex:4:2}))
  printf '\033[38;2;%d;%d;%dm' "$r" "$g" "$b"
}

THEME_FILE="$HOME/.local/state/theme/current"
if [[ -f "$THEME_FILE" ]]; then
  THEME_NAME=$(cat "$THEME_FILE")
  THEME_SRC="$HOME/dotfiles/themes/${THEME_NAME}.sh"
  if [[ -f "$THEME_SRC" ]]; then
    # shellcheck source=/dev/null
    source "$THEME_SRC"
  fi
fi

# Map theme colors to semantic roles (fallback to Gruvbox Dark defaults)
ACCENT=$(hex_to_ansi "${YELLOW:-#fabd2f}")
SECONDARY=$(hex_to_ansi "${BRIGHT_BLUE:-#83a598}")
MUTED=$(hex_to_ansi "${GRAY:-#928374}")
SUCCESS=$(hex_to_ansi "${GREEN:-#b8bb26}")
WARNING=$(hex_to_ansi "${YELLOW:-#fabd2f}")
ERROR=$(hex_to_ansi "${RED:-#fb4934}")
PURPLE=$(hex_to_ansi "${MAGENTA:-#d3869b}")
BOLD='\033[1m'
NC='\033[0m'

# Check jq is installed
if ! command -v jq &> /dev/null; then
  echo -e "${ERROR}jq not installed${NC}"
  exit 1
fi

# Read JSON from stdin (macOS compatible)
input=""
while IFS= read -r -t 2 line || [[ -n "$line" ]]; do
  input+="$line"
done

# Parse all fields in a single jq call
IFS='|' read -r MODEL DIR USED_PCT LINES_ADDED LINES_REMOVED DURATION_MS < <(
  echo "$input" | jq -r '[
    (.model.display_name // "Claude"),
    (.workspace.current_dir // ""),
    (.context_window.used_percentage // 0),
    (.cost.total_lines_added // 0),
    (.cost.total_lines_removed // 0),
    (.cost.total_duration_ms // 0)
  ] | join("|")' 2>/dev/null
)
[[ -z "$MODEL" ]] && MODEL="Claude"
[[ -z "$DIR" ]] && DIR="$HOME"
[[ ! "$USED_PCT" =~ ^[0-9]+$ ]] && USED_PCT=0
[[ ! "$LINES_ADDED" =~ ^[0-9]+$ ]] && LINES_ADDED=0
[[ ! "$LINES_REMOVED" =~ ^[0-9]+$ ]] && LINES_REMOVED=0
[[ ! "$DURATION_MS" =~ ^[0-9]+$ ]] && DURATION_MS=0

# Directory name
DIR_NAME=$(basename "$DIR" 2>/dev/null || echo "~")

# Git info (branch + dirty flag only, no expensive diff)
GIT_INFO=$(
  cd "$DIR" 2>/dev/null || exit 0
  git rev-parse --git-dir > /dev/null 2>&1 || exit 0

  branch=$(git branch --show-current 2>/dev/null)
  [[ -z "$branch" ]] && branch=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")

  dirty=""
  [[ -n "$(git status --porcelain 2>/dev/null | head -1)" ]] && dirty="*"

  echo "${branch}|${dirty}"
)
BRANCH=$(echo "$GIT_INFO" | cut -d'|' -f1)
GIT_DIRTY=$(echo "$GIT_INFO" | cut -d'|' -f2)

# Duration formatting (ms → Xm or XhYm)
DURATION_STR=""
if [ "$DURATION_MS" -gt 0 ]; then
  total_sec=$((DURATION_MS / 1000))
  total_min=$((total_sec / 60))
  hours=$((total_min / 60))
  mins=$((total_min % 60))
  if [ "$hours" -gt 0 ]; then
    DURATION_STR="${hours}h${mins}m"
  elif [ "$total_min" -gt 0 ]; then
    DURATION_STR="${total_min}m"
  else
    DURATION_STR="${total_sec}s"
  fi
fi

# Context bar (8 blocks)
filled=$((USED_PCT * 8 / 100))
[ "$filled" -gt 8 ] && filled=8
empty=$((8 - filled))
CTX_BAR=""
for ((i = 0; i < filled; i++)); do CTX_BAR+="█"; done
for ((i = 0; i < empty; i++)); do CTX_BAR+="░"; done
if [ "$USED_PCT" -gt 80 ]; then
  CTX_COLOR="$ERROR"
elif [ "$USED_PCT" -gt 50 ]; then
  CTX_COLOR="$WARNING"
else
  CTX_COLOR="$SUCCESS"
fi

# Build status line
SEP="${MUTED}  ${NC}"

LINE="${BOLD}${PURPLE}${MODEL}${NC}"
LINE+="${SEP}"
LINE+="${ACCENT}󰉋 ${DIR_NAME}${NC}"

if [ -n "$BRANCH" ]; then
  LINE+="${SEP}"
  LINE+="${SECONDARY} ${BRANCH}${GIT_DIRTY}${NC}"
  if [ "$LINES_ADDED" -gt 0 ] || [ "$LINES_REMOVED" -gt 0 ]; then
    LINE+=" ${SUCCESS}+${LINES_ADDED}${NC} ${ERROR}-${LINES_REMOVED}${NC}"
  fi
fi

if [ -n "$DURATION_STR" ]; then
  LINE+="${SEP}"
  LINE+="${MUTED} ${DURATION_STR}${NC}"
fi

LINE+="${SEP}"
LINE+="${CTX_COLOR}[${CTX_BAR}] ${USED_PCT}%${NC}"

echo -e "$LINE"
