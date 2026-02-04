#!/bin/bash
# Dev Tooling Installer for Claude Code
# Installs hooks, commands, and settings for the Ralph workflow

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "=================================="
echo "  Dev Tooling Installer"
echo "=================================="
echo ""

# Detect OS
OS="$(uname -s)"
if [ "$OS" != "Darwin" ] && [ "$OS" != "Linux" ]; then
    echo "Warning: This installer is designed for macOS/Linux. Some features may not work on $OS."
fi

# Create directories
echo "Creating directories..."
mkdir -p ~/.claude/hooks
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/logs

# Copy hooks
echo "Installing hooks..."
cp "$REPO_DIR"/hooks/*.sh ~/.claude/hooks/ 2>/dev/null || true
chmod +x ~/.claude/hooks/*.sh 2>/dev/null || true

# Copy commands
echo "Installing commands..."
cp "$REPO_DIR"/commands/*.md ~/.claude/commands/ 2>/dev/null || true

# Handle settings.json (merge, don't overwrite)
echo "Configuring settings..."
SETTINGS_FILE=~/.claude/settings.json

if [ -f "$SETTINGS_FILE" ]; then
    echo "  Existing settings.json found - backing up to settings.json.backup"
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"
fi

# Create or update settings
if [ ! -f "$SETTINGS_FILE" ] || [ ! -s "$SETTINGS_FILE" ]; then
    cp "$REPO_DIR"/install/settings.json "$SETTINGS_FILE"
    echo "  Created new settings.json"
else
    echo "  Merging with existing settings..."
    # Use jq if available, otherwise warn
    if command -v jq &> /dev/null; then
        # Merge hooks from template into existing
        TEMPLATE="$REPO_DIR/install/settings.json"
        MERGED=$(jq -s '.[0] * .[1]' "$SETTINGS_FILE" "$TEMPLATE" 2>/dev/null) || MERGED=""
        if [ -n "$MERGED" ]; then
            echo "$MERGED" > "$SETTINGS_FILE"
            echo "  Settings merged successfully"
        else
            echo "  Warning: Could not merge settings. Check ~/.claude/settings.json manually."
        fi
    else
        echo "  Warning: jq not installed. Please manually merge settings from:"
        echo "  $REPO_DIR/install/settings.json"
    fi
fi

# Summary
echo ""
echo "=================================="
echo "  Installation Complete!"
echo "=================================="
echo ""
echo "Installed:"
echo "  - Hooks:    ~/.claude/hooks/"
echo "  - Commands: ~/.claude/commands/"
echo "  - Settings: ~/.claude/settings.json"
echo ""
echo "Available commands:"
echo "  /ralph  - Smart workflow (bootstrap, plan, execute, lessons)"
echo "  /deps   - Check dependency freshness"
echo "  /test   - Run project tests"
echo "  /lint   - Run linters"
echo "  /fmt    - Format files"
echo "  /pr     - Create pull request"
echo ""
echo "Optional setup:"
echo "  - Teams notifications: Add webhook URL to ~/.claude/teams-webhook-url"
echo "  - Toggle Teams: ~/.claude/hooks/teams-toggle.sh [on|off]"
echo ""
echo "Get started:"
echo "  cd your-project && claude"
echo "  Then type: /ralph"
echo ""
