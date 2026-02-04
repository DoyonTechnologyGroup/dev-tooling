# /teams - Toggle Teams Notifications

Toggle Teams notifications on or off.

## Instructions

Check what the user wants:

- If they say "on", "enable", or "start": Run `~/.claude/hooks/teams-toggle.sh on`
- If they say "off", "disable", or "stop": Run `~/.claude/hooks/teams-toggle.sh off`
- If no argument or "toggle": Run `~/.claude/hooks/teams-toggle.sh`
- If they say "status": Check if `~/.claude/teams-webhook-url` exists (on) or `~/.claude/teams-webhook-url.disabled` exists (off)

Report the result to the user.
