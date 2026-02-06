# Claude Code - Termux Configuration

## Language
- Code, variables, commits: always in English
- Explanations and conversation: Spanish (direct style)

## Response Style
- Be concise. Don't explain the obvious.
- If something is important, mention why in one line.
- No emojis or motivational phrases.
- Get to the point.

## Preferred Tools
Use modern tools (guard with `command -v`, may not be installed):
- `bat` instead of `cat`
- `rg` instead of `grep`
- `fd` instead of `find`
- Editor: `nvim`
- Package manager: `pkg` (not `apt` or `brew`)
- Clipboard: `termux-clipboard-set` / `termux-clipboard-get`
- Paths use `$PREFIX`, not `/usr/local`
