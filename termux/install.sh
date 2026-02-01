#!/data/data/com.termux/files/usr/bin/bash
# Termux dotfiles installer (Ultra-Light)
#
# Usage:
#   git clone https://github.com/aristeoibarra/dotfiles ~/dotfiles
#   ~/dotfiles/termux/install.sh

set -e

DOTFILES="$HOME/dotfiles/termux"

# Verify
if [ ! -d "$DOTFILES" ]; then
    echo "Error: $DOTFILES not found"
    echo "Run: git clone https://github.com/aristeoibarra/dotfiles ~/dotfiles"
    exit 1
fi

echo "==> Updating packages..."
pkg update -y

echo "==> Installing essentials..."
pkg install -y \
    neovim \
    git \
    fzf \
    zsh \
    openssh \
    termux-api

echo "==> Installing zsh plugins..."
mkdir -p ~/.zsh
[ ! -d ~/.zsh/zsh-autosuggestions ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
[ ! -d ~/.zsh/zsh-syntax-highlighting ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

echo "==> Installing optional tools..."
pkg install -y bat ripgrep fd zoxide 2>/dev/null || true

echo "==> Setting up storage..."
termux-setup-storage || true

echo "==> Changing shell to zsh..."
chsh -s zsh

echo "==> Creating symlinks..."
mkdir -p ~/.config

# Backup and link
[ -f ~/.zshrc ] && mv ~/.zshrc ~/.zshrc.bak
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.bak

ln -sf "$DOTFILES/.zshrc" ~/.zshrc
ln -sf "$DOTFILES/nvim" ~/.config/nvim

echo "==> Setting up git..."
read -p "Git name [aristeoibarra]: " gitname
read -p "Git email [aristeoibarra608@gmail.com]: " gitemail
git config --global user.name "${gitname:-aristeoibarra}"
git config --global user.email "${gitemail:-aristeoibarra608@gmail.com}"
git config --global core.editor "nvim"

echo ""
echo "==> Done!"
echo "Restart Termux to apply changes."
