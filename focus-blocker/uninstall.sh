#!/bin/bash

set -e

LAUNCHD_PLIST="com.user.focus-blocker.plist"
LAUNCHD_PATH="$HOME/Library/LaunchAgents/$LAUNCHD_PLIST"

echo "🗑️  Focus Blocker - Uninstaller"
echo "================================="
echo ""

# Stop and unload service
if launchctl list | grep -q "com.user.focus-blocker"; then
    echo "⏸️  Stopping service..."
    launchctl unload "$LAUNCHD_PATH" 2>/dev/null || true
    echo "✅ Service stopped"
else
    echo "ℹ️  Service is not running"
fi

# Remove plist
if [ -f "$LAUNCHD_PATH" ]; then
    echo "🗑️  Removing LaunchAgent..."
    rm "$LAUNCHD_PATH"
    echo "✅ LaunchAgent removed"
fi

echo ""
echo "✅ Focus Blocker uninstalled"
echo "   (Project files remain in dotfiles/focus-blocker)"
echo ""
