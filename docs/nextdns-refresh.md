# NextDNS Refresh - Mac Local Setup

Automates DNS flush and Brave Browser close when nextdns-blocker (EC2) syncs.

## Architecture

```
EC2: nextdns-blocker sync
         │
         ▼ (notifies ntfy.sh)
Mac: ntfy subscriber (LaunchAgent)
         │
         ▼ (executes script)
     nextdns-refresh.sh
         ├── flush DNS
         └── close Brave

     [Fallback] every 3 min
         └── silent DNS flush
```

## Components

### Files

| File | Purpose |
|------|---------|
| `~/bin/nextdns-refresh.sh` | Flush DNS + close Brave |
| `~/bin/flushdns-silent.sh` | DNS flush only (fallback) |
| `~/.config/ntfy/client.yml` | ntfy subscriber config |
| `~/Library/LaunchAgents/com.nextdns.refresh.plist` | ntfy subscriber daemon |
| `~/Library/LaunchAgents/com.flushdns.fallback.plist` | Fallback daemon (every 3 min) |
| `/etc/sudoers.d/nextdns-refresh` | Passwordless sudo permissions |

### Logs

```bash
# Main script executions
~/.local/log/nextdns-refresh.log

# ntfy subscriber output
~/.local/log/ntfy-subscribe.log
~/.local/log/ntfy-subscribe.error.log
```

## Configuration

### ntfy topic

```
Topic: <your-secret-topic>
Server: https://ntfy.sh
```

This topic must match the one configured in EC2 (`config.json` in nextdns-blocker).

### Sudoers

Allows DNS flush without password:

```
<username> ALL=(ALL) NOPASSWD: /usr/bin/dscacheutil -flushcache, /usr/bin/killall -HUP mDNSResponder
```

## Useful Commands

### Check daemon status

```bash
launchctl list | grep -E "nextdns|flushdns"
```

### Watch logs in real time

```bash
tail -f ~/.local/log/nextdns-refresh.log
```

### Manual test (send notification)

```bash
ntfy publish <your-secret-topic> "test"
```

### Restart ntfy subscriber

```bash
launchctl unload ~/Library/LaunchAgents/com.nextdns.refresh.plist
launchctl load ~/Library/LaunchAgents/com.nextdns.refresh.plist
```

### Restart fallback

```bash
launchctl unload ~/Library/LaunchAgents/com.flushdns.fallback.plist
launchctl load ~/Library/LaunchAgents/com.flushdns.fallback.plist
```

### Stop everything temporarily

```bash
launchctl unload ~/Library/LaunchAgents/com.nextdns.refresh.plist
launchctl unload ~/Library/LaunchAgents/com.flushdns.fallback.plist
```

### Reactivate everything

```bash
launchctl load ~/Library/LaunchAgents/com.nextdns.refresh.plist
launchctl load ~/Library/LaunchAgents/com.flushdns.fallback.plist
```

## Troubleshooting

### Subscriber not receiving notifications

1. Check if it's running:
   ```bash
   launchctl list | grep nextdns.refresh
   ```

2. Check error logs:
   ```bash
   cat ~/.local/log/ntfy-subscribe.error.log
   ```

3. Test ntfy connection:
   ```bash
   curl -s "https://ntfy.sh/<your-secret-topic>/json?poll=1"
   ```

### DNS flush not working

1. Verify sudo permissions:
   ```bash
   sudo -l | grep dscacheutil
   ```

2. If it fails, recreate sudoers:
   ```bash
   echo '<username> ALL=(ALL) NOPASSWD: /usr/bin/dscacheutil -flushcache, /usr/bin/killall -HUP mDNSResponder' | sudo tee /etc/sudoers.d/nextdns-refresh
   ```

### Brave not closing

The script uses `osascript` to close Brave gracefully. If it doesn't work:

```bash
# Check if Brave is running
pgrep -x "Brave Browser"

# Test manual close
osascript -e 'tell application "Brave Browser" to quit'
```

## Dependencies

- `ntfy` CLI: `brew install ntfy`
- macOS (for launchd and osascript)

## Why this exists

nextdns-blocker runs on EC2 and updates blocks in NextDNS. But Mac has local DNS cache and Brave has its own cache. Without this system, changes take time to apply.

This setup guarantees:
- **Normal case**: changes apply in seconds (via ntfy)
- **If ntfy fails**: max 3 minutes delay (fallback)
