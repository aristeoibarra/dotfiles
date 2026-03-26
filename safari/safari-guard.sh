#!/usr/bin/env bash
# safari-guard.sh — Close private windows and blocked domains in Safari
# Runs every 3s via LaunchAgent. Requires sudo to install/remove (ADHD-safe).
pgrep -x "Safari" > /dev/null 2>&1 || exit 0

osascript <<'APPLESCRIPT' 2>/dev/null
tell application "Safari"
    set blockedDomains to {"youtube.com", "youtu.be"}

    repeat with w in (every window)
        try
            -- Check if all tabs have missing URLs (private window)
            set isPrivate to true
            set tabList to (every tab of w)
            if (count of tabList) is 0 then
                set isPrivate to false
            end if

            repeat with i from (count of tabList) to 1 by -1
                set tabURL to URL of item i of tabList
                if tabURL is missing value then
                    -- private tab, keep isPrivate true
                else
                    set isPrivate to false
                    -- Check blocked domains while we have the URL
                    repeat with d in blockedDomains
                        if tabURL contains (contents of d) then
                            close item i of tabList
                            exit repeat
                        end if
                    end repeat
                end if
            end repeat

            if isPrivate and (count of tabList) > 0 then close w
        end try
    end repeat
end tell
APPLESCRIPT
