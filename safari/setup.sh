#!/usr/bin/env bash
# Safari dev-optimized setup
set -euo pipefail

DOMAIN="com.apple.Safari"

echo "Applying Safari dev-optimized settings..."

# ── Performance ───────────────────────────────────────────────────
# Don't preload top hit in address bar (saves CPU + network)
defaults write "$DOMAIN" PreloadTopHit -bool false
# No search suggestions (saves network)
defaults write "$DOMAIN" SuppressSearchSuggestions -bool true
defaults write "$DOMAIN" UniversalSearchEnabled -bool false
# No DNS prefetching
defaults write "$DOMAIN" WebKitPreferences.dnsPrefetchingEnabled -bool false
# Don't show favorites under search field (less rendering)
defaults write "$DOMAIN" ShowFavoritesUnderSmartSearchField -bool false
# Don't auto-open "safe" downloads
defaults write "$DOMAIN" AutoOpenSafeDownloads -bool false

# ── Dev Tools ─────────────────────────────────────────────────────
defaults write "$DOMAIN" IncludeDevelopMenu -bool true
defaults write "$DOMAIN" WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write "$DOMAIN" "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write "$DOMAIN" WebKitPreferences.developerExtrasEnabled -bool true
# Show full URL in address bar
defaults write "$DOMAIN" ShowFullURLInSmartSearchField -bool true

# ── Privacy ───────────────────────────────────────────────────────
defaults write "$DOMAIN" SendDoNotTrackHTTPHeader -bool true
# Block cross-site tracking
defaults write "$DOMAIN" "com.apple.Safari.ContentPageGroupIdentifier.WebKit2StorageBlockingPolicy" -int 1

echo "Done. Restart Safari to apply."
echo "Private browsing + YouTube blocked by safari-guard daemon."
