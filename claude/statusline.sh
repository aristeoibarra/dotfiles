#!/bin/bash

# Kanagawa Dragon theme colors (RGB)
ACCENT='\033[38;2;196;178;138m'     # #c4b28a yellow
SECONDARY='\033[38;2;139;164;176m'  # #8ba4b0 blue
MUTED='\033[38;2;166;166;156m'      # #a6a69c gray
SUCCESS='\033[38;2;138;154;123m'    # #8a9a7b green
WARNING='\033[38;2;196;178;138m'    # #c4b28a yellow (same as accent)
ERROR='\033[38;2;196;116;110m'      # #c4746e red
PURPLE='\033[38;2;147;138;169m'     # #938aa9 magenta
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
IFS='|' read -r MODEL DIR COST_CENTS USED_PCT LINES_ADDED LINES_REMOVED < <(
  echo "$input" | jq -r '[
    (.model.display_name // "Claude"),
    (.workspace.current_dir // ""),
    ((.cost.total_cost_usd // 0) * 100 | floor),
    (.context_window.used_percentage // 0),
    (.cost.total_lines_added // 0),
    (.cost.total_lines_removed // 0)
  ] | join("|")' 2>/dev/null
)
[[ -z "$MODEL" ]] && MODEL="Claude"
[[ -z "$DIR" ]] && DIR="$HOME"
[[ ! "$COST_CENTS" =~ ^[0-9]+$ ]] && COST_CENTS=0
[[ ! "$USED_PCT" =~ ^[0-9]+$ ]] && USED_PCT=0
[[ ! "$LINES_ADDED" =~ ^[0-9]+$ ]] && LINES_ADDED=0
[[ ! "$LINES_REMOVED" =~ ^[0-9]+$ ]] && LINES_REMOVED=0

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

# Cost formatting ($X.XX from cents, no bc needed)
cost_dollars=$((COST_CENTS / 100))
cost_remainder=$((COST_CENTS % 100))
COST_STR=$(printf '$%d.%02d' "$cost_dollars" "$cost_remainder")
if [ "$COST_CENTS" -gt 500 ]; then
  COST_COLOR="$ERROR"
elif [ "$COST_CENTS" -gt 100 ]; then
  COST_COLOR="$WARNING"
else
  COST_COLOR="$SUCCESS"
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

LINE+="${SEP}"
LINE+="${COST_COLOR}${COST_STR}${NC}"

LINE+="${SEP}"
LINE+="${CTX_COLOR}[${CTX_BAR}] ${USED_PCT}%${NC}"

echo -e "$LINE"
