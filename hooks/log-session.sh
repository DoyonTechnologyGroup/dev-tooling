#!/bin/bash
# Log session information when Claude stops
# Appends timestamp, session_id, and working directory to sessions.log

# Read hook input from stdin
INPUT=$(cat)

# Extract session info
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')
STOP_REASON=$(echo "$INPUT" | jq -r '.stop_hook_reason // "unknown"')

# Get current timestamp and working directory
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
WORKING_DIR=$(pwd)

# Ensure log directory exists
LOG_DIR="$HOME/.claude/logs"
mkdir -p "$LOG_DIR"

# Append to sessions log
echo "$TIMESTAMP | session=$SESSION_ID | dir=$WORKING_DIR | reason=$STOP_REASON" >> "$LOG_DIR/sessions.log"
