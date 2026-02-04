#!/bin/bash
# Play an error sound when a tool fails
# Uses Basso to distinguish from success (Glass) and permission (Funk)

SOUND_FILE="${CLAUDE_ERROR_SOUND:-/System/Library/Sounds/Basso.aiff}"

# Play sound in background so it doesn't block
afplay "$SOUND_FILE" &
