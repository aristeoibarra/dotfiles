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
INSTALL_DEPS=false

for arg in "$@"; do
    case $arg in
        --dry-run)
            DRY_RUN=true
            echo -e "${YELLOW}Running in DRY RUN mode (no changes will be made)${NC}\n"
            ;;
        --skip-validation)
            SKIP_VALIDATION=true
            ;;
        --install-deps)
            INSTALL_DEPS=true
            ;;
    esac
done

echo -e "${BLUE}Installing dotfiles...${NC}\n"

CONFIG_DIR="$HOME/.config"
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# =============================================================================
# DEPENDENCIES
# =============================================================================

# Core (required)
CORE_DEPS=("nvim" "tmux" "zsh" "yabai" "skhd")

# Terminals (at least one required)
TERMINAL_DEPS=("alacritty" "ghostty")

# Modern CLI tools (required for full functionality)
CLI_DEPS=("bat" "rg" "fd" "eza" "fzf" "zoxide" "lazygit" "jq" "starship")

# Optional
OPTIONAL_DEPS=("code")

# Homebrew packages mapping (command:brew_package)
get_brew_package() {
    case "$1" in
        nvim) echo "neovim" ;;
        tmux) echo "tmux" ;;
        zsh) echo "zsh" ;;
        yabai) echo "koekeishiya/formulae/yabai" ;;
        skhd) echo "koekeishiya/formulae/skhd" ;;
        alacritty) echo "--cask alacritty" ;;
        ghostty) echo "--cask ghostty" ;;
        bat) echo "bat" ;;
        rg) echo "ripgrep" ;;
        fd) echo "fd" ;;
        eza) echo "eza" ;;
        fzf) echo "fzf" ;;
        zoxide) echo "zoxide" ;;
        lazygit) echo "lazygit" ;;
        jq) echo "jq" ;;
        starship) echo "starship" ;;
        code) echo "--cask visual-studio-code" ;;
        *) echo "$1" ;;
    esac
}

# Zsh plugins (Homebrew)
ZSH_PLUGINS=("zsh-autosuggestions" "zsh-syntax-highlighting")

# Fonts
FONTS=("font-jetbrains-mono-nerd-font")

# Install dependencies with Homebrew
install_dependencies() {
    echo -e "${BLUE}Installing dependencies with Homebrew...${NC}\n"

    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}Homebrew not found. Install it first:${NC}"
        echo -e '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        exit 1
    fi

    # Tap cask-fonts for Nerd Fonts
    echo -e "${BLUE}Tapping homebrew/cask-fonts...${NC}"
    brew tap homebrew/cask-fonts 2>/dev/null

    # Install core dependencies
    echo -e "\n${BLUE}Installing core dependencies...${NC}"
    for dep in "${CORE_DEPS[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "  Installing $(get_brew_package "$dep")..."
            brew install $(get_brew_package "$dep") 2>/dev/null && \
                echo -e "${GREEN}  ✓${NC} $dep" || \
                echo -e "${RED}  ✗${NC} $dep (failed)"
        else
            echo -e "${GREEN}  ✓${NC} $dep (already installed)"
        fi
    done

    # Install terminals
    echo -e "\n${BLUE}Installing terminals...${NC}"
    for dep in "${TERMINAL_DEPS[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "  Installing $(get_brew_package "$dep")..."
            brew install $(get_brew_package "$dep") 2>/dev/null && \
                echo -e "${GREEN}  ✓${NC} $dep" || \
                echo -e "${YELLOW}  ⚠${NC} $dep (skipped)"
        else
            echo -e "${GREEN}  ✓${NC} $dep (already installed)"
        fi
    done

    # Install CLI tools
    echo -e "\n${BLUE}Installing CLI tools...${NC}"
    for dep in "${CLI_DEPS[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "  Installing $(get_brew_package "$dep")..."
            brew install $(get_brew_package "$dep") 2>/dev/null && \
                echo -e "${GREEN}  ✓${NC} $dep" || \
                echo -e "${RED}  ✗${NC} $dep (failed)"
        else
            echo -e "${GREEN}  ✓${NC} $dep (already installed)"
        fi
    done

    # Install Zsh plugins
    echo -e "\n${BLUE}Installing Zsh plugins...${NC}"
    for plugin in "${ZSH_PLUGINS[@]}"; do
        if [ ! -f "/opt/homebrew/share/$plugin/$plugin.zsh" ]; then
            echo -e "  Installing $plugin..."
            brew install "$plugin" 2>/dev/null && \
                echo -e "${GREEN}  ✓${NC} $plugin" || \
                echo -e "${RED}  ✗${NC} $plugin (failed)"
        else
            echo -e "${GREEN}  ✓${NC} $plugin (already installed)"
        fi
    done

    # Install fonts
    echo -e "\n${BLUE}Installing fonts...${NC}"
    for font in "${FONTS[@]}"; do
        echo -e "  Installing $font..."
        brew install --cask "$font" 2>/dev/null && \
            echo -e "${GREEN}  ✓${NC} $font" || \
            echo -e "${YELLOW}  ⚠${NC} $font (may already be installed)"
    done

    # Install TPM (Tmux Plugin Manager)
    echo -e "\n${BLUE}Installing Tmux Plugin Manager...${NC}"
    if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
        git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2>/dev/null && \
            echo -e "${GREEN}  ✓${NC} TPM installed" || \
            echo -e "${RED}  ✗${NC} TPM (failed)"
    else
        echo -e "${GREEN}  ✓${NC} TPM (already installed)"
    fi

    echo -e "\n${GREEN}Dependencies installed!${NC}\n"
}

