# Neovim Configuration

Modular Neovim configuration optimized for web development (TypeScript/React/Tailwind).

## Structure

```
~/.config/nvim/
├── init.lua                    # Main entry point
├── lazy-lock.json             # Plugin version lockfile
├── lua/
│   ├── config/                # General configuration
│   │   ├── options.lua        # Neovim options
│   │   ├── keymaps.lua        # Keybindings
│   │   ├── autocmds.lua       # Autocommands
│   │   └── lazy.lua           # lazy.nvim bootstrap
│   └── plugins/               # Plugins organized by category
│       ├── ui.lua             # Theme, statusline, colorizer
│       ├── editor.lua         # Treesitter, autopairs, comments, which-key
│       ├── lsp.lua            # Mason, LSP servers
│       ├── completion.lua     # nvim-cmp, snippets
│       ├── formatting.lua     # conform.nvim (Prettier)
│       ├── navigation.lua     # Telescope, nvim-tree
│       ├── git.lua            # Gitsigns, LazyGit
│       ├── copilot.lua        # GitHub Copilot AI assistant
│       ├── claudecode.lua     # Claude Code AI assistant
│       ├── trouble.lua        # Error diagnostics list
│       ├── terminal.lua       # Integrated terminal
│       ├── dashboard.lua      # Custom start screen (Alpha)
│       └── session.lua        # Session management (persistence.nvim)
```

## Key Features

- **LSP**: TypeScript, JavaScript, HTML, CSS, Tailwind, JSON
- **AI Assistants**: GitHub Copilot (inline) + Claude Code (chat)
- **Git**: LazyGit TUI + Gitsigns inline
- **Terminal**: Integrated toggleable terminal
- **Theme**: Catppuccin Macchiato
- **Format on save**: Prettier
- **Error diagnostics**: Inline with Trouble list
- **Session management**: Auto-save/restore workspace state

## Main Keybindings

### General
- `<leader>` = Space
- `<leader>e` - Toggle file explorer
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>z` - Toggle Zen Mode

### Navigation (Telescope)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader>fb` - Find buffers
- `<leader>fh` - Help tags

### LSP
- `gd` - Go to definition
- `K` - Hover documentation
- `gi` - Go to implementation
- `gr` - Go to references
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `]d` / `[d` - Next/prev diagnostic

### Git
- `<leader>gg` - Open LazyGit
- `<leader>gf` - LazyGit current file
- `]h` / `[h` - Next/prev hunk
- `<leader>gp` - Preview hunk
- `<leader>gs` - Stage hunk
- `<leader>gr` - Reset hunk
- `<leader>gb` - Git blame line
- `<leader>gd` - Git diff

### Errors/Diagnostics
- `<leader>xx` - Toggle Trouble diagnostics
- `<leader>xX` - Trouble buffer diagnostics

### Terminal
- `Ctrl+\` - Toggle terminal
- `<leader>tf` - Floating terminal
- `<leader>th` - Horizontal terminal
- `<leader>tv` - Vertical terminal

### Splits
- `<leader>sh` - Horizontal split
- `<leader>sv` - Vertical split
- `Ctrl+h/j/k/l` - Navigate between splits

### AI Assistants

#### Copilot (inline suggestions)
- `Ctrl+J` - Accept suggestion
- `Alt+]` - Next suggestion
- `Alt+[` - Previous suggestion
- `Ctrl+x` - Dismiss suggestion

#### Claude Code (chat)
- `<leader>ac` - Toggle Claude Code
- `<leader>af` - Focus Claude window
- `<leader>ab` - Add current buffer to context
- `<leader>as` - Send selection to Claude (visual mode)
- `<leader>aa` - Accept diff
- `<leader>ad` - Deny diff

### Formatting
- `<leader>f` - Format file or selection

### Autocompletion
- `Tab` - Next suggestion
- `Shift+Tab` - Previous suggestion
- `Enter` - Confirm suggestion
- `Ctrl+Space` - Trigger completion

### Session Management
- `<leader>qs` - Restore session for current directory
- `<leader>ql` - Restore last session
- `<leader>qd` - Don't save current session on exit

## Adding New Plugins

1. Open the appropriate category file in `lua/plugins/`
2. Add plugin following lazy.nvim structure:

```lua
{
  "author/plugin-name",
  dependencies = { "dependency/plugin" }, -- Optional
  config = function()
    require("plugin").setup({
      -- options
    })
  end,
}
```

3. Restart Neovim - plugins auto-install

## Configuring New LSP Servers

Edit `lua/plugins/lsp.lua`:

1. Add server to `ensure_installed` in mason-lspconfig
2. Add configuration to `servers` table
3. Restart Neovim

Example:
```lua
ensure_installed = {
  "ts_ls",
  "rust_analyzer", -- new server
}

servers = {
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", ".git" },
  },
}
```

## Dashboard

When opening Neovim without a file (`nvim`):
- `e` - New file
- `f` - Find file
- `r` - Recent files
- `g` - Live grep
- `c` - Open config
- `l` - Open Lazy (plugin manager)
- `q` - Quit

## LazyGit

### Requirements
```bash
brew install lazygit
```

### Usage
- `<leader>gg` - Open LazyGit
- `?` - Show all keybindings (inside LazyGit)
- `q` - Close LazyGit

## Zen Mode

Distraction-free coding mode.

- `<leader>z` - Toggle Zen Mode
- Centered 120 column width
- Hides statusline and UI elements

## Which-key

Shows available commands automatically:
- Press `<leader>` and wait 300ms - see all leader commands
- Press `g` and wait - see all g commands
- Press `<leader>?` - show buffer-local keymaps

## Session Management

Sessions are **automatically saved** when you quit Neovim and **automatically restored** when you open Neovim in the same directory.

### How it works
- Sessions are saved per directory in `~/.local/state/nvim/sessions/`
- Saves: open buffers, window layout, cursor position, working directory
- Auto-saves on exit (unless you use `<leader>qd`)
- Auto-restores when opening `nvim` without arguments in a previously saved directory

### Usage
```bash
# Work on project A
cd ~/project-a
nvim
# Open files, configure layout...
# Close Neovim

# Work on project B
cd ~/project-b
nvim
# Different session, different files...

# Return to project A
cd ~/project-a
nvim
# ✅ Your project-a session is automatically restored!
```

### Manual controls
- `<leader>qs` - Manually restore session for current directory
- `<leader>ql` - Restore the very last session (regardless of directory)
- `<leader>qd` - Stop auto-saving (useful for temporary work)

## Pending Features

- 🖼️ **Image viewer** - Not yet implemented (Alacritty doesn't support inline images)

## Troubleshooting

### Plugins not loading
```bash
# Clear cache and reinstall
rm -rf ~/.local/share/nvim
rm -rf ~/.cache/nvim
nvim
```

### LSP not working
```bash
# Check Mason
:Mason

# Reinstall a server
:MasonUninstall ts_ls
:MasonInstall ts_ls
```

### Syntax errors
```bash
# Check configuration
nvim --headless "+lua print('OK')" +qa
```

## Update Plugins

```vim
:Lazy         " Open Lazy
:Lazy update  " Update all plugins
:checkhealth  " Check health
```
