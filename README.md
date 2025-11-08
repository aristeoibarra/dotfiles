# Dotfiles

My personal dotfiles for macOS.

## Tools

- **[Neovim](https://neovim.io/)** - Modern and extensible text editor
- **[Alacritty](https://alacritty.org/)** - GPU-accelerated terminal emulator
- **[Yabai](https://github.com/koekeishiya/yabai)** - Tiling window manager for macOS
- **[skhd](https://github.com/koekeishiya/skhd)** - Hotkey daemon for macOS
- **[Tmux](https://github.com/tmux/tmux)** - Terminal multiplexer
- **[Zsh](https://www.zsh.org/)** - Shell with standalone plugins (no Oh My Zsh), autosuggestions, and fzf integration

## Structure

```
dotfiles/
├── nvim/          # Neovim configuration
├── alacritty/     # Alacritty configuration
├── yabai/         # Yabai configuration
├── skhd/          # skhd configuration
├── tmux/          # Tmux configuration (pure, no plugins)
│   └── .tmux.conf
├── zsh/           # Zsh configuration (no Oh My Zsh)
│   └── .zshrc
├── macos/         # macOS system optimizations
│   ├── disable-animations.sh
│   └── enable-animations.sh
├── install.sh     # Installation script
└── README.md      # This file
```

## Installation

### Option 1: Full installation

```bash
# Clone the repository
git clone https://github.com/your-username/dotfiles.git ~/dotfiles

# Run installation script
cd ~/dotfiles
./install.sh
```

The `install.sh` script does the following:
- Creates backups of your existing configurations (if they exist)
- Creates symlinks from `~/.config/` to `~/dotfiles/`
- Preserves your previous configurations with `.backup` extension

### Option 2: Manual installation

If you prefer to install manually:

```bash
# Create backups (optional)
mv ~/.config/nvim ~/.config/nvim.backup
mv ~/.config/alacritty ~/.config/alacritty.backup
mv ~/.zshrc ~/.zshrc.backup
# ... etc

# Create symlinks
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/alacritty ~/.config/alacritty
ln -sf ~/dotfiles/yabai ~/.config/yabai
ln -sf ~/dotfiles/skhd ~/.config/skhd
ln -sf ~/dotfiles/tmux/.tmux.conf ~/.tmux.conf
ln -sf ~/dotfiles/zsh/.zshrc ~/.zshrc
```

## Updating

After cloning or updating the repository:

```bash
cd ~/dotfiles
git pull
```

Since we use symlinks, changes are reflected automatically.

## Philosophy

**Ultraminimalist setup:**
- ⚡ Speed over aesthetics
- ⌨️ Keyboard over mouse
- 🎯 Function over features
- 🧘 Zero distractions
- 🔧 Pure config over plugins

## Notes

- Configurations optimized for macOS
- No Oh My Zsh (standalone plugins via Homebrew)
- No Tmux plugins (pure configuration)
- Yabai requires partially disabling SIP on macOS
- Optional: Disable macOS animations with `bash ~/dotfiles/macos/disable-animations.sh`

## Prerequisites

```bash
# Install Homebrew (if you don't have it)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install core tools
brew install neovim
brew install --cask alacritty
brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd
brew install tmux

# Install Zsh plugins (standalone, no Oh My Zsh)
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting

# Install fzf (fuzzy finder)
brew install fzf
$(brew --prefix)/opt/fzf/install

# Install fd (for better fzf performance)
brew install fd

# Install lazygit (optional, for git TUI)
brew install lazygit

# Optional: Disable macOS animations
bash ~/dotfiles/macos/disable-animations.sh
```

## License

MIT