# Check dependencies
check_dependencies() {
    echo -e "${BLUE}Checking dependencies...${NC}"
    local missing=0
    local missing_list=()

    # Check core
    echo -e "\n${BLUE}Core:${NC}"
    for dep in "${CORE_DEPS[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${RED}  ✗${NC} $dep"
            ((missing++))
            missing_list+=("$dep")
        else
            echo -e "${GREEN}  ✓${NC} $dep"
        fi
    done

    # Check terminals (at least one)
    echo -e "\n${BLUE}Terminals:${NC}"
    local terminal_found=false
    for dep in "${TERMINAL_DEPS[@]}"; do
        if command -v "$dep" &> /dev/null; then
            echo -e "${GREEN}  ✓${NC} $dep"
            terminal_found=true
        else
            echo -e "${YELLOW}  -${NC} $dep (optional)"
        fi
    done
    if [ "$terminal_found" = false ]; then
        echo -e "${RED}  ✗ No terminal found (install alacritty or ghostty)${NC}"
        ((missing++))
    fi

    # Check CLI tools
    echo -e "\n${BLUE}CLI Tools:${NC}"
    for dep in "${CLI_DEPS[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${RED}  ✗${NC} $dep"
            ((missing++))
            missing_list+=("$dep")
        else
            echo -e "${GREEN}  ✓${NC} $dep"
        fi
    done

    # Check Zsh plugins
    echo -e "\n${BLUE}Zsh Plugins:${NC}"
    for plugin in "${ZSH_PLUGINS[@]}"; do
        if [ -f "/opt/homebrew/share/$plugin/$plugin.zsh" ]; then
            echo -e "${GREEN}  ✓${NC} $plugin"
        else
            echo -e "${RED}  ✗${NC} $plugin"
            ((missing++))
        fi
    done

    # Check TPM
    echo -e "\n${BLUE}Tmux Plugins:${NC}"
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        echo -e "${GREEN}  ✓${NC} tpm (Tmux Plugin Manager)"
    else
        echo -e "${RED}  ✗${NC} tpm (Tmux Plugin Manager)"
        ((missing++))
    fi

    # Check optional
    echo -e "\n${BLUE}Optional:${NC}"
    for dep in "${OPTIONAL_DEPS[@]}"; do
        if command -v "$dep" &> /dev/null; then
            echo -e "${GREEN}  ✓${NC} $dep"
        else
            echo -e "${YELLOW}  -${NC} $dep"
        fi
    done

    if [ $missing -gt 0 ]; then
        echo -e "\n${RED}ERROR: $missing dependencies missing.${NC}"
        echo -e "${BLUE}Run with --install-deps to install all dependencies:${NC}"
        echo -e "  ./install.sh --install-deps\n"

        if [ "$SKIP_VALIDATION" = false ]; then
            echo -e "${RED}Aborting installation.${NC}"
            echo -e "${YELLOW}Use --skip-validation to bypass this check (not recommended).${NC}\n"
            exit 1
        else
            echo -e "${YELLOW}Skipping validation as requested...${NC}\n"
        fi
    else
        echo -e "\n${GREEN}All dependencies found!${NC}\n"
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

# =============================================================================
# MAIN
# =============================================================================

# Install dependencies if requested
if [ "$INSTALL_DEPS" = true ]; then
    install_dependencies
fi

# Run dependency check
check_dependencies

# Create config directory
create_config_dir

# Install configurations
echo -e "${BLUE}Creating symlinks...${NC}"
create_symlink "$DOTFILES_DIR/nvim" "$CONFIG_DIR/nvim" "Neovim"
create_symlink "$DOTFILES_DIR/alacritty" "$CONFIG_DIR/alacritty" "Alacritty"
create_symlink "$DOTFILES_DIR/ghostty" "$CONFIG_DIR/ghostty" "Ghostty"
create_symlink "$DOTFILES_DIR/yabai" "$CONFIG_DIR/yabai" "Yabai"
create_symlink "$DOTFILES_DIR/skhd" "$CONFIG_DIR/skhd" "skhd"
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf" "Tmux"
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc" "Zsh"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$CONFIG_DIR/starship.toml" "Starship"

# Tmux scripts
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN]${NC} Would create: $HOME/.tmux"
else
    mkdir -p "$HOME/.tmux"
