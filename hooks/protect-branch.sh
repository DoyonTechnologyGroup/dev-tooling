#!/bin/bash
# Protect main/master branch from direct edits
# Returns exit code 2 to block the edit and send message to Claude

# Get the current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

# Check if we're on a protected branch
if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
    echo "BLOCKED: Cannot edit files directly on '$BRANCH' branch." >&2
    echo "Please create a feature branch first: git checkout -b feature/your-feature" >&2
    exit 2
fi

exit 0
