#!/bin/bash
# Dev Tooling Installer for Claude Code
# Interactive installer - pick what you want

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

echo "=================================="
echo "  Dev Tooling Installer"
echo "=================================="
echo ""

# Create base directories
mkdir -p ~/.claude/hooks
mkdir -p ~/.claude/commands
mkdir -p ~/.claude/logs

# Check for flags
ALL=false
HOOKS=false
COMMANDS=false
RALPH=false
SOUNDS=false
NOTIFICATIONS=false

# Parse arguments
for arg in "$@"; do
    case $arg in
        --all) ALL=true ;;
        --hooks) HOOKS=true ;;
        --commands) COMMANDS=true ;;
        --ralph) RALPH=true ;;
        --sounds) SOUNDS=true ;;
        --notifications) NOTIFICATIONS=true ;;
        --help)
            echo "Usage: ./install.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --all            Install everything"
            echo "  --ralph          Install /ralph and /deps commands only"
            echo "  --commands       Install all slash commands"
            echo "  --hooks          Install all hooks"
            echo "  --sounds         Install sound hooks only"
            echo "  --notifications  Install notification hooks only"
            echo ""
            echo "Run without options for interactive mode."
            exit 0
            ;;
    esac
done

# If no flags, go interactive
if ! $ALL && ! $HOOKS && ! $COMMANDS && ! $RALPH && ! $SOUNDS && ! $NOTIFICATIONS; then
    echo "What would you like to install?"
    echo ""
    echo "  1) Everything (recommended)"
    echo "  2) Just /ralph workflow (minimal - great for Cursor users)"
    echo "  3) Just hooks (sounds, notifications, auto-format)"
    echo "  4) Let me pick individually"
    echo ""
    read -p "Choice [1-4]: " choice

    case $choice in
        1) ALL=true ;;
        2) RALPH=true ;;
        3) HOOKS=true ;;
        4)
            read -p "Install /ralph and /deps commands? [Y/n] " yn
            [[ ! "$yn" =~ ^[Nn]$ ]] && RALPH=true

            read -p "Install other commands (/test, /lint, /fmt, /pr)? [Y/n] " yn
            [[ ! "$yn" =~ ^[Nn]$ ]] && COMMANDS=true

            read -p "Install sound hooks? [Y/n] " yn
            [[ ! "$yn" =~ ^[Nn]$ ]] && SOUNDS=true

            read -p "Install notification hooks (desktop, Teams)? [Y/n] " yn
            [[ ! "$yn" =~ ^[Nn]$ ]] && NOTIFICATIONS=true

            read -p "Install auto-format/lint/test hooks? [Y/n] " yn
            [[ ! "$yn" =~ ^[Nn]$ ]] && HOOKS=true
            ;;
        *) ALL=true ;;
    esac
fi

echo ""

# Install based on selections
if $ALL || $RALPH; then
    echo "Installing /ralph and /deps commands..."
    cp "$REPO_DIR"/commands/ralph.md ~/.claude/commands/
    cp "$REPO_DIR"/commands/deps.md ~/.claude/commands/
fi

if $ALL || $COMMANDS; then
    echo "Installing other commands..."
    cp "$REPO_DIR"/commands/test.md ~/.claude/commands/
    cp "$REPO_DIR"/commands/lint.md ~/.claude/commands/
    cp "$REPO_DIR"/commands/fmt.md ~/.claude/commands/
    cp "$REPO_DIR"/commands/pr.md ~/.claude/commands/
    cp "$REPO_DIR"/commands/deploy.md ~/.claude/commands/
fi

if $ALL || $HOOKS || $SOUNDS; then
    echo "Installing sound hooks..."
    cp "$REPO_DIR"/hooks/play-sound.sh ~/.claude/hooks/
    cp "$REPO_DIR"/hooks/play-permission-sound.sh ~/.claude/hooks/
    cp "$REPO_DIR"/hooks/play-error-sound.sh ~/.claude/hooks/
    chmod +x ~/.claude/hooks/play-*.sh
fi

if $ALL || $HOOKS || $NOTIFICATIONS; then
    echo "Installing notification hooks..."
    cp "$REPO_DIR"/hooks/desktop-notify.sh ~/.claude/hooks/
    cp "$REPO_DIR"/hooks/notify-teams.sh ~/.claude/hooks/
    cp "$REPO_DIR"/hooks/teams-toggle.sh ~/.claude/hooks/
    chmod +x ~/.claude/hooks/desktop-notify.sh ~/.claude/hooks/notify-teams.sh ~/.claude/hooks/teams-toggle.sh
fi

if $ALL || $HOOKS; then
    echo "Installing auto-format/lint/test hooks..."
    cp "$REPO_DIR"/hooks/auto-format.sh ~/.claude/hooks/
    cp "$REPO_DIR"/hooks/auto-lint.sh ~/.claude/hooks/
    cp "$REPO_DIR"/hooks/auto-test.sh ~/.claude/hooks/
    cp "$REPO_DIR"/hooks/protect-branch.sh ~/.claude/hooks/
    cp "$REPO_DIR"/hooks/log-session.sh ~/.claude/hooks/
    cp "$REPO_DIR"/hooks/track-cost.sh ~/.claude/hooks/
    chmod +x ~/.claude/hooks/*.sh
fi

# Handle settings.json
if $ALL || $HOOKS || $SOUNDS || $NOTIFICATIONS; then
    echo "Configuring settings.json..."
    SETTINGS_FILE=~/.claude/settings.json

    if [ -f "$SETTINGS_FILE" ]; then
        cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup"
        echo "  Backed up existing settings to settings.json.backup"
    fi

    if [ ! -f "$SETTINGS_FILE" ] || [ ! -s "$SETTINGS_FILE" ]; then
        cp "$REPO_DIR"/install/settings.json "$SETTINGS_FILE"
    else
        if command -v jq &> /dev/null; then
            MERGED=$(jq -s '.[0] * .[1]' "$SETTINGS_FILE" "$REPO_DIR/install/settings.json" 2>/dev/null) || MERGED=""
            if [ -n "$MERGED" ]; then
                echo "$MERGED" > "$SETTINGS_FILE"
            fi
        else
            echo "  Note: Install jq to auto-merge settings, or manually merge from install/settings.json"
        fi
    fi
fi

# Summary
echo ""
echo "=================================="
echo "  Installation Complete!"
echo "=================================="
echo ""
echo "Installed:"
($ALL || $RALPH) && echo "  - /ralph (smart workflow)"
($ALL || $RALPH) && echo "  - /deps (dependency checker)"
($ALL || $COMMANDS) && echo "  - /test, /lint, /fmt, /pr, /deploy"
($ALL || $HOOKS || $SOUNDS) && echo "  - Sound hooks"
($ALL || $HOOKS || $NOTIFICATIONS) && echo "  - Notification hooks"
($ALL || $HOOKS) && echo "  - Auto-format/lint/test hooks"
echo ""
echo "Get started: cd your-project && /ralph"
echo ""
