#!/bin/bash
# Auto-format files after Edit or Write operations
# Detects file type and runs the appropriate formatter

# Read hook input from stdin
INPUT=$(cat)

# Extract the file path from the tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty')

if [ -z "$FILE_PATH" ] || [ ! -f "$FILE_PATH" ]; then
    exit 0
fi

# Get file extension
EXT="${FILE_PATH##*.}"

case "$EXT" in
    py)
        # Python: prefer ruff, fall back to black
        if command -v ruff &> /dev/null; then
            ruff format "$FILE_PATH" 2>/dev/null
        elif command -v black &> /dev/null; then
            black -q "$FILE_PATH" 2>/dev/null
        fi
        ;;
    js|jsx|ts|tsx|json|css|scss|md|yaml|yml)
        # JavaScript/TypeScript/JSON/etc: use prettier
        if command -v prettier &> /dev/null; then
            prettier --write "$FILE_PATH" 2>/dev/null
        fi
        ;;
    go)
        # Go: use gofmt
        if command -v gofmt &> /dev/null; then
            gofmt -w "$FILE_PATH" 2>/dev/null
        fi
        ;;
    rs)
        # Rust: use rustfmt
        if command -v rustfmt &> /dev/null; then
            rustfmt "$FILE_PATH" 2>/dev/null
        fi
        ;;
esac

exit 0
