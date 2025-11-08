#!/usr/bin/env bash

# ============================================
# Re-enable macOS animations (restore defaults)
# ============================================

echo "🔄 Re-enabling macOS animations..."

# Re-enable window animations
defaults delete NSGlobalDomain NSAutomaticWindowAnimationsEnabled 2>/dev/null

# Re-enable Quick Look animation
defaults delete -g QLPanelAnimationDuration 2>/dev/null

# Restore normal resize speed
defaults delete NSGlobalDomain NSWindowResizeTime 2>/dev/null

# Re-enable app launch animations
defaults delete com.apple.dock launchanim 2>/dev/null

# Restore normal Dock autohide
defaults delete com.apple.dock autohide-delay 2>/dev/null
defaults delete com.apple.dock autohide-time-modifier 2>/dev/null

# Re-enable Mission Control animations
defaults delete com.apple.dock expose-animation-duration 2>/dev/null

# Re-enable space switching animations
defaults delete com.apple.dock workspaces-swoosh-animation-off 2>/dev/null

# Re-enable Finder animations
defaults delete com.apple.finder DisableAllAnimations 2>/dev/null

# Re-enable Mail animations
defaults delete com.apple.mail DisableReplyAnimations 2>/dev/null
defaults delete com.apple.mail DisableSendAnimations 2>/dev/null

# Apply changes
killall Dock
killall Finder

echo "✅ Animations re-enabled!"
