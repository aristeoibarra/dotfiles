#!/bin/bash

# Kanagawa Dragon theme colors (RGB)
PRIMARY='\033[38;2;127;180;202m'    # #7fb4ca bright blue
ACCENT='\033[38;2;196;178;138m'     # #c4b28a yellow
SECONDARY='\033[38;2;139;164;176m'  # #8ba4b0 blue
MUTED='\033[38;2;166;166;156m'      # #a6a69c gray
SUCCESS='\033[38;2;138;154;123m'    # #8a9a7b green
ERROR='\033[38;2;196;116;110m'      # #c4746e red
PURPLE='\033[38;2;147;138;169m'     # #938aa9 magenta
CYAN='\033[38;2;122;168;159m'       # #7aa89f cyan
BOLD='\033[1m'
NC='\033[0m'

# Check jq is installed
if ! command -v jq &> /dev/null; then
  echo -e "${ERROR}jq not installed${NC}"
  exit 1
fi

# Read JSON from stdin with timeout (2 seconds)
input=$(timeout 2 cat 2>/dev/null || cat)

# Helper: extract numeric value from JSON, default to 0
parse_num() {
  local val
  val=$(echo "$input" | jq -r "$1 // 0" 2>/dev/null | tr -cd '0-9')
  echo "${val:-0}"
}

# Parse basic fields
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"' 2>/dev/null)
[ -z "$MODEL" ] && MODEL="Claude"

DIR=$(echo "$input" | jq -r '.workspace.current_dir // "~"' 2>/dev/null)
[ -z "$DIR" ] || [ "$DIR" = "null" ] && DIR="$HOME"

# Context window usage
CTX_SIZE=$(parse_num '.context_window.context_window_size')
[ "$CTX_SIZE" -eq 0 ] && CTX_SIZE=200000

INPUT_TOKENS=$(parse_num '.context_window.current_usage.input_tokens')
CACHE_CREATE=$(parse_num '.context_window.current_usage.cache_creation_input_tokens')
CACHE_READ=$(parse_num '.context_window.current_usage.cache_read_input_tokens')

TOTAL_USED=$((INPUT_TOKENS + CACHE_CREATE + CACHE_READ))
CTX_PERCENT=$((TOTAL_USED * 100 / CTX_SIZE))
[ "$CTX_PERCENT" -gt 100 ] && CTX_PERCENT=100
[ "$CTX_PERCENT" -lt 0 ] && CTX_PERCENT=0

# Directory name (handle ~ and empty)
if [ "$DIR" = "~" ] || [ -z "$DIR" ]; then
  DIR_NAME="~"
else
  DIR_NAME=$(basename "$DIR" 2>/dev/null || echo "~")
fi

# Git info (in subshell to avoid changing current directory)
GIT_INFO=$(
  cd "$DIR" 2>/dev/null || exit 0
  if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
    dirty=""
    if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
      dirty="*"
    fi
    echo "${branch}${dirty}"
  fi
)
BRANCH="${GIT_INFO%\*}"
GIT_DIRTY=""
[[ "$GIT_INFO" == *"*" ]] && GIT_DIRTY="*"

# Model icon
MODEL_ICON="🤖"
case "$MODEL" in
  *Opus*) MODEL_ICON="🎭" ;;
  *Sonnet*) MODEL_ICON="📝" ;;
  *Haiku*) MODEL_ICON="🍃" ;;
esac

# Progress bar for context
BAR_WIDTH=8
FILLED=$((CTX_PERCENT * BAR_WIDTH / 100))
EMPTY=$((BAR_WIDTH - FILLED))

if [ "$CTX_PERCENT" -ge 80 ]; then
  BAR_COLOR="$ERROR"
elif [ "$CTX_PERCENT" -ge 50 ]; then
  BAR_COLOR="$ACCENT"
else
  BAR_COLOR="$SUCCESS"
fi

BAR="${BAR_COLOR}"
for ((i=0; i<FILLED; i++)); do BAR+="█"; done
BAR+="${MUTED}"
for ((i=0; i<EMPTY; i++)); do BAR+="░"; done
BAR+="${NC}"

# Build status line
SEP="${MUTED}  ${NC}"

LINE="${BOLD}${PURPLE}${MODEL_ICON} ${MODEL}${NC}"
LINE+="${SEP}"
LINE+="${ACCENT}󰉋 ${DIR_NAME}${NC}"

if [ -n "$BRANCH" ]; then
  LINE+="${SEP}"
  LINE+="${SECONDARY} ${BRANCH}${GIT_DIRTY}${NC}"
fi

LINE+="${SEP}"
LINE+="${MUTED}ctx${NC} ${BAR} ${MUTED}${CTX_PERCENT}%${NC}"

echo -e "$LINE"