fi
create_symlink "$DOTFILES_DIR/tmux/tmux-swap-and-follow.sh" "$HOME/.tmux/tmux-swap-and-follow.sh" "Tmux swap script"

# VS Code configuration
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
if [ -d "$HOME/Library/Application Support/Code" ]; then
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY RUN]${NC} Would create: $VSCODE_USER_DIR"
    else
        mkdir -p "$VSCODE_USER_DIR"
        mkdir -p "$VSCODE_USER_DIR/snippets"
    fi
    create_symlink "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER_DIR/settings.json" "VS Code settings"
    create_symlink "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_USER_DIR/keybindings.json" "VS Code keybindings"

    # Install VS Code extensions
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY RUN]${NC} Would install VS Code extensions from extensions.txt"
    else
        echo -e "${BLUE}Installing VS Code extensions...${NC}"
        while IFS= read -r extension || [ -n "$extension" ]; do
            if [ -n "$extension" ]; then
                code --install-extension "$extension" --force > /dev/null 2>&1 && \
                    echo -e "${GREEN}  ✓${NC} $extension" || \
                    echo -e "${YELLOW}  ⚠${NC} $extension (failed)"
            fi
        done < "$DOTFILES_DIR/vscode/extensions.txt"
    fi
else
    echo -e "${YELLOW}VS Code not installed, skipping VS Code config${NC}"
fi

# Warp terminal theme
WARP_THEMES_DIR="$HOME/.warp/themes"
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN]${NC} Would create: $WARP_THEMES_DIR"
else
    mkdir -p "$WARP_THEMES_DIR"
fi
create_symlink "$DOTFILES_DIR/warp/themes/kanagawa-dragon.yaml" "$WARP_THEMES_DIR/kanagawa-dragon.yaml" "Warp theme"

if [ "$DRY_RUN" = true ]; then
    echo -e "\n${YELLOW}DRY RUN complete. Run without --dry-run to apply changes.${NC}"
else
    echo -e "\n${GREEN}✓ Dotfiles installed successfully!${NC}"
    echo -e "${BLUE}Next steps:${NC}"
    echo -e "  1. Restart your terminal or run: source ~/.zshrc"
    echo -e "  2. Open Neovim and run: :Lazy sync"
    echo -e "  3. Install Tmux plugins: prefix + I"
    echo -e "  4. Restart services: yabai --restart-service && skhd --restart-service"
fi
