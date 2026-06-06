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
IFS='|' read -r MODEL DIR USED_PCT LINES_ADDED LINES_REMOVED DURATION_MS TOTAL_TOKENS TOTAL_COST RATE_5H RATE_7D < <(
  echo "$input" | jq -r '[
    (.model.display_name // "Claude"),
    (.workspace.current_dir // ""),
    (.context_window.used_percentage // 0),
    (.cost.total_lines_added // 0),
    (.cost.total_lines_removed // 0),
    (.cost.total_duration_ms // 0),
    (((.context_window.total_input_tokens // 0) + (.context_window.total_output_tokens // 0)) | tostring),
    (.cost.total_cost_usd // 0 | tostring),
    (.rate_limits.five_hour.used_percentage // -1 | tostring),
    (.rate_limits.seven_day.used_percentage // -1 | tostring)
  ] | join("|")' 2>/dev/null
)
[[ -z "$MODEL" ]] && MODEL="Claude"
# Shorten model name: "Opus 4.6 (1M context)" → "Opus 4.6"
MODEL="${MODEL%% (*}"
[[ -z "$DIR" ]] && DIR="$HOME"
[[ ! "$USED_PCT" =~ ^[0-9]+$ ]] && USED_PCT=0
[[ ! "$LINES_ADDED" =~ ^[0-9]+$ ]] && LINES_ADDED=0
[[ ! "$LINES_REMOVED" =~ ^[0-9]+$ ]] && LINES_REMOVED=0
[[ ! "$DURATION_MS" =~ ^[0-9]+$ ]] && DURATION_MS=0
[[ -z "$TOTAL_TOKENS" ]] && TOTAL_TOKENS=0
[[ -z "$TOTAL_COST" ]] && TOTAL_COST="0"
[[ -z "$RATE_5H" ]] && RATE_5H="-1"
[[ -z "$RATE_7D" ]] && RATE_7D="-1"

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

# Token count formatting (raw → Xk or X.Xm)
TOKENS_STR=""
if [[ "$TOTAL_TOKENS" =~ ^[0-9]+$ ]] && [ "$TOTAL_TOKENS" -gt 0 ]; then
  if [ "$TOTAL_TOKENS" -ge 1000000 ]; then
    TOKENS_STR="$(awk "BEGIN {printf \"%.1fm\", $TOTAL_TOKENS/1000000}")"
  elif [ "$TOTAL_TOKENS" -ge 1000 ]; then
    TOKENS_STR="$(awk "BEGIN {printf \"%.0fk\", $TOTAL_TOKENS/1000}")"
  else
    TOKENS_STR="${TOTAL_TOKENS}"
  fi
fi

# Cost formatting
COST_STR=""
if [[ "$TOTAL_COST" != "0" ]] && [[ "$TOTAL_COST" != "0.0" ]]; then
  COST_STR=$(awk "BEGIN {printf \"\$%.2f\", $TOTAL_COST}")
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

if [ -n "$TOKENS_STR" ]; then
  LINE+="${SEP}"
  LINE+="${SECONDARY}󰊖 ${TOKENS_STR}${NC}"
  if [ -n "$COST_STR" ]; then
    LINE+=" ${MUTED}${COST_STR}${NC}"
  fi
fi

# Rate limits (only shown if available, i.e. Pro/Max plan)
if [[ "$RATE_5H" != "-1" || "$RATE_7D" != "-1" ]]; then
  LINE+="${SEP}"
  if [[ "$RATE_5H" != "-1" ]]; then
    if [ "${RATE_5H%.*}" -gt 80 ] 2>/dev/null; then
      RATE_5H_COLOR="$ERROR"
    elif [ "${RATE_5H%.*}" -gt 50 ] 2>/dev/null; then
      RATE_5H_COLOR="$WARNING"
    else
      RATE_5H_COLOR="$SUCCESS"
    fi
    LINE+="${RATE_5H_COLOR}5h:${RATE_5H%.*}%${NC}"
  fi
  if [[ "$RATE_7D" != "-1" ]]; then
    [[ "$RATE_5H" != "-1" ]] && LINE+=" "
    if [ "${RATE_7D%.*}" -gt 80 ] 2>/dev/null; then
      RATE_7D_COLOR="$ERROR"
    elif [ "${RATE_7D%.*}" -gt 50 ] 2>/dev/null; then
      RATE_7D_COLOR="$WARNING"
    else
      RATE_7D_COLOR="$SUCCESS"
    fi
    LINE+="${RATE_7D_COLOR}7d:${RATE_7D%.*}%${NC}"
  fi
fi

LINE+="${SEP}"
LINE+="${CTX_COLOR}[${CTX_BAR}] ${USED_PCT}%${NC}"

echo -e "$LINE"
