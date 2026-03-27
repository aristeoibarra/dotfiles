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
TERMINAL_DEPS=("alacritty")

# Modern CLI replacements (shell, search, files, git)
CLI_DEPS=("bat" "rg" "fd" "eza" "sd" "delta" "difft" "fzf" "zoxide" "lazygit" "gh" "atuin" "yazi" "sesh")

# Dev tools (code analysis, validation, stats)
DEV_DEPS=("ast-grep" "shellcheck" "scc" "jq" "yq")

# Runtimes & package managers
RUNTIME_DEPS=("fnm" "pnpm" "starship")

# Media (focus mode, yazi previews)
MEDIA_DEPS=("mpv")

# Containers (optional — install if you use Docker)
CONTAINER_DEPS=("docker" "colima" "docker-compose")

# Optional
OPTIONAL_DEPS=("deno")

# Homebrew packages mapping (command:brew_package)
get_brew_package() {
    case "$1" in
        nvim) echo "neovim" ;;
        tmux) echo "tmux" ;;
        zsh) echo "zsh" ;;
        yabai) echo "koekeishiya/formulae/yabai" ;;
        skhd) echo "koekeishiya/formulae/skhd" ;;
        alacritty) echo "--cask alacritty" ;;
        bat) echo "bat" ;;
        rg) echo "ripgrep" ;;
        fd) echo "fd" ;;
        eza) echo "eza" ;;
        fzf) echo "fzf" ;;
        zoxide) echo "zoxide" ;;
        lazygit) echo "lazygit" ;;
        jq) echo "jq" ;;
        starship) echo "starship" ;;
        fnm) echo "fnm" ;;
        atuin) echo "atuin" ;;
        yazi) echo "yazi" ;;
        sesh) echo "sesh" ;;
        sd) echo "sd" ;;
        difft) echo "difftastic" ;;
        ast-grep) echo "ast-grep" ;;
        shellcheck) echo "shellcheck" ;;
        scc) echo "scc" ;;
        delta) echo "git-delta" ;;
        gh) echo "gh" ;;
        mpv) echo "mpv" ;;
        yq) echo "yq" ;;
        pnpm) echo "pnpm" ;;
        docker) echo "docker" ;;
        colima) echo "colima" ;;
        docker-compose) echo "docker-compose" ;;
        deno) echo "deno" ;;
        *) echo "$1" ;;
    esac
}

# Zsh plugins (Homebrew)
ZSH_PLUGINS=("zsh-autosuggestions" "zsh-syntax-highlighting" "zsh-completions" "fzf-tab")

# Fonts
FONTS=("font-jetbrains-mono-nerd-font")

# Helper: install a list of brew deps
install_brew_deps() {
    local label="$1"; shift
    local deps=("$@")
    echo -e "\n${BLUE}Installing ${label}...${NC}"
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "  Installing $(get_brew_package "$dep")..."
            # shellcheck disable=SC2046
            brew install $(get_brew_package "$dep") 2>/dev/null && \
                echo -e "${GREEN}  ✓${NC} $dep" || \
                echo -e "${RED}  ✗${NC} $dep (failed)"
        else
            echo -e "${GREEN}  ✓${NC} $dep (already installed)"
        fi
    done
}

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

    # Tap joshmedeski/sesh for sesh
    echo -e "${BLUE}Tapping joshmedeski/sesh...${NC}"
    brew tap joshmedeski/sesh 2>/dev/null

    # Brew categories
    install_brew_deps "core"               "${CORE_DEPS[@]}"
    install_brew_deps "terminals"          "${TERMINAL_DEPS[@]}"
    install_brew_deps "CLI tools"          "${CLI_DEPS[@]}"
    install_brew_deps "dev tools"          "${DEV_DEPS[@]}"
    install_brew_deps "runtimes"           "${RUNTIME_DEPS[@]}"
    install_brew_deps "media"              "${MEDIA_DEPS[@]}"
    install_brew_deps "containers"         "${CONTAINER_DEPS[@]}"

    # Zsh plugins
    echo -e "\n${BLUE}Installing Zsh plugins...${NC}"
    for plugin in "${ZSH_PLUGINS[@]}"; do
        if [ ! -f "/opt/homebrew/share/$plugin/$plugin.zsh" ] && [ ! -f "/opt/homebrew/share/$plugin/$plugin.plugin.zsh" ] && [ ! -d "/opt/homebrew/share/$plugin" ]; then
            echo -e "  Installing $plugin..."
            brew install "$plugin" 2>/dev/null && \
                echo -e "${GREEN}  ✓${NC} $plugin" || \
                echo -e "${RED}  ✗${NC} $plugin (failed)"
        else
            echo -e "${GREEN}  ✓${NC} $plugin (already installed)"
        fi
    done

    # Fonts
    echo -e "\n${BLUE}Installing fonts...${NC}"
    for font in "${FONTS[@]}"; do
        echo -e "  Installing $font..."
        brew install --cask "$font" 2>/dev/null && \
            echo -e "${GREEN}  ✓${NC} $font" || \
            echo -e "${YELLOW}  ⚠${NC} $font (may already be installed)"
    done

    # Bun (not available via Homebrew)
    echo -e "\n${BLUE}Installing Bun...${NC}"
    if ! command -v bun &> /dev/null; then
        curl -fsSL https://bun.sh/install | bash 2>/dev/null && \
            echo -e "${GREEN}  ✓${NC} bun" || \
            echo -e "${RED}  ✗${NC} bun (failed)"
    else
        echo -e "${GREEN}  ✓${NC} bun (already installed)"
    fi

    # TPM (Tmux Plugin Manager)
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

