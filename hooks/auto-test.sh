#!/bin/bash
# Auto-run tests in background after file edits
# Detects test framework and runs appropriate command

# Read hook input from stdin
INPUT=$(cat)

# Extract the file path from the tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty')

if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Get the directory of the edited file
FILE_DIR=$(dirname "$FILE_PATH")

# Find project root by looking for common project markers
find_project_root() {
    local dir="$1"
    while [ "$dir" != "/" ]; do
        if [ -f "$dir/package.json" ] || [ -f "$dir/pyproject.toml" ] || [ -f "$dir/setup.py" ] || [ -f "$dir/Cargo.toml" ]; then
            echo "$dir"
            return
        fi
        dir=$(dirname "$dir")
    done
    echo ""
}

PROJECT_ROOT=$(find_project_root "$FILE_DIR")

if [ -z "$PROJECT_ROOT" ]; then
    exit 0
fi

cd "$PROJECT_ROOT"

# Detect test framework and run tests
if [ -f "pyproject.toml" ] || [ -f "setup.py" ] || [ -f "pytest.ini" ]; then
    # Python project - use pytest
    if command -v pytest &> /dev/null; then
        pytest --tb=short -q 2>&1 | head -50 &
    fi
elif [ -f "package.json" ]; then
    # Node.js project
    if grep -q '"test"' package.json 2>/dev/null; then
        if [ -f "yarn.lock" ]; then
            yarn test 2>&1 | head -50 &
        elif [ -f "pnpm-lock.yaml" ]; then
            pnpm test 2>&1 | head -50 &
        else
            npm test 2>&1 | head -50 &
        fi
    fi
elif [ -f "Cargo.toml" ]; then
    # Rust project
    if command -v cargo &> /dev/null; then
        cargo test 2>&1 | head -50 &
    fi
fi

exit 0
