#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}Restoring dotfiles from backups...${NC}\n"

CONFIG_DIR="$HOME/.config"

# Function to restore from backup
restore_backup() {
    local backup_path="$1"
    local target_path="$2"
    local name="$3"

    if [ ! -e "$backup_path" ]; then
        echo -e "${YELLOW}✗ Backup not found: $backup_path${NC}"
        return 1
    fi

    # Remove current symlink/file
    if [ -L "$target_path" ] || [ -e "$target_path" ]; then
        echo -e "${YELLOW}Removing current: $target_path${NC}"
        rm -rf "$target_path"
    fi

    # Restore backup
    if ! mv "$backup_path" "$target_path"; then
        echo -e "${RED}✗ Error restoring: $name${NC}"
        return 1
    fi

    echo -e "${GREEN}✓${NC} Restored $name"
    return 0
}

# Check for backups and prompt user
echo -e "${BLUE}Searching for backups...${NC}"

backups_found=0

# Check each configuration
configs=(
    "$CONFIG_DIR/nvim.backup:$CONFIG_DIR/nvim:Neovim"
    "$CONFIG_DIR/alacritty.backup:$CONFIG_DIR/alacritty:Alacritty"
    "$CONFIG_DIR/yabai.backup:$CONFIG_DIR/yabai:Yabai"
    "$CONFIG_DIR/skhd.backup:$CONFIG_DIR/skhd:skhd"
    "$HOME/.tmux.conf.backup:$HOME/.tmux.conf:Tmux"
    "$HOME/.zshrc.backup:$HOME/.zshrc:Zsh"
)

for config in "${configs[@]}"; do
    IFS=':' read -r backup_path target_path name <<< "$config"
    if [ -e "$backup_path" ]; then
        echo -e "${GREEN}  ✓${NC} Found backup: $name"
        ((backups_found++))
    fi
done

if [ $backups_found -eq 0 ]; then
    echo -e "\n${YELLOW}No backups found.${NC}"
    echo -e "${BLUE}Backup files should be located at:${NC}"
    echo -e "  ~/.config/nvim.backup"
    echo -e "  ~/.config/alacritty.backup"
    echo -e "  ~/.config/yabai.backup"
    echo -e "  ~/.config/skhd.backup"
    echo -e "  ~/.tmux.conf.backup"
    echo -e "  ~/.zshrc.backup"
    exit 1
fi

echo -e "\n${YELLOW}Found $backups_found backup(s).${NC}"
echo -e "${RED}WARNING: This will remove current dotfiles and restore from backups.${NC}"
read -p "Do you want to continue? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Restore cancelled.${NC}"
    exit 0
fi

echo -e "\n${BLUE}Restoring configurations...${NC}"

# Restore each configuration
for config in "${configs[@]}"; do
    IFS=':' read -r backup_path target_path name <<< "$config"
    if [ -e "$backup_path" ]; then
        restore_backup "$backup_path" "$target_path" "$name"
    fi
done

echo -e "\n${GREEN}✓ Restore complete!${NC}"
echo -e "${BLUE}Next steps:${NC}"
echo -e "  1. Restart your terminal or run: source ~/.zshrc"
echo -e "  2. Restart services: yabai --restart-service && skhd --restart-service"