# Helper: check a list of deps (increments $missing)
check_brew_deps() {
    local label="$1"; shift
    local deps=("$@")
    echo -e "\n${BLUE}${label}:${NC}"
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo -e "${RED}  ✗${NC} $dep"
            ((missing++))
        else
            echo -e "${GREEN}  ✓${NC} $dep"
        fi
    done
}

# Check dependencies
check_dependencies() {
    echo -e "${BLUE}Checking dependencies...${NC}"
    local missing=0

    # Required categories
    check_brew_deps "Core"       "${CORE_DEPS[@]}"

    # Terminals (at least one)
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
        echo -e "${RED}  ✗ No terminal found (install alacritty)${NC}"
        ((missing++))
    fi

    check_brew_deps "CLI Tools"  "${CLI_DEPS[@]}"
    check_brew_deps "Dev Tools"  "${DEV_DEPS[@]}"
    check_brew_deps "Runtimes"   "${RUNTIME_DEPS[@]}"
    check_brew_deps "Media"      "${MEDIA_DEPS[@]}"
    check_brew_deps "Containers" "${CONTAINER_DEPS[@]}"

    # Zsh plugins
    echo -e "\n${BLUE}Zsh Plugins:${NC}"
    for plugin in "${ZSH_PLUGINS[@]}"; do
        if [ -f "/opt/homebrew/share/$plugin/$plugin.zsh" ] || [ -f "/opt/homebrew/share/$plugin/$plugin.plugin.zsh" ] || [ -d "/opt/homebrew/share/$plugin" ]; then
            echo -e "${GREEN}  ✓${NC} $plugin"
        else
            echo -e "${RED}  ✗${NC} $plugin"
            ((missing++))
        fi
    done

    # Non-Homebrew
    echo -e "\n${BLUE}Non-Homebrew:${NC}"
    if command -v bun &> /dev/null; then
        echo -e "${GREEN}  ✓${NC} bun"
    else
        echo -e "${RED}  ✗${NC} bun"
        ((missing++))
    fi

    # TPM
    echo -e "\n${BLUE}Tmux Plugins:${NC}"
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        echo -e "${GREEN}  ✓${NC} tpm (Tmux Plugin Manager)"
    else
        echo -e "${RED}  ✗${NC} tpm (Tmux Plugin Manager)"
        ((missing++))
    fi

    # Optional (don't count as missing)
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
create_symlink "$DOTFILES_DIR/yabai" "$CONFIG_DIR/yabai" "Yabai"
create_symlink "$DOTFILES_DIR/skhd" "$CONFIG_DIR/skhd" "skhd"
create_symlink "$DOTFILES_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf" "Tmux"
create_symlink "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc" "Zsh"
create_symlink "$DOTFILES_DIR/starship/starship.toml" "$CONFIG_DIR/starship.toml" "Starship"

# Atuin
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN]${NC} Would create: $CONFIG_DIR/atuin"
else
    mkdir -p "$CONFIG_DIR/atuin"
fi
create_symlink "$DOTFILES_DIR/atuin/config.toml" "$CONFIG_DIR/atuin/config.toml" "Atuin"

# Sesh
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN]${NC} Would create: $CONFIG_DIR/sesh"
else
    mkdir -p "$CONFIG_DIR/sesh"
fi
create_symlink "$DOTFILES_DIR/sesh/sesh.toml" "$CONFIG_DIR/sesh/sesh.toml" "Sesh"

# Claude Code
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN]${NC} Would create: $HOME/.claude/hooks"
else
    mkdir -p "$HOME/.claude/hooks"
fi
create_symlink "$DOTFILES_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md" "Claude CLAUDE.md"
create_symlink "$DOTFILES_DIR/claude/statusline.sh" "$HOME/.claude/statusline.sh" "Claude statusline"
create_symlink "$DOTFILES_DIR/claude/hooks/notify-tmux.sh" "$HOME/.claude/hooks/notify-tmux.sh" "Claude tmux notify hook"

# Tmux scripts
if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN]${NC} Would create: $HOME/.tmux"
else
    mkdir -p "$HOME/.tmux"
fi
create_symlink "$DOTFILES_DIR/tmux/tmux-swap-and-follow.sh" "$HOME/.tmux/tmux-swap-and-follow.sh" "Tmux swap script"

if [ "$DRY_RUN" = true ]; then
    echo -e "\n${YELLOW}DRY RUN complete. Run without --dry-run to apply changes.${NC}"
else
    echo -e "\n${GREEN}✓ Dotfiles installed successfully!${NC}"
    echo -e "${BLUE}Next steps:${NC}"
    echo -e "  1. Restart your terminal or run: source ~/.zshrc"
    echo -e "  2. Open Neovim and run: :Lazy sync"
    echo -e "  3. Install Tmux plugins: prefix + I"
    echo -e "  4. Import shell history: atuin import auto"
    echo -e "  5. Restart services: yabai --restart-service && skhd --restart-service"
fi
