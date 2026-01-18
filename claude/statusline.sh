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

# Read JSON from stdin
input=$(cat)

# Parse basic fields
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
DIR=$(echo "$input" | jq -r '.workspace.current_dir // "~"')
ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0')
REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0')

# Context window usage
CTX_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
INPUT_TOKENS=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
CACHE_CREATE=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
CACHE_READ=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')

TOTAL_USED=$((INPUT_TOKENS + CACHE_CREATE + CACHE_READ))
if [ "$CTX_SIZE" -gt 0 ] 2>/dev/null; then
  CTX_PERCENT=$((TOTAL_USED * 100 / CTX_SIZE))
else
  CTX_PERCENT=0
fi
[ "$CTX_PERCENT" -gt 100 ] && CTX_PERCENT=100
[ "$CTX_PERCENT" -lt 0 ] && CTX_PERCENT=0

# Directory name
DIR_NAME=$(basename "$DIR")

# Git info
cd "$DIR" 2>/dev/null
BRANCH=""
GIT_DIRTY=""
if git rev-parse --git-dir > /dev/null 2>&1; then
  BRANCH=$(git branch --show-current 2>/dev/null)
  if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
    GIT_DIRTY="*"
  fi
fi

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
LINE+="${SUCCESS}+${ADDED}${NC} ${ERROR}-${REMOVED}${NC}"

LINE+="${SEP}"
LINE+="${MUTED}ctx${NC} ${BAR} ${MUTED}${CTX_PERCENT}%${NC}"

echo -e "$LINE"
