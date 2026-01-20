# Safari Blocker - Mac Local Setup

Automatically closes Safari when opened. Protection mechanism to prevent bypassing NextDNS blocks.

## Architecture

```
Safari opens
     │
     ▼ (every 2 seconds)
LaunchDaemon: com.block.safari
     │
     ▼
block-safari.sh
     ├── graceful quit (osascript)
     └── force kill (pkill -9)
```

## Components

### Files

| File | Purpose |
|------|---------|
| `~/bin/block-safari.sh` | Script that closes Safari |
| `/Library/LaunchDaemons/com.block.safari.plist` | Daemon that runs every 2 seconds |

## How it works

1. LaunchDaemon runs `block-safari.sh` every 2 seconds
2. Script checks if Safari is running (`pgrep`)
3. If running: graceful quit → wait 0.3s → force kill
4. Safari closes before user can do anything

## Configuration

### LaunchDaemon

Location: `/Library/LaunchDaemons/com.block.safari.plist`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.block.safari</string>

    <key>ProgramArguments</key>
    <array>
        <string>/Users/<username>/bin/block-safari.sh</string>
    </array>

    <key>StartInterval</key>
    <integer>2</integer>

    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
```

### Script

Location: `~/bin/block-safari.sh`

```bash
#!/bin/bash
# block-safari.sh - Kill Safari if running

if pgrep -x "Safari" > /dev/null; then
    osascript -e 'tell application "Safari" to quit' 2>/dev/null
    sleep 0.3
    pkill -9 Safari 2>/dev/null
fi
```

## Resource Usage

| Metric | Value |
|--------|-------|
| CPU | ~0.001% |
| RAM | 0 MB permanent |
| Executions/day | 43,200 |

Negligible impact on system performance.

## Useful Commands

### Check daemon status

```bash
sudo launchctl list | grep safari
```

### Restart daemon

```bash
sudo launchctl remove com.block.safari
sudo launchctl load /Library/LaunchDaemons/com.block.safari.plist
```

### Stop daemon temporarily

```bash
sudo launchctl remove com.block.safari
```

### Reactivate daemon

```bash
sudo launchctl load /Library/LaunchDaemons/com.block.safari.plist
```

## Troubleshooting

### Safari not closing

1. Check if daemon is running:
   ```bash
   sudo launchctl list | grep safari
   ```

2. Check if script exists and is executable:
   ```bash
   ls -la ~/bin/block-safari.sh
   ```

3. Test script manually:
   ```bash
   ~/bin/block-safari.sh
   ```

### Daemon not loading

1. Check plist syntax:
   ```bash
   plutil -lint /Library/LaunchDaemons/com.block.safari.plist
   ```

2. Check permissions:
   ```bash
   ls -la /Library/LaunchDaemons/com.block.safari.plist
   ```

## Why LaunchDaemon (not LaunchAgent)

- **LaunchDaemon**: Runs as root, located in `/Library/LaunchDaemons/`
- **LaunchAgent**: Runs as user, located in `~/Library/LaunchAgents/`

Using LaunchDaemon provides:
- Higher privilege (harder to disable)
- Runs regardless of user login
- More friction to bypass (requires sudo)

## Why this exists

Safari can bypass NextDNS protection because:
- It doesn't go through the configured DNS in some cases
- Apple services may use direct connections
- User might try to use Safari during moments of weakness

This daemon ensures Safari cannot be used, forcing the use of Brave Browser which respects NextDNS blocking.
