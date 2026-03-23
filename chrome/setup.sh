#!/usr/bin/env bash
# Chrome dev-only setup — apply policies via defaults write
set -euo pipefail

echo "Applying Chrome dev-only policies..."

defaults write com.google.Chrome URLBlocklist -array '*'
defaults write com.google.Chrome URLAllowlist -array 'localhost' '127.0.0.1' 'file://*'
defaults write com.google.Chrome ClearBrowsingDataOnExitList -array \
  'browsing_history' 'download_history' 'cookies_and_other_site_data' \
  'cached_images_and_files' 'autofill' 'site_settings'

echo "Done. Restart Chrome to apply."
echo "Use 'chrome-allow add <domain>' to whitelist sites."
