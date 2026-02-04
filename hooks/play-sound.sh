#!/bin/bash
# Play a sound when Claude Code finishes a task
# Customize by setting CLAUDE_DONE_SOUND environment variable

SOUND_FILE="${CLAUDE_DONE_SOUND:-/System/Library/Sounds/Glass.aiff}"

# Play sound in background so it doesn't block
afplay "$SOUND_FILE" &
