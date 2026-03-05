# Focus Blocker 🎯

Aggressive app blocking system for macOS with app renaming and process monitoring.

## Features

- ⏰ **Schedule-based blocking**: Define specific hours to block apps
- 🔒 **App renaming**: Apps are renamed during blocking hours so they can't be launched
- 🚫 **Process termination**: If somehow an app launches, it's immediately terminated
- 🔔 **Start/End notifications**: Get notified when blocking starts and ends
- 🚀 **Automatic**: Runs in background with launchd
- 🤫 **Invisible**: Blocked apps disappear from Spotlight and can't be opened

## Blocked apps by default

- WhatsApp
- Discord

## Default schedule

**12:00 AM - 5:00 AM** (midnight to 5am)

## Installation

```bash
cd ~/dotfiles/focus-blocker
./install.sh
```

The script will:
1. Compile the Swift code
2. Install the service in LaunchAgents
3. Start it automatically

**Note**: The app needs permissions to rename apps in `/Applications`. If you get permission errors, you may need to grant Full Disk Access to Terminal in System Settings → Privacy & Security.

## Configuration

Edit `config.json` to customize:

```json
{
  "blockedApps": [
    {
      "name": "WhatsApp",
      "bundleId": "net.whatsapp.WhatsApp"
    },
    {
      "name": "Discord",
      "bundleId": "com.hnc.Discord"
    }
  ],
  "schedule": {
    "startHour": 0,
    "startMinute": 0,
    "endHour": 4,
    "endMinute": 0
  },
  "snoozeMinutes": 3,
  "showNotifications": true
}
```

After modifying the configuration, restart the service:
```bash
launchctl unload ~/Library/LaunchAgents/com.user.focus-blocker.plist
launchctl load ~/Library/LaunchAgents/com.user.focus-blocker.plist
```

## How it works

Two-layer blocking system:

1. **App renaming (primary)**: At the start of blocking hours (12:00 AM):
   - Renames `WhatsApp.app` → `WhatsApp.app.blocked`
   - Renames `Discord.app` → `Discord.app.blocked`
   - Apps disappear from Spotlight, Dock, and Launchpad
   - You get a notification: "Focus Mode Started"

2. **Process monitoring (backup)**: During blocking hours:
   - Monitors for any blocked app processes every minute
   - If detected (somehow launched), terminates immediately
   - Notification if you try to open a blocked app

3. **Restoration**: At the end of blocking hours (5:00 AM):
   - Restores all app names to original
   - You get a notification: "Focus Mode Ended"
   - Apps are available again

## Useful commands

```bash
# View logs in real-time
tail -f ~/Library/Logs/focus-blocker.log

# View errors
tail -f ~/Library/Logs/focus-blocker.error.log

# Restart service (after changing config.json)
launchctl unload ~/Library/LaunchAgents/com.user.focus-blocker.plist
launchctl load ~/Library/LaunchAgents/com.user.focus-blocker.plist

# Check if running
launchctl list | grep focus-blocker

# Manually restore apps (if something goes wrong)
cd /Applications && for app in *.blocked; do mv "$app" "${app%.blocked}"; done
```

## Uninstallation

```bash
cd ~/dotfiles/focus-blocker
./uninstall.sh
```

## Finding Bundle IDs of other apps

To add more apps, you need their Bundle ID:

```bash
osascript -e 'id of app "AppName"'
```

Example:
```bash
osascript -e 'id of app "Slack"'
# Output: com.tinyspeck.slackmacgap
```

## Technical notes

- Uses `NSWorkspace` notifications to detect apps
- Overlays with `NSWindow` at `.floating` level
- Termination with `NSRunningApplication.terminate()`
- Runs as LaunchAgent (starts at login)
