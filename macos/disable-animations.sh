#!/usr/bin/env bash

# ============================================
# ULTRAMINIMAL macOS - Disable Animations
# ============================================

echo "🚀 Disabling macOS animations..."

# Disable window animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Disable Quick Look animation
defaults write -g QLPanelAnimationDuration -float 0

# Speed up window resize animations
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Disable app launch animations
defaults write com.apple.dock launchanim -bool false

# Make Dock autohide instant
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

# Disable Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Disable space switching animations
defaults write com.apple.dock workspaces-swoosh-animation-off -bool true

# Disable Finder animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Disable Mail animations
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

# Apply changes
killall Dock
killall Finder

echo "✅ Animations disabled!"
echo ""
echo "💡 To revert, run: bash ~/dotfiles/macos/enable-animations.sh"
