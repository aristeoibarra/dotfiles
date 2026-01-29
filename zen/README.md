# Zen Browser Configuration

Privacy-focused, minimal configuration for [Zen Browser](https://zen-browser.app/).

## Components

| File | Description |
|------|-------------|
| `user.js` | [Betterfox](https://github.com/yokoffing/Betterfox) v146 - Privacy and performance tweaks |
| `chrome/userChrome.css` | Hide workspace indicators for cleaner UI |

## Features

- Zero telemetry
- Strict tracking protection
- HTTPS-only mode
- Disabled Mozilla experiments (Normandy)
- Optimized memory and network settings
- Clean UI with hidden workspace indicators

## Installation

### 1. Find your Zen profile

```bash
# macOS
ls ~/Library/Application\ Support/zen/Profiles/

# Linux
ls ~/.zen/
```

### 2. Create symlinks

```bash
PROFILE="$HOME/Library/Application Support/zen/Profiles/YOUR_PROFILE_NAME"

# Backup existing files
mv "$PROFILE/user.js" "$PROFILE/user.js.backup" 2>/dev/null
mv "$PROFILE/chrome" "$PROFILE/chrome.backup" 2>/dev/null

# Create symlinks
ln -sf ~/dotfiles/zen/user.js "$PROFILE/user.js"
ln -sf ~/dotfiles/zen/chrome "$PROFILE/chrome"
```

### 3. Enable custom stylesheets

In `about:config`, set:

```
toolkit.legacyUserProfileCustomizations.stylesheets = true
```

### 4. Restart Zen Browser

## Recommended Extensions

| Extension | Purpose |
|-----------|---------|
| uBlock Origin | Ad and tracker blocking |
| Bitwarden | Password manager |
| Vim Vixen | Keyboard navigation |

## Recommended Settings

### Search Engine

Use a privacy-respecting search engine:
- Brave Search
- Startpage
- DuckDuckGo

### DNS over HTTPS

`about:preferences#privacy` → DNS over HTTPS → Max Protection

Recommended providers:
- NextDNS
- Cloudflare
- Mullvad

## Verify Configuration

Check in `about:config`:

```
app.normandy.enabled = false
toolkit.telemetry.enabled = false
browser.contentblocking.category = strict
```

## Known Issues

### Spotify Web Player

Spotify may stop playing due to:
- uBlock Origin blocking ads
- Strict tracking protection
- Disabled disk cache

**Workaround**: Use Spotify desktop app or Brave PWA.

See [Issue #1](https://github.com/aristeoibarra/dotfiles/issues/1) for details.

## Updating Betterfox

```bash
cd ~/dotfiles/zen
curl -O https://raw.githubusercontent.com/yokoffing/Betterfox/main/user.js
```

## References

- [Zen Browser](https://zen-browser.app/)
- [Betterfox](https://github.com/yokoffing/Betterfox)
- [Firefox userChrome.css](https://www.userchrome.org/)
