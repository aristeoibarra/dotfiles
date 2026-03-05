# Claude Code - Global Configuration

## Language
- Code, variables, commits: always in English
- Explanations and conversation: Spanish (direct style)

## Response Style
- Be concise. Don't explain the obvious.
- If something is important, mention why in one line.
- No emojis or motivational phrases.
- Get to the point.

## Preferred Tools
Use modern tools instead of system defaults:
- `bat` instead of `cat`
- `rg` instead of `grep`
- `fd` instead of `find`
- `eza` instead of `ls`
- `sd` instead of `sed` — syntax: `sd 'pattern' 'replacement' file`
- `delta` — configured as git pager (no action needed, git uses it automatically)
- `difft` — structural diff by AST: `difft file1 file2`
- `ast-grep` — structural code search/refactor by AST: `ast-grep -p 'pattern' --lang tsx`
- `shellcheck` — validate shell scripts before execution: `shellcheck script.sh`
- `scc` — codebase stats (languages, lines, complexity): `scc .`
- Editor: `nvim`

## Tool Usage Rules
- For shell script generation, run `shellcheck` to validate before suggesting execution.
- For multi-file refactoring, prefer `ast-grep` over regex-based `rg` + `sd`.
- To understand project structure, run `scc .` before planning large changes.
- Never use `cat`, `grep`, `find`, `ls`, `sed` system commands. Always use the modern alternatives above.
