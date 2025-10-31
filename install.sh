#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Installing dotfiles...${NC}\n"

CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$HOME/dotfiles"

# Create .config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local name="$3"

    if [ -L "$target" ]; then
        echo -e "${YELLOW}Removing existing symlink: $target${NC}"
        rm "$target"
    elif [ -e "$target" ]; then
        echo -e "${YELLOW}Backing up existing $name to ${target}.backup${NC}"
        mv "$target" "${target}.backup"
    fi

    ln -sf "$source" "$target"
    echo -e "${GREEN}✓${NC} Linked $name"
}

# Install configurations
create_symlink "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim" "Neovim"
create_symlink "$DOTFILES_DIR/alacritty" "$CONFIG_DIR/alacritty" "Alacritty"
create_symlink "$DOTFILES_DIR/yabai" "$CONFIG_DIR/yabai" "Yabai"
create_symlink "$DOTFILES_DIR/skhd" "$CONFIG_DIR/skhd" "skhd"
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf" "Tmux"
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc" "Zsh"

echo -e "\n${GREEN}✓ Dotfiles installed successfully!${NC}"
echo -e "${BLUE}Note: You may need to restart your terminal or reload configurations${NC}"
