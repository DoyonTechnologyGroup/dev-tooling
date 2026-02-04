#!/bin/bash
# Send notification to Microsoft Teams when Claude finishes
# Requires webhook URL in ~/.claude/teams-webhook-url

WEBHOOK_FILE="$HOME/.claude/teams-webhook-url"

# Check if webhook URL file exists
if [ ! -f "$WEBHOOK_FILE" ]; then
    exit 0
fi

WEBHOOK_URL=$(cat "$WEBHOOK_FILE" | tr -d '[:space:]')

if [ -z "$WEBHOOK_URL" ]; then
    exit 0
fi

# Read hook input from stdin
INPUT=$(cat)

# Extract session info
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
STOP_REASON=$(echo "$INPUT" | jq -r '.stop_hook_reason // "completed"')

# Get current timestamp and working directory
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
WORKING_DIR=$(pwd)

# Build the Teams message payload (Adaptive Card format)
PAYLOAD=$(cat <<EOF
{
    "type": "message",
    "attachments": [
        {
            "contentType": "application/vnd.microsoft.card.adaptive",
            "content": {
                "type": "AdaptiveCard",
                "version": "1.2",
                "body": [
                    {
                        "type": "TextBlock",
                        "text": "Claude Code Task Completed",
                        "weight": "bolder",
                        "size": "medium"
                    },
                    {
                        "type": "FactSet",
                        "facts": [
                            {"title": "Time", "value": "$TIMESTAMP"},
                            {"title": "Directory", "value": "$WORKING_DIR"},
                            {"title": "Reason", "value": "$STOP_REASON"}
                        ]
                    }
                ]
            }
        }
    ]
}
EOF
)

# Send the notification (in background to not block)
curl -s -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_URL" &>/dev/null &

exit 0
