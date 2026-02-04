#!/bin/bash
# Toggle Teams notifications on/off
# Usage: teams-toggle.sh [on|off]

WEBHOOK_FILE="$HOME/.claude/teams-webhook-url"
DISABLED_FILE="$HOME/.claude/teams-webhook-url.disabled"

case "${1:-toggle}" in
    on)
        if [ -f "$DISABLED_FILE" ]; then
            mv "$DISABLED_FILE" "$WEBHOOK_FILE"
            echo "Teams notifications ON"
        elif [ -f "$WEBHOOK_FILE" ]; then
            echo "Teams notifications already ON"
        else
            echo "No webhook URL found"
        fi
        ;;
    off)
        if [ -f "$WEBHOOK_FILE" ]; then
            mv "$WEBHOOK_FILE" "$DISABLED_FILE"
            echo "Teams notifications OFF"
        elif [ -f "$DISABLED_FILE" ]; then
            echo "Teams notifications already OFF"
        else
            echo "No webhook URL found"
        fi
        ;;
    toggle|*)
        if [ -f "$WEBHOOK_FILE" ]; then
            mv "$WEBHOOK_FILE" "$DISABLED_FILE"
            echo "Teams notifications OFF"
        elif [ -f "$DISABLED_FILE" ]; then
            mv "$DISABLED_FILE" "$WEBHOOK_FILE"
            echo "Teams notifications ON"
        else
            echo "No webhook URL found"
        fi
        ;;
esac
