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
- Terminal: Alacritty + tmux (multi-pane workflow)
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

## Git
- Conventional commits: fix:, feat:, refactor:, chore:, docs:
- Small, focused commits — one concern per commit
- No co-authored-by tags
- Identity for commits: `aristeoibarra <aristeo.dev@gmail.com>` (GitHub account `aristeoibarra`; verified + primary there since 2026-07, when it was moved off the old `dev-nkl` account). `aristeoibarra608@gmail.com` is also verified on the same account — old history keeps attributing fine.
- In ephemeral clones or when no inherited `.gitconfig` is present, pass explicitly: `-c user.name=aristeoibarra -c user.email=aristeo.dev@gmail.com`.

## When stuck
- On failure: diagnose root cause, don't retry blindly
- Run long processes as background tasks
- If stuck after 2 attempts, stop and ask
