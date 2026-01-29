# Dotfiles

My personal dotfiles for macOS, optimized for a keyboard-centric, minimal development workflow.

## Tools

### Core

- **[Neovim](https://neovim.io/)** - Modern extensible text editor with Lua configuration and Lazy.nvim plugin manager
- **[Alacritty](https://alacritty.org/)** - GPU-accelerated terminal emulator
- **[Ghostty](https://ghostty.org/)** - Fast, native terminal emulator (alternative)
- **[Yabai](https://github.com/koekeishiya/yabai)** - Tiling window manager for macOS
- **[skhd](https://github.com/koekeishiya/skhd)** - Hotkey daemon for macOS
- **[Tmux](https://github.com/tmux/tmux)** - Terminal multiplexer with TPM plugins
- **[Zsh](https://www.zsh.org/)** - Shell with standalone plugins (no Oh My Zsh)
- **[Starship](https://starship.rs/)** - Fast, customizable shell prompt

### Browser

- **[Zen Browser](https://zen-browser.app/)** - Privacy-focused Firefox fork with Betterfox configuration

### Optional

- **[VS Code](https://code.visualstudio.com/)** - Secondary editor with Kanagawa theme and 18+ extensions
- **[OpenCode](https://github.com/opencode-ai/opencode)** - Code assistant with MCP integration
- **[Warp](https://www.warp.dev/)** - Modern terminal with AI features and Kanagawa theme
- **[Mole](https://github.com/tw93/mole)** - macOS cleanup and optimization tool

## Theme

All tools use the **Kanagawa** color scheme with three variants:

- **Dragon** (default) - Dark, warm tones
- **Wave** - Dark blue tones
- **Lotus** - Light theme

Switch themes across all tools with:

```bash
~/dotfiles/bin/theme dragon  # or wave, lotus
```

This synchronizes colors in Neovim, Starship, Tmux, Alacritty, Ghostty, and FZF.

## Structure

```
dotfiles/
├── nvim/                      # Neovim configuration
│   ├── init.lua               # Entry point
│   └── lua/
│       ├── config/            # Core settings (options, keymaps, autocmds)
│       └── plugins/           # 38+ plugin configurations
│
├── alacritty/                 # Terminal emulator
│   ├── alacritty.toml         # Main config
│   └── kanagawa-*.toml        # Theme variants
│
├── ghostty/                   # Alternative terminal
│   └── config                 # Kanagawa Dragon theme
│
├── yabai/                     # Tiling window manager
│   └── yabairc                # Stack layout, padding, app exclusions
│
├── skhd/                      # Hotkey daemon
│   └── skhdrc                 # Window navigation and management
│
├── tmux/                      # Terminal multiplexer
│   ├── .tmux.conf             # Config with plugins
│   └── tmux-swap-and-follow.sh
│
├── zsh/                       # Shell configuration
│   └── .zshrc                 # Plugins, FZF, Vi mode, aliases
│
├── starship/                  # Shell prompt
│   └── starship.toml          # Kanagawa theme with git/node info
│
├── vscode/                    # VS Code (optional)
│   ├── settings.json          # Editor settings
│   ├── keybindings.json       # Custom bindings
│   └── extensions.txt         # Extension list
│
├── warp/                      # Warp terminal (optional)
│   └── themes/
│       └── kanagawa-dragon.yaml
│
├── zen/                       # Zen Browser
│   ├── user.js                # Betterfox configuration
│   └── chrome/
│       └── userChrome.css     # UI customizations
│
├── opencode/                  # Code assistant
│   └── opencode.json          # Theme and MCP config
│
├── mole/                      # macOS cleanup tool
│   └── README.md              # Installation and commands
│
├── bin/                       # Utility scripts
│   └── theme                  # Theme switcher
│
├── macos/                     # macOS optimizations
│   ├── disable-animations.sh  # Remove all UI animations
│   ├── enable-animations.sh   # Restore animations
│   └── optimize-display.sh    # 27" monitor optimization
│
├── install.sh                 # Installation with validation
├── restore.sh                 # Restore from backups
├── uninstall.sh               # Remove symlinks
└── README.md
```

## Key Bindings

### Yabai/skhd (Window Management)

| Binding | Action |
|---------|--------|
| `Alt + h/j/k/l` | Focus window left/down/up/right |
| `Shift + Alt + h/j/k/l` | Swap window in direction |
| `Shift + Cmd + h/j/k/l` | Resize window |
| `Alt + f` | Toggle fullscreen |
| `Alt + e` | Balance windows |
| `Alt + m` | Toggle layout (stack/bsp) |
| `Alt + w` | Close window |
| `Shift + Alt + r` | Restart yabai and skhd |

### Tmux

| Binding | Action |
|---------|--------|
| `Ctrl + Space` | Prefix key |
| `Prefix + c` | New window |
| `Prefix + v` | Vertical split |
| `Prefix + h` | Horizontal split |
| `Alt + 1-9` | Switch to window |
| `Prefix + g` | Floating scratch terminal |
| `Prefix + [` | Copy mode (vi keys) |

### Neovim

| Binding | Action |
|---------|--------|
| `Space` | Leader key |
| `Leader + ff` | Find files (Telescope) |
| `Leader + fg` | Live grep |
| `Leader + e` | File explorer |
| `gd` | Go to definition |
| `K` | Hover documentation |
| `Leader + ca` | Code actions |
| `Leader + rn` | Rename symbol |

## Installation

### Quick Start (Automatic)

```bash
# Clone and install everything
git clone https://github.com/aristeoibarra/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --install-deps
```

This installs all dependencies with Homebrew and creates symlinks.

### Manual Prerequisites

If you prefer to install dependencies manually:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Core tools
brew install neovim tmux zsh starship
brew install koekeishiya/formulae/yabai koekeishiya/formulae/skhd

# Terminals (at least one)
brew install --cask alacritty ghostty

# Modern CLI tools (required)
brew install bat ripgrep fd eza fzf zoxide lazygit jq

# Zsh plugins
brew install zsh-autosuggestions zsh-syntax-highlighting

# Nerd Font
brew install --cask font-jetbrains-mono-nerd-font

# FZF key bindings
$(brew --prefix)/opt/fzf/install

# Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Dependencies

| Category | Tools |
|----------|-------|
| Core | nvim, tmux, zsh, yabai, skhd |
| Terminals | alacritty, ghostty |
| CLI Tools | bat, rg, fd, eza, fzf, zoxide, lazygit, jq, starship |
| Zsh Plugins | zsh-autosuggestions, zsh-syntax-highlighting |
| Fonts | JetBrainsMono Nerd Font |
| Tmux | TPM (Tmux Plugin Manager) |
| Optional | VS Code |

### Yabai SIP Configuration

Yabai requires partially disabling System Integrity Protection:

1. Boot into Recovery Mode:
   - Apple Silicon: Hold power button until "Loading startup options"
   - Intel: Hold `Cmd + R` during boot

2. Open Terminal and run:
   ```bash
   csrutil enable --without debug --without fs
   ```

3. Reboot and configure sudoers:
   ```bash
   echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
   ```

4. Start services:
   ```bash
   yabai --start-service
   skhd --start-service
   ```

### Install Dotfiles

```bash
git clone https://github.com/aristeoibarra/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

The installer:
- Validates all dependencies (core, terminals, CLI tools, plugins)
- Creates backups of existing configs (`.backup` files)
- Creates symlinks to `~/.config/`
- Installs VS Code extensions (if VS Code is installed)
- Installs Warp theme to `~/.warp/themes/`

**Options:**

| Flag | Description |
|------|-------------|
| `--install-deps` | Install all dependencies with Homebrew |
| `--dry-run` | Preview changes without applying |
| `--skip-validation` | Skip dependency check (not recommended) |

```bash
# Full automatic setup
./install.sh --install-deps

# Preview what will be installed
./install.sh --dry-run

# Install without checking dependencies
./install.sh --skip-validation
```

## Updating

```bash
cd ~/dotfiles
git pull
```

Since we use symlinks, changes are reflected automatically.

## macOS Optimizations

```bash
# Disable all UI animations (instant window management)
bash ~/dotfiles/macos/disable-animations.sh

# Optimize for 27" 1080p display
bash ~/dotfiles/macos/optimize-display.sh

# Restore animations
bash ~/dotfiles/macos/enable-animations.sh
```

## Philosophy

**Ultraminimalist setup:**

- Speed over aesthetics
- Keyboard over mouse
- Function over features
- Zero distractions
- Pure config over plugins

### Design Decisions

**Why Neovim?**
- 50ms startup (vs 2-3s for VS Code)
- Modal editing, less hand movement
- Runs in terminal, integrates with tmux
- 50MB memory (vs 500MB+)

**Why Alacritty/Ghostty?**
- GPU-accelerated, smooth scrolling
- Minimal config, zero bloat
- No tabs/splits (tmux handles this)

**Why Yabai?**
- True tiling (like i3 for macOS)
- Fully keyboard-driven
- Zero UI distractions

**Why Zsh without Oh My Zsh?**
- OMZ adds 200ms+ startup time
- Standalone plugins via Homebrew are faster
- More control, easier debugging

**Why Tmux with plugins?**
- Session persistence (resurrect)
- Vim navigation integration
- Kanagawa theme consistency

## Restoring Previous Configuration

```bash
./restore.sh
```

This restores all backed-up configurations from `.backup` files.

## Uninstalling

```bash
./uninstall.sh
```

Removes symlinks but preserves backups. Run `./restore.sh` to restore previous configuration.

**Options:**

| Flag | Description |
|------|-------------|
| `--remove-deps` | Also uninstall CLI tools (bat, fd, eza, fzf, etc.) |

```bash
# Remove symlinks only
./uninstall.sh

# Remove symlinks and CLI tools
./uninstall.sh --remove-deps
```

Note: Core tools (neovim, tmux, yabai, skhd) and terminals are NOT removed automatically.

## Troubleshooting

### Neovim

```bash
# Sync plugins
nvim +:Lazy sync

# Clean install
rm -rf ~/.local/share/nvim && nvim +:Lazy sync

# Install LSP servers
nvim +:Mason

# Authenticate Copilot
nvim +:Copilot auth
```

### Yabai/skhd

```bash
# Check scripting addition
yabai --check-sa

# Restart services
yabai --restart-service
skhd --restart-service

# Grant Accessibility permissions in System Settings > Privacy & Security
```

### Tmux

```bash
# Reload config
tmux source ~/.tmux.conf

# Install plugins (prefix + I)
```

### Fonts/Colors

```bash
# Install Nerd Fonts
brew install --cask font-jetbrains-mono-nerd-font

# Check terminal color support
echo $TERM  # Should be: xterm-256color or alacritty
```

## License

MIT
