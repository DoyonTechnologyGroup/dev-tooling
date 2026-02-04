#!/bin/bash
# Auto-lint files after Edit or Write operations
# Returns non-zero exit with stderr if issues found (feeds back to Claude)

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
        # Python: use ruff for linting
        if command -v ruff &> /dev/null; then
            OUTPUT=$(ruff check "$FILE_PATH" 2>&1)
            if [ $? -ne 0 ]; then
                echo "Lint errors in $FILE_PATH:" >&2
                echo "$OUTPUT" >&2
                exit 1
            fi
        fi
        ;;
    js|jsx|ts|tsx)
        # JavaScript/TypeScript: use eslint
        if command -v eslint &> /dev/null; then
            OUTPUT=$(eslint "$FILE_PATH" 2>&1)
            if [ $? -ne 0 ]; then
                echo "Lint errors in $FILE_PATH:" >&2
                echo "$OUTPUT" >&2
                exit 1
            fi
        fi
        ;;
esac

exit 0
