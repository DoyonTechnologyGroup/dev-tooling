#!/bin/bash
# Play a sound when Claude Code needs permission
# Uses a different sound to distinguish from task completion

SOUND_FILE="${CLAUDE_PERMISSION_SOUND:-/System/Library/Sounds/Funk.aiff}"

# Play sound in background so it doesn't block
afplay "$SOUND_FILE" &
