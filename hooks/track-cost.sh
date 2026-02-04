#!/bin/bash
# Track token usage and estimated costs
# Appends usage data to usage.csv

# Read hook input from stdin
INPUT=$(cat)

# Extract token usage from hook input
INPUT_TOKENS=$(echo "$INPUT" | jq -r '.token_usage.input_tokens // 0')
OUTPUT_TOKENS=$(echo "$INPUT" | jq -r '.token_usage.output_tokens // 0')
CACHE_READ=$(echo "$INPUT" | jq -r '.token_usage.cache_read_tokens // 0')
CACHE_WRITE=$(echo "$INPUT" | jq -r '.token_usage.cache_write_tokens // 0')
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // "unknown"')

# Get current timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Ensure log directory exists
LOG_DIR="$HOME/.claude/logs"
mkdir -p "$LOG_DIR"

CSV_FILE="$LOG_DIR/usage.csv"

# Create header if file doesn't exist
if [ ! -f "$CSV_FILE" ]; then
    echo "timestamp,session_id,input_tokens,output_tokens,cache_read,cache_write" > "$CSV_FILE"
fi

# Append usage data
echo "$TIMESTAMP,$SESSION_ID,$INPUT_TOKENS,$OUTPUT_TOKENS,$CACHE_READ,$CACHE_WRITE" >> "$CSV_FILE"
