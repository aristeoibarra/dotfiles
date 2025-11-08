# Neovim Configuration

Ultraminimalist Neovim configuration optimized for full-stack web development (React/Next.js/NestJS/TypeScript/Tailwind/Prisma).

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
│       ├── ui.lua             # Theme (Kanagawa)
│       ├── editor.lua         # Treesitter, autotag, autopairs, which-key
│       ├── lsp.lua            # Mason, LSP servers
│       ├── completion.lua     # nvim-cmp (LSP + path only)
│       ├── formatting.lua     # conform.nvim (Prettier, ESLint)
│       ├── navigation.lua     # Telescope, nvim-tree
│       ├── git.lua            # Gitsigns
│       ├── copilot.lua        # GitHub Copilot AI assistant
│       ├── claudecode.lua     # Claude Code AI assistant
│       ├── obsidian.lua       # Obsidian notes integration
│       ├── colorizer.lua      # Color highlighting (Tailwind)
│       └── snippets.lua       # Custom React/TypeScript snippets
```

## Key Features

- **LSP**: TypeScript, JavaScript, HTML, CSS, Tailwind, JSON, Prisma
- **AI Assistants**: GitHub Copilot (inline) + Claude Code (chat)
- **Git**: Gitsigns inline hunks
- **Theme**: Kanagawa Dragon (ultraminimal, no statusline)
- **Format on save**: Prettier + ESLint
- **Obsidian**: Integration with 2 vaults (personal + work)
- **Plugins**: 27 total, lazy-loaded for performance
- **Custom snippets**: React components (rfc, ust)

## Main Keybindings

### General
- `<leader>` = Space
- `<leader>e` - Toggle file explorer
- `<leader>ef` - Find file in tree
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader><leader>` - Toggle to last buffer
- `<leader>c` - Open keybindings cheatsheet
- `<leader>ch` - Open Vim cheatsheet

### Navigation (Telescope)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search content)
- `<leader>fb` - Find buffers
- `<leader>fc` - Find changed files (git)
- `<leader>fd` - Find diagnostics

### LSP
- `gd` - Go to definition
- `gv` - Go to definition (vertical split)
- `gs` - Go to definition (horizontal split)
- `K` - Hover documentation
- `gi` - Go to implementation
- `gr` - Go to references
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions
- `<leader>la` - Load all files (full project LSP scan)
- `]d` / `[d` - Next/prev diagnostic

### Diagnostics
- `<leader>d` - Diagnostics list (current buffer)
- `<leader>da` - All diagnostics (project)
- `<leader>D` - Show diagnostic details
- `]d` / `[d` - Next/prev diagnostic

### Git
- `]h` / `[h` - Next/prev hunk
- `<leader>hp` - Preview hunk
- `<leader>hs` - Stage hunk
- `<leader>hu` - Undo stage hunk
- `<leader>hr` - Reset hunk
- `<leader>hb` - Blame line
- `<leader>hd` - Diff this

### Formatting
- `<leader>f` - Format file or selection (manual)
- Auto-format on save enabled

### Splits
- `<leader>sh` - Horizontal split
- `<leader>sv` - Vertical split
- `Ctrl+h/j/k/l` - Navigate between splits
- `<leader>rh/j/k/l` - Resize splits

### UI Toggles
- `<leader>tn` - Toggle line numbers
- `<leader>tm` - Toggle mouse

### AI Assistants

#### Copilot (inline suggestions)
- `Ctrl+J` (insert mode) - Accept suggestion
- `Alt+]` - Next suggestion
- `Alt+[` - Previous suggestion
- `Ctrl+x` - Dismiss suggestion

#### Claude Code (chat)
- `<leader>ac` - Toggle Claude Code
- `<leader>af` - Focus Claude window
- `<leader>ab` - Add current buffer to context
- `<leader>aa` - Accept diff
- `<leader>ad` - Deny diff

### Obsidian Notes
- `<leader>of` - Find notes (quick switch)
- `<leader>os` - Search vault content
- `<leader>on` - New note
- `<leader>ow` - Switch workspace (aristeoibarra ↔ digiin)
- `gf` - Follow link under cursor

### Autocompletion
- `Tab` - Next suggestion
- `Shift+Tab` - Previous suggestion
- `Enter` - Confirm suggestion
- `Ctrl+Space` - Trigger completion

## Plugins (27 total)

### Core (5)
- lazy.nvim - Plugin manager
- plenary.nvim - Lua utilities
- nvim-web-devicons - Icons
- snacks.nvim - Utilities (required by claudecode)
- kanagawa.nvim - Theme

### LSP & Completion (7)
- mason.nvim - LSP installer
- mason-lspconfig.nvim - Bridge
- mason-tool-installer.nvim - Auto-install formatters
- nvim-lspconfig - LSP config
- nvim-cmp - Autocompletion
- cmp-nvim-lsp - LSP source
- cmp-path - Path source

### Snippets (2)
- LuaSnip - Snippet engine
- cmp_luasnip - Integration

### Navigation (3)
- telescope.nvim - Fuzzy finder
- telescope-fzf-native.nvim - FZF extension
- nvim-tree.lua - File explorer

### Editor (4)
- nvim-treesitter - Syntax highlighting
- nvim-ts-autotag - Auto-close HTML/JSX tags
- nvim-autopairs - Auto-close brackets
- which-key.nvim - Keybinding help

### Git (1)
- gitsigns.nvim - Git hunks inline

### Formatting (1)
- conform.nvim - Prettier + ESLint integration

### AI (2)
- copilot.vim - GitHub Copilot
- claudecode.nvim - Claude Code

### Utilities (2)
- nvim-colorizer.lua - Color preview (Tailwind colors)
- obsidian.nvim - Obsidian vault integration

## LSP Servers

Auto-installed via Mason:
- **ts_ls** - TypeScript/JavaScript
- **html** - HTML
- **cssls** - CSS
- **tailwindcss** - Tailwind CSS (with custom regex for cva/cx)
- **jsonls** - JSON
- **prismals** - Prisma

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

3. Restart Neovim - plugins auto-install via lazy.nvim

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

## Custom Snippets

Custom TypeScript/React snippets for faster development:

- **rfc** - React Functional Component
  ```tsx
  export default function Component() {
    return (
      <div>content</div>
    )
  }
  ```

- **ust** - useState hook
  ```tsx
  const [state, setState] = useState<string>('')
  ```

## Which-key

Shows available commands automatically:
- Press `<leader>` and wait 300ms - see all leader commands
- Press `g` and wait - see all g commands
- Press `<leader>?` - show buffer-local keymaps

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
