#!/usr/bin/env bash
# Disable unused macOS services to free RAM

# Spotlight indexing (~150 MB)
sudo mdutil -a -i off
sudo killall mds_stores 2>/dev/null

# Sidecar (~39 MB)
defaults write com.apple.sidecar.display AllowAllDevices -bool false
defaults -currentHost write com.apple.bluetooth PrefKeyServicesEnabled -bool false

# AirDrop / Sharing (~29 MB)
defaults write com.apple.sharingd DiscoverableMode -string "Off"
sudo killall sharingd 2>/dev/null

# Crash reporter dialogs
defaults write com.apple.CrashReporter DialogType none

echo "Disabled: Spotlight, Sidecar, AirDrop, CrashReporter dialogs"
