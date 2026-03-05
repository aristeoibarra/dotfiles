#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LAUNCHD_PLIST="com.user.focus-blocker.plist"
LAUNCHD_PATH="$HOME/Library/LaunchAgents/$LAUNCHD_PLIST"
BINARY_NAME="focus-blocker"

echo "🎯 Focus Blocker - Installer"
echo "=============================="
echo ""

# Check if Swift is available
if ! command -v swiftc &> /dev/null; then
    echo "❌ Error: Swift compiler not found"
    echo "   Install Xcode Command Line Tools: xcode-select --install"
    exit 1
fi

# Compile Swift script
echo "📦 Compiling focus-blocker..."
swiftc -O "$SCRIPT_DIR/focus-blocker.swift" -o "$SCRIPT_DIR/$BINARY_NAME"

if [ ! -f "$SCRIPT_DIR/$BINARY_NAME" ]; then
    echo "❌ Error: Failed to compile binary"
    exit 1
fi

echo "✅ Compiled successfully"
echo ""

# Stop existing service if running
if launchctl list | grep -q "com.user.focus-blocker"; then
    echo "⏸️  Stopping existing service..."
    launchctl unload "$LAUNCHD_PATH" 2>/dev/null || true
fi

# Create LaunchAgents directory if it doesn't exist
mkdir -p "$HOME/Library/LaunchAgents"

# Copy plist to LaunchAgents
echo "📋 Installing LaunchAgent..."
cp "$SCRIPT_DIR/$LAUNCHD_PLIST" "$LAUNCHD_PATH"

# Load the service
echo "🚀 Starting service..."
launchctl load "$LAUNCHD_PATH"

echo ""
echo "✅ Focus Blocker installed and running"
echo ""
echo "📝 Useful commands:"
echo "   View logs:    tail -f ~/Library/Logs/focus-blocker.log"
echo "   View errors:  tail -f ~/Library/Logs/focus-blocker.error.log"
echo "   Stop:         launchctl unload $LAUNCHD_PATH"
echo "   Restart:      launchctl unload $LAUNCHD_PATH && launchctl load $LAUNCHD_PATH"
echo ""
echo "⚙️  Configuration: $SCRIPT_DIR/config.json"
echo ""
