#!/bin/bash
# Performance profiling script for Neovim startup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_DIR="$(dirname "$SCRIPT_DIR")"
PROFILE_LOG="$NVIM_DIR/.profile_startup.log"
PLUGIN_LOG="$NVIM_DIR/.profile_plugins.log"

echo "🔍 Profiling Neovim startup..."
echo ""

# Profile 1: Total startup time
echo "⏱️  Measuring total startup time..."
START_TIME=$(date +%s%N)

# Run headless Neovim and measure time
nvim --headless --noplugin "+set nocp" "+q" 2>/dev/null || true

END_TIME=$(date +%s%N)
DURATION_MS=$(( (END_TIME - START_TIME) / 1000000 ))

echo "✓ Startup time (no plugins): ${DURATION_MS}ms"
echo ""

# Profile 2: With all plugins
echo "⏱️  Measuring startup with all plugins..."
START_TIME=$(date +%s%N)

nvim --headless "+q" 2>/dev/null || true

END_TIME=$(date +%s%N)
DURATION_MS=$(( (END_TIME - START_TIME) / 1000000 ))

echo "✓ Startup time (with plugins): ${DURATION_MS}ms"
echo ""

# Profile 3: Lua function profiling
echo "📊 Profiling Lua functions..."
nvim --headless \
  "+profile start $PROFILE_LOG" \
  "+profile func *" \
  "+qa" 2>/dev/null || true

if [ -f "$PROFILE_LOG" ]; then
  echo "✓ Detailed profiles saved to: $PROFILE_LOG"
  echo ""
  echo "Top 10 slowest functions:"
  tail -20 "$PROFILE_LOG" | grep -E "^[0-9]+\." | head -10 || true
fi

echo ""

# Profile 4: Plugin performance
echo "📦 Checking slow plugins..."
nvim --headless \
  "+Lazy debug" \
  "+only" \
  "+wincmd p" \
  "+qa" 2>/dev/null || true

echo ""
echo "✅ Performance profiling complete!"
echo ""
echo "Commands to check performance:"
echo "  :Lazy debug              - Show slow plugins"
echo "  :profile start prof.log  - Start profiling"
echo "  :profile func *          - Profile all functions"
echo "  :profile stop            - Stop profiling"
echo "  :Lazy stats              - Show plugin statistics"
echo ""
echo "Files:"
echo "  $PROFILE_LOG - Detailed function profiling"
