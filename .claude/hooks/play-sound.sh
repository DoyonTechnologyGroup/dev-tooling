#!/bin/bash
# Play a sound when Claude Code finishes a task
# You can customize the sound by changing the file path below

SOUND_FILE="${CLAUDE_DONE_SOUND:-/System/Library/Sounds/Hero.aiff}"

# Play sound in background so it doesn't block
afplay "$SOUND_FILE" &
