# Dotfiles

My personal dotfiles for macOS.

## Tools

- **[Neovim](https://neovim.io/)** - Modern and extensible text editor
- **[Alacritty](https://alacritty.org/)** - GPU-accelerated terminal emulator
- **[Ghostty](https://ghostty.org/)** - Fast, native terminal emulator
- **[Yabai](https://github.com/koekeishiya/yabai)** - Tiling window manager for macOS
- **[skhd](https://github.com/koekeishiya/skhd)** - Hotkey daemon for macOS
- **[Tmux](https://github.com/tmux/tmux)** - Terminal multiplexer
- **[Zsh](https://www.zsh.org/)** - Shell with standalone plugins (no Oh My Zsh), autosuggestions, and fzf integration

## Structure

```
dotfiles/
├── nvim/          # Neovim configuration
├── alacritty/     # Alacritty configuration
├── ghostty/       # Ghostty configuration
├── yabai/         # Yabai configuration
├── skhd/          # skhd configuration
├── tmux/          # Tmux configuration
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
git clone https://github.com/aristeoibarra/dotfiles.git ~/dotfiles

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
ln -sf ~/dotfiles/ghostty ~/.config/ghostty
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

### Design Decisions

**Why Neovim over VSCode?**
- Instant startup time (~50ms vs 2-3s)
- Runs in terminal (integrates with tmux workflow)
- Modal editing = less hand movement, more speed
- Infinite customization with Lua
- Lower memory footprint (~50MB vs 500MB+)

**Why Alacritty over iTerm2/Kitty?**
- GPU-accelerated (consistently smooth scrolling)
- Minimal config file (TOML, not XML/JSON)
- Cross-platform (Linux/macOS/Windows)
- No tabs/splits (tmux handles this better)
- Zero bloat, zero menus

**Why Yabai over Rectangle/Amethyst?**
- True tiling window manager (like i3 for macOS)
- Fully keyboard-driven (no clicking)
- Binary Space Partitioning layout
- Scriptable with shell commands
- Zero UI, zero distractions

**Why Tmux without plugins?**
- Pure configuration is stable (plugins break)
- Faster startup without plugin manager
- Less maintenance overhead
- Built-in features are enough for most use cases
- No external dependencies

**Why Zsh without Oh My Zsh?**
- OMZ adds 200ms+ startup time
- Standalone plugins via Homebrew are faster
- More control over what loads
- Easier to debug issues
- Less magic, more transparency

**Why this stack for web development?**
- Optimized for React/Next.js/TypeScript workflow
- LSP provides IDE-like features in terminal
- Copilot + Claude = dual AI assistance
- Format on save with Prettier + ESLint
- Tailwind intellisense with custom class regex
- Fast feedback loop (no context switching)

## Restoring Previous Configuration

If you need to restore your previous dotfiles:

```bash
cd ~/dotfiles
./restore.sh
```

This will restore all backed-up configurations from `.backup` files.

## Notes

- Configurations optimized for macOS
- No Oh My Zsh (standalone plugins via Homebrew)
- No Tmux plugins (pure configuration)
- **Yabai requires partially disabling SIP** (see Prerequisites below)
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

### Disabling SIP for Yabai (Required)

Yabai requires **partially disabling System Integrity Protection (SIP)** to enable window management features with instant animations.

**IMPORTANT:** Only disable the specific SIP features needed, not the entire protection.

#### Steps to Disable SIP (Partially)

1. **Reboot into Recovery Mode:**
   - **Apple Silicon (M1/M2/M3):** Shut down your Mac, then press and hold the power button until "Loading startup options" appears. Click Options, then Continue.
   - **Intel Mac:** Restart and hold `Cmd + R` during boot.

2. **Open Terminal** from the Utilities menu in Recovery Mode.

3. **Disable only debug assertions** (required for yabai):
   ```bash
   csrutil enable --without debug --without fs
   ```

4. **Reboot your Mac** normally.

5. **Verify SIP status:**
   ```bash
   csrutil status
   ```

   You should see something like:
   ```
   System Integrity Protection status: unknown (Custom Configuration).

   Configuration:
       Apple Internal: enabled
       Kext Signing: enabled
       Filesystem Protections: disabled
       Debugging Restrictions: disabled
       ...
   ```

6. **Load yabai scripting addition** (one-time setup):
   ```bash
   echo "$(whoami) ALL=(root) NOPASSWD: sha256:$(shasum -a 256 $(which yabai) | cut -d " " -f 1) $(which yabai) --load-sa" | sudo tee /private/etc/sudoers.d/yabai
   ```

7. **Start yabai service:**
   ```bash
   yabai --start-service
   skhd --start-service
   ```

**Security Note:** This configuration maintains most SIP protections while allowing yabai to function. If you want to re-enable full SIP later, boot into Recovery Mode and run `csrutil enable`.

## Troubleshooting

### Neovim Issues

**Plugins not loading or errors on startup**
```bash
# Sync all plugins
nvim
:Lazy sync

# If that doesn't work, clean install
rm -rf ~/.local/share/nvim
nvim
:Lazy sync
```

**LSP not working (no autocomplete/errors)**
```bash
# Open Neovim and install LSP servers
nvim
:Mason

# Press 'i' to install missing servers
# Or run: :MasonInstall typescript-language-server html-language-server
```

**Copilot not working**
```bash
# Authenticate with GitHub
nvim
:Copilot auth

# Follow the browser authentication flow
```

### Yabai/Window Management Issues

**Yabai not tiling windows**
```bash
# Check if yabai is running
yabai --check-sa

# If it fails, you likely need to disable SIP (see Prerequisites)
# Restart yabai
yabai --restart-service
```

**skhd keybindings not working**
```bash
# Restart skhd
skhd --restart-service

# Check if it's running
ps aux | grep skhd

# Grant Accessibility permissions in System Settings > Privacy & Security
```

### Tmux Issues

**Tmux not starting automatically**
```bash
# Check if tmux is installed
which tmux

# Reload zsh config
source ~/.zshrc

# If auto-attach is annoying in SSH, it's already disabled for SSH sessions
```

**Copy/paste not working in tmux**
```bash
# macOS clipboard integration requires reattach-to-user-namespace (optional)
brew install reattach-to-user-namespace

# Or use prefix + v to enter copy mode, then y to copy
```

### Terminal Issues

**Fonts look broken (squares/missing icons)**
```bash
# Install Nerd Fonts
brew install --cask font-jetbrains-mono-nerd-font

# Restart Alacritty
# Check Alacritty config: alacritty/alacritty.toml
```

**Colors look wrong**
```bash
# Make sure your terminal supports true color
# Alacritty does by default

# Check if $TERM is set correctly
echo $TERM  # Should be: xterm-256color or alacritty
```

### Installation Issues

**Dependencies missing after install**
```bash
# The installer now validates dependencies and will stop if something is missing
# Install missing dependencies, then run ./install.sh again

# To bypass validation (not recommended):
./install.sh --skip-validation
```

**Symlinks not created**
```bash
# Check if ~/.config exists
ls -la ~/.config

# Run installer again (it will backup existing configs)
./install.sh
```

**Want to go back to previous config**
```bash
# Restore from backups
./restore.sh

# Or manually
mv ~/.config/nvim.backup ~/.config/nvim
# etc...
```

## Uninstalling

To remove these dotfiles:

```bash
cd ~/dotfiles
./uninstall.sh
```

This will remove all symlinks but preserve your backups. Run `./restore.sh` afterwards to restore your previous configuration.

## License

MIT
