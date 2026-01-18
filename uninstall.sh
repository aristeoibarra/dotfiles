#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse arguments
REMOVE_DEPS=false

for arg in "$@"; do
    case $arg in
        --remove-deps)
            REMOVE_DEPS=true
            ;;
    esac
done

echo -e "${RED}Uninstalling dotfiles...${NC}\n"

CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# =============================================================================
# DEPENDENCIES (same as install.sh)
# =============================================================================

# Core (required)
CORE_DEPS=("nvim" "tmux" "zsh" "yabai" "skhd")

# Terminals
TERMINAL_DEPS=("alacritty" "ghostty")

# Modern CLI tools
CLI_DEPS=("bat" "rg" "fd" "eza" "fzf" "zoxide" "lazygit" "jq" "starship")

# Zsh plugins
ZSH_PLUGINS=("zsh-autosuggestions" "zsh-syntax-highlighting")

# Fonts
FONTS=("font-jetbrains-mono-nerd-font")

# Homebrew packages mapping (command:brew_package)
get_brew_package() {
    case "$1" in
        nvim) echo "neovim" ;;
        tmux) echo "tmux" ;;
        zsh) echo "zsh" ;;
        yabai) echo "yabai" ;;
        skhd) echo "skhd" ;;
        alacritty) echo "alacritty" ;;
        ghostty) echo "ghostty" ;;
        bat) echo "bat" ;;
        rg) echo "ripgrep" ;;
        fd) echo "fd" ;;
        eza) echo "eza" ;;
        fzf) echo "fzf" ;;
        zoxide) echo "zoxide" ;;
        lazygit) echo "lazygit" ;;
        jq) echo "jq" ;;
        starship) echo "starship" ;;
        *) echo "$1" ;;
    esac
}

# Function to remove symlink
remove_symlink() {
    local target_path="$1"
    local name="$2"

    if [ ! -L "$target_path" ]; then
        echo -e "${YELLOW}✗ Not a symlink or doesn't exist: $name${NC}"
        return 1
    fi

    # Check if it points to our dotfiles
    local link_target=$(readlink "$target_path")
    if [[ "$link_target" != "$DOTFILES_DIR"* ]]; then
        echo -e "${YELLOW}✗ Symlink doesn't point to dotfiles repo: $name${NC}"
        echo -e "  Points to: $link_target"
        return 1
    fi

    # Remove symlink
    if ! rm "$target_path"; then
        echo -e "${RED}✗ Error removing symlink: $name${NC}"
        return 1
    fi

    echo -e "${GREEN}✓${NC} Removed $name"
    return 0
}

# Function to remove dependencies
remove_dependencies() {
    echo -e "\n${RED}Removing dependencies with Homebrew...${NC}\n"

    # Remove CLI tools
    echo -e "${BLUE}Removing CLI tools...${NC}"
    for dep in "${CLI_DEPS[@]}"; do
        if command -v "$dep" &> /dev/null; then
            echo -e "  Removing $(get_brew_package "$dep")..."
            brew uninstall "$(get_brew_package "$dep")" 2>/dev/null && \
                echo -e "${GREEN}  ✓${NC} $dep removed" || \
                echo -e "${YELLOW}  ⚠${NC} $dep (failed or has dependents)"
        fi
    done

    # Remove Zsh plugins
    echo -e "\n${BLUE}Removing Zsh plugins...${NC}"
    for plugin in "${ZSH_PLUGINS[@]}"; do
        if [ -f "/opt/homebrew/share/$plugin/$plugin.zsh" ]; then
            echo -e "  Removing $plugin..."
            brew uninstall "$plugin" 2>/dev/null && \
                echo -e "${GREEN}  ✓${NC} $plugin removed" || \
                echo -e "${YELLOW}  ⚠${NC} $plugin (failed)"
        fi
    done

    # Remove TPM
    echo -e "\n${BLUE}Removing Tmux Plugin Manager...${NC}"
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        rm -rf "$HOME/.tmux/plugins" && \
            echo -e "${GREEN}  ✓${NC} TPM removed" || \
            echo -e "${RED}  ✗${NC} TPM (failed)"
    fi

    echo -e "\n${YELLOW}Note: Core dependencies (neovim, tmux, yabai, skhd) were NOT removed.${NC}"
    echo -e "${YELLOW}Note: Terminals (alacritty, ghostty) were NOT removed.${NC}"
    echo -e "${YELLOW}Note: Fonts were NOT removed.${NC}"
    echo -e "${BLUE}To remove them manually:${NC}"
    echo -e "  brew uninstall neovim tmux yabai skhd"
    echo -e "  brew uninstall --cask alacritty ghostty"
    echo -e "  brew uninstall --cask font-jetbrains-mono-nerd-font"
}

# Warn user
echo -e "${YELLOW}This will remove all dotfiles symlinks.${NC}"
echo -e "${BLUE}Your backup files (.backup) will NOT be touched.${NC}"
echo -e "${RED}WARNING: This will NOT restore your previous configurations.${NC}"
echo -e "${BLUE}Run ./restore.sh after this to restore from backups.${NC}\n"

if [ "$REMOVE_DEPS" = true ]; then
    echo -e "${RED}WARNING: --remove-deps flag detected.${NC}"
    echo -e "${RED}This will also uninstall CLI tools (bat, fd, eza, fzf, etc.)${NC}\n"
fi

read -p "Do you want to continue? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Uninstall cancelled.${NC}"
    exit 0
fi

echo -e "\n${BLUE}Removing symlinks...${NC}"

# Remove each configuration
remove_symlink "$CONFIG_DIR/nvim" "Neovim"
remove_symlink "$CONFIG_DIR/alacritty" "Alacritty"
remove_symlink "$CONFIG_DIR/ghostty" "Ghostty"
remove_symlink "$CONFIG_DIR/yabai" "Yabai"
remove_symlink "$CONFIG_DIR/skhd" "skhd"
remove_symlink "$CONFIG_DIR/starship.toml" "Starship"
remove_symlink "$HOME/.tmux.conf" "Tmux"
remove_symlink "$HOME/.tmux/tmux-swap-and-follow.sh" "Tmux swap script"
remove_symlink "$HOME/.zshrc" "Zsh"

# Remove VS Code symlinks
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
remove_symlink "$VSCODE_USER_DIR/settings.json" "VS Code settings"
remove_symlink "$VSCODE_USER_DIR/keybindings.json" "VS Code keybindings"

# Remove Warp theme
remove_symlink "$HOME/.warp/themes/kanagawa-dragon.yaml" "Warp theme"

# Remove dependencies if requested
if [ "$REMOVE_DEPS" = true ]; then
    remove_dependencies
fi

echo -e "\n${GREEN}✓ Uninstall complete!${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. If you have backups, run: ./restore.sh"
echo -e "  2. Restart your terminal or run: exec zsh"
echo -e "  3. Stop services: yabai --stop-service && skhd --stop-service"
