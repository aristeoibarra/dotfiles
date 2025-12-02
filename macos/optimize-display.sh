#!/usr/bin/env bash
# macOS Display & Ergonomics Optimization
# Optimized for BenQ GW2780 (27", 1920x1080) + 8+ hours programming

echo "🖥️  Optimizing macOS for long programming sessions..."

# ============================================
# KEYBOARD - Key Repeat (Balanced for vim + typing)
# ============================================
echo "⌨️  Configuring key repeat..."
defaults write NSGlobalDomain KeyRepeat -int 7  # Balanced for 8+ hours (105ms interval - less fatigue)
defaults write NSGlobalDomain InitialKeyRepeat -int 35  # Moderate delay (525ms)

# ============================================
# CURSOR - Optimized for 27" @ 82 PPI
# ============================================
echo "🖱️  Optimizing cursor size..."
defaults write NSGlobalDomain NSCursorSize -float 1.25  # 1.25x size (balanced visibility without blocking content)

# ============================================
# MOTION - Reduce for less eye strain
# ============================================
echo "👁️  Reducing motion..."
defaults write com.apple.universalaccess reduceMotion -bool true
defaults write com.apple.Accessibility ReduceMotionEnabled -bool true

# ============================================
# FONT RENDERING - Optimized for 27" @ 82 PPI
# ============================================
echo "🔤  Optimizing font rendering..."
defaults write NSGlobalDomain AppleFontSmoothing -int 3  # Strong smoothing (critical for 81 PPI non-Retina)
defaults write NSGlobalDomain AppleAntiAliasingThreshold -int 4

# ============================================
# TRACKPAD - Optimize velocity
# ============================================
echo "👆  Configuring trackpad..."
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.5

# ============================================
# DISPLAY - Subpixel rendering
# ============================================
echo "📺  Configuring display rendering..."
defaults write NSGlobalDomain CGFontRenderingFontSmoothingDisabled -bool false

echo ""
echo "✅ macOS optimization complete!"
echo ""
echo "⚠️  Note: Some changes require logout/restart to take effect"
echo "   Run: killall SystemUIServer Dock Finder"
echo "   Or: Log out and back in"
echo ""
echo "💡 For full effect:"
echo "   1. System Settings > Displays > Check refresh rate is 60Hz"
echo "   2. Enable BenQ Eye-Care mode on monitor (hardware button)"
echo "   3. Adjust monitor brightness to ~40% for long sessions"
