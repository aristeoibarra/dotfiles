#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Parse arguments
DRY_RUN=false
SKIP_VALIDATION=false

for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            echo -e "${YELLOW}Running in DRY RUN mode (no changes will be made)${NC}\n"
            ;;
        --skip-validation)
            SKIP_VALIDATION=true
            ;;
    esac
done

echo -e "${BLUE}Installing dotfiles...${NC}\n"

CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Check dependencies
check_dependencies() {
    echo -e "${BLUE}Checking dependencies...${NC}"
    local missing=0

    local deps=("nvim" "alacritty" "yabai" "skhd" "tmux" "zsh")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${YELLOW}  Warning: $dep not found${NC}"
            ((missing++))
        else
            echo -e "${GREEN}  ✓${NC} $dep"
        fi
    done

    if [ $missing -gt 0 ]; then
        echo -e "\n${RED}ERROR: $missing dependencies missing.${NC}"
        echo -e "${BLUE}Install them with Homebrew:${NC}"
        echo -e "${BLUE}  brew install neovim tmux zsh${NC}"
        echo -e "${BLUE}  brew install --cask alacritty${NC}"
        echo -e "${BLUE}  brew install koekeishiya/formulae/yabai koekeishiya/formulae/skhd${NC}\n"

        if [ "$SKIP_VALIDATION" = false ]; then
            echo -e "${RED}Aborting installation.${NC}"
            echo -e "${YELLOW}Use --skip-validation to bypass this check (not recommended).${NC}\n"
            exit 1
        else
            echo -e "${YELLOW}Skipping validation as requested...${NC}\n"
        fi
    else
        echo -e "${GREEN}All dependencies found!${NC}\n"
    fi
}

# Create .config directory if it doesn't exist
create_config_dir() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY RUN]${NC} Would create: $CONFIG_DIR"
    else
        mkdir -p "$CONFIG_DIR"
    fi
}

# Function to create symlink with backup
create_symlink() {
    local source="$1"
    local target="$2"
    local name="$3"

    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY RUN]${NC} Would link: $source → $target"
        return 0
    fi

    if [ ! -e "$source" ]; then
        echo -e "${RED}✗ Error: Source not found: $source${NC}"
        return 1
    fi

    if [ -L "$target" ]; then
        echo -e "${YELLOW}Removing existing symlink: $target${NC}"
        rm "$target"
    elif [ -e "$target" ]; then
        echo -e "${YELLOW}Backing up existing $name to ${target}.backup${NC}"
        mv "$target" "${target}.backup"
    fi

    if ! ln -sf "$source" "$target"; then
        echo -e "${RED}✗ Error creating symlink: $name${NC}"
        return 1
    fi

    echo -e "${GREEN}✓${NC} Linked $name"
    return 0
}

# Run dependency check
check_dependencies

# Create config directory
create_config_dir

# Install configurations
echo -e "${BLUE}Creating symlinks...${NC}"
create_symlink "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim" "Neovim"
create_symlink "$DOTFILES_DIR/alacritty" "$CONFIG_DIR/alacritty" "Alacritty"
create_symlink "$DOTFILES_DIR/yabai" "$CONFIG_DIR/yabai" "Yabai"
create_symlink "$DOTFILES_DIR/skhd" "$CONFIG_DIR/skhd" "skhd"
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf" "Tmux"
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc" "Zsh"

if [ "$DRY_RUN" = true ]; then
    echo -e "\n${YELLOW}DRY RUN complete. Run without --dry-run to apply changes.${NC}"
else
    echo -e "\n${GREEN}✓ Dotfiles installed successfully!${NC}"
    echo -e "${BLUE}Next steps:${NC}"
    echo -e "  1. Restart your terminal or run: source ~/.zshrc"
    echo -e "  2. Open Neovim and run: :Lazy sync"
    echo -e "  3. Restart services: yabai --restart-service && skhd --restart-service"
fi
