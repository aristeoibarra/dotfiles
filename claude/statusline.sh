#!/bin/bash

# Kanagawa Dragon theme colors (RGB)
ACCENT='\033[38;2;196;178;138m'     # #c4b28a yellow
SECONDARY='\033[38;2;139;164;176m'  # #8ba4b0 blue
MUTED='\033[38;2;166;166;156m'      # #a6a69c gray
SUCCESS='\033[38;2;138;154;123m'    # #8a9a7b green
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

# Parse basic fields (single jq call for performance)
IFS=$'\t' read -r MODEL DIR < <(echo "$input" | jq -r '[.model.display_name // "Claude", .workspace.current_dir // empty] | @tsv' 2>/dev/null)
[[ -z "$MODEL" ]] && MODEL="Claude"
[[ -z "$DIR" ]] && DIR="$HOME"

# Directory name
DIR_NAME=$(basename "$DIR" 2>/dev/null || echo "~")

# Git info (in subshell to avoid changing current directory)
GIT_INFO=$(
  cd "$DIR" 2>/dev/null || exit 0
  git rev-parse --git-dir > /dev/null 2>&1 || exit 0

  branch=$(git branch --show-current 2>/dev/null)
  [[ -z "$branch" ]] && branch=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")

  dirty=""
  [[ -n "$(git status --porcelain 2>/dev/null)" ]] && dirty="*"

  # Get diff stats: staged + unstaged + untracked
  added=0 deleted=0

  # Tracked files (staged + unstaged changes)
  if git rev-parse HEAD &>/dev/null; then
    while IFS=$'\t' read -r a d _; do
      [[ "$a" =~ ^[0-9]+$ ]] && added=$((added + a))
      [[ "$d" =~ ^[0-9]+$ ]] && deleted=$((deleted + d))
    done < <(git diff --numstat HEAD 2>/dev/null)
  fi

  # Untracked files (all lines count as added)
  while IFS= read -r -d '' file; do
    lines=$(wc -l < "$file" 2>/dev/null | tr -d ' ')
    [[ "$lines" =~ ^[0-9]+$ ]] && added=$((added + lines))
  done < <(git ls-files --others --exclude-standard -z 2>/dev/null)

  echo "${branch}|${dirty}|${added}|${deleted}"
)
BRANCH=$(echo "$GIT_INFO" | cut -d'|' -f1)
GIT_DIRTY=$(echo "$GIT_INFO" | cut -d'|' -f2)
GIT_ADDED=$(echo "$GIT_INFO" | cut -d'|' -f3)
GIT_DELETED=$(echo "$GIT_INFO" | cut -d'|' -f4)

# Ensure numeric values (default to 0)
[[ ! "$GIT_ADDED" =~ ^[0-9]+$ ]] && GIT_ADDED=0
[[ ! "$GIT_DELETED" =~ ^[0-9]+$ ]] && GIT_DELETED=0

# Build status line
SEP="${MUTED}  ${NC}"

LINE="${BOLD}${PURPLE}${MODEL}${NC}"
LINE+="${SEP}"
LINE+="${ACCENT}󰉋 ${DIR_NAME}${NC}"

if [ -n "$BRANCH" ]; then
  LINE+="${SEP}"
  LINE+="${SECONDARY} ${BRANCH}${GIT_DIRTY}${NC}"
  if [ "$GIT_ADDED" -gt 0 ] || [ "$GIT_DELETED" -gt 0 ]; then
    LINE+=" ${SUCCESS}+${GIT_ADDED}${NC} ${ERROR}-${GIT_DELETED}${NC}"
  fi
fi

echo -e "$LINE"
