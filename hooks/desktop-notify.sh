#!/bin/bash
# Show native macOS desktop notifications for Claude Code events
# Reads hook input JSON from stdin to get event details

# Read the JSON input from stdin
INPUT=$(cat)

# Extract the event type from the hook context
EVENT_TYPE=$(echo "$INPUT" | jq -r '.hook_type // "notification"')

# Extract message based on event type
if [ "$EVENT_TYPE" = "Notification" ]; then
    MESSAGE=$(echo "$INPUT" | jq -r '.notification.message // "Claude needs your attention"')
    TITLE="Claude Code"
elif [ "$EVENT_TYPE" = "Stop" ]; then
    MESSAGE="Task completed"
    TITLE="Claude Code"
else
    MESSAGE=$(echo "$INPUT" | jq -r '.message // "Claude needs your attention"')
    TITLE="Claude Code"
fi

# Show macOS notification using osascript
osascript -e "display notification \"$MESSAGE\" with title \"$TITLE\""
