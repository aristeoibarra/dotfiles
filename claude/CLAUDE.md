# Claude Code - Global Configuration

## Language
- Code, variables, commits: always in English
- Explanations and conversation: Spanish (direct style)

## Response Style
- Be concise. Don't explain the obvious.
- If something is important, mention why in one line.
- No emojis or motivational phrases.
- Get to the point.

## Environment
- Terminal: Ghostty + tmux (multi-pane workflow)
- Editor: nvim
- Git: lazygit (alias: lg), delta as pager

## Preferred Tools (via Bash)
When running shell commands, use modern alternatives:
- `eza` for directory listings
- `sd 'pattern' 'replacement' file` for find-and-replace
- `bat` for syntax-highlighted file display
- `scc .` before planning large changes
- `ast-grep -p 'pattern' --lang tsx` for structural refactoring
- `shellcheck script.sh` to validate shell scripts before execution
- `jq` / `yq` for JSON/YAML/TOML processing
- `difft` for structural AST diffs
- `gh` for GitHub CLI operations (PRs, issues, actions)

## Tool Rules
- For multi-file refactoring, prefer `ast-grep` over regex-based replacements.
- For codebase overview, run `scc .` before planning.
- Validate generated shell scripts with `shellcheck` before suggesting execution.

## Git
- Conventional commits: fix:, feat:, refactor:, chore:, docs:
- Small, focused commits — one concern per commit
- No co-authored-by tags

## When stuck
- On failure: diagnose root cause, don't retry blindly
- Run long processes as background tasks
- If stuck after 2 attempts, stop and ask
