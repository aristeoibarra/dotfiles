#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${RED}Uninstalling dotfiles...${NC}\n"

CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

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

# Warn user
echo -e "${YELLOW}This will remove all dotfiles symlinks.${NC}"
echo -e "${BLUE}Your backup files (.backup) will NOT be touched.${NC}"
echo -e "${RED}WARNING: This will NOT restore your previous configurations.${NC}"
echo -e "${BLUE}Run ./restore.sh after this to restore from backups.${NC}\n"

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
remove_symlink "$CONFIG_DIR/yabai" "Yabai"
remove_symlink "$CONFIG_DIR/skhd" "skhd"
remove_symlink "$HOME/.tmux.conf" "Tmux"
remove_symlink "$HOME/.zshrc" "Zsh"

echo -e "\n${GREEN}✓ Uninstall complete!${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. If you have backups, run: ./restore.sh"
echo -e "  2. Restart your terminal or run: exec zsh"
echo -e "  3. Restart services: yabai --stop-service && skhd --stop-service"
