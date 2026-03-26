#!/usr/bin/env bash
# Chrome dev-only setup — optimized for resource-constrained systems
# Applies Chrome Enterprise policies via defaults write.
# For stronger enforcement, install the mobileconfig profile instead.
set -euo pipefail

DOMAIN="com.google.Chrome"

echo "Applying Chrome dev-optimized policies..."

# ── URL Restrictions ──────────────────────────────────────────────
# Block everything, allow only dev-relevant URLs
defaults write "$DOMAIN" URLBlocklist -array '*'
defaults write "$DOMAIN" URLAllowlist -array \
  'localhost' \
  '127.0.0.1' \
  '*.localhost' \
  'file://*' \
  'chrome://*' \
  'chrome-extension://*' \
  'devtools://*'
# [::1] breaks defaults -array parser; add via PlistBuddy
CHROME_PLIST="$HOME/Library/Preferences/com.google.Chrome.plist"
/usr/libexec/PlistBuddy \
  -c "Add :URLAllowlist:0 string [::1]" \
  -c "Add :TabDiscardingExceptions:0 string [::1]" \
  "$CHROME_PLIST" 2>/dev/null || true

# ── Cleanup on Exit ──────────────────────────────────────────────
defaults write "$DOMAIN" ClearBrowsingDataOnExitList -array \
  'browsing_history' 'download_history' 'cookies_and_other_site_data' \
  'cached_images_and_files' 'autofill' 'site_settings'

# ── Memory & Performance ─────────────────────────────────────────
defaults write "$DOMAIN" BackgroundModeEnabled -bool false
defaults write "$DOMAIN" HighEfficiencyModeEnabled -bool true
# 0=off, 1=on battery, 2=always
defaults write "$DOMAIN" BatterySaverModeAvailability -int 2
# Disable GPU process (~150MB saved). Tradeoff: slower canvas/WebGL/CSS animations.
defaults write "$DOMAIN" HardwareAccelerationModeEnabled -bool false
defaults write "$DOMAIN" TabDiscardingExceptions -array \
  'localhost' '127.0.0.1'

# ── Disable Background Services ──────────────────────────────────
# No Google account sync (eliminates persistent background sync)
defaults write "$DOMAIN" SyncDisabled -bool true
defaults write "$DOMAIN" BrowserSignin -int 0
# No telemetry/metrics reporting
defaults write "$DOMAIN" MetricsReportingEnabled -bool false
# Safe Browsing off — localhost-only, nothing to check
defaults write "$DOMAIN" SafeBrowsingEnabled -bool false
defaults write "$DOMAIN" SafeBrowsingExtendedReportingEnabled -bool false
# No remote spell check service
defaults write "$DOMAIN" SpellCheckServiceEnabled -bool false
# No translation service
defaults write "$DOMAIN" TranslateEnabled -bool false
# No search suggestions (saves network + CPU)
defaults write "$DOMAIN" SearchSuggestEnabled -bool false
# No alternate error pages (no Google error page fetching)
defaults write "$DOMAIN" AlternateErrorPagesEnabled -bool false
# Disable all network prediction/prefetching (0=always, 1=wifi, 2=never)
defaults write "$DOMAIN" NetworkPredictionOptions -int 2
# No Chromecast/media route discovery (stops mDNS scanning)
defaults write "$DOMAIN" MediaRouterEnabled -bool false
# No autoplay (saves CPU on accidental media)
defaults write "$DOMAIN" AutoplayAllowed -bool false
# No promo/welcome tabs
defaults write "$DOMAIN" PromotionalTabsEnabled -bool false
# No shopping features
defaults write "$DOMAIN" ShoppingListEnabled -bool false

# ── Autofill & Passwords Off ─────────────────────────────────────
defaults write "$DOMAIN" AutofillAddressEnabled -bool false
defaults write "$DOMAIN" AutofillCreditCardEnabled -bool false
defaults write "$DOMAIN" PasswordManagerEnabled -bool false

# ── Block All Permissions ─────────────────────────────────────────
# 1=allow, 2=block, 3=ask
defaults write "$DOMAIN" DefaultNotificationsSetting -int 2
defaults write "$DOMAIN" DefaultGeolocationSetting -int 2
defaults write "$DOMAIN" DefaultPopupsSetting -int 2
defaults write "$DOMAIN" DefaultWebBluetoothGuardSetting -int 2
defaults write "$DOMAIN" DefaultWebUsbGuardSetting -int 2
defaults write "$DOMAIN" DefaultSensorsSetting -int 2
defaults write "$DOMAIN" DefaultSerialGuardSetting -int 2

# ── Minimal Startup & UI ─────────────────────────────────────────
# Open about:blank on startup (zero render cost)
# Change to 1 (RestoreOnStartup) if you prefer session restore
defaults write "$DOMAIN" RestoreOnStartup -int 4
defaults write "$DOMAIN" RestoreOnStartupURLs -array 'about:blank'
defaults write "$DOMAIN" HomepageIsNewTabPage -bool false
defaults write "$DOMAIN" HomepageLocation -string 'about:blank'
# Blank new tab instead of NTP (saves render + network)
defaults write "$DOMAIN" NewTabPageLocation -string 'about:blank'
defaults write "$DOMAIN" BookmarkBarEnabled -bool false
defaults write "$DOMAIN" ShowHomeButton -bool false
defaults write "$DOMAIN" ShowAppsShortcutInBookmarkBar -bool false

# ── Dev Tools Always Available ────────────────────────────────────
# 0=disallowed, 1=allowed, 2=allowed except force-installed extensions
defaults write "$DOMAIN" DeveloperToolsAvailability -int 1

# ── Disable Printing ─────────────────────────────────────────────
defaults write "$DOMAIN" PrintingEnabled -bool false

echo "Done. Launch Chrome with 'chrome-dev' to apply policies + flags."
echo "Use 'chrome-allow add <domain>' to whitelist sites."
