#!/bin/bash
# Dev Tooling Uninstaller
# Removes hooks and commands (preserves settings and logs)

echo "=================================="
echo "  Dev Tooling Uninstaller"
echo "=================================="
echo ""

read -p "This will remove dev-tooling hooks and commands. Continue? [y/N] " confirm
if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo "Removing hooks..."
rm -f ~/.claude/hooks/play-sound.sh
rm -f ~/.claude/hooks/play-permission-sound.sh
rm -f ~/.claude/hooks/play-error-sound.sh
rm -f ~/.claude/hooks/desktop-notify.sh
rm -f ~/.claude/hooks/notify-teams.sh
rm -f ~/.claude/hooks/auto-format.sh
rm -f ~/.claude/hooks/auto-lint.sh
rm -f ~/.claude/hooks/auto-test.sh
rm -f ~/.claude/hooks/log-session.sh
rm -f ~/.claude/hooks/track-cost.sh
rm -f ~/.claude/hooks/protect-branch.sh
rm -f ~/.claude/hooks/teams-toggle.sh

echo "Removing commands..."
rm -f ~/.claude/commands/ralph.md
rm -f ~/.claude/commands/deps.md
rm -f ~/.claude/commands/test.md
rm -f ~/.claude/commands/lint.md
rm -f ~/.claude/commands/fmt.md
rm -f ~/.claude/commands/pr.md
rm -f ~/.claude/commands/deploy.md

echo ""
echo "Uninstall complete."
echo ""
echo "Preserved:"
echo "  - ~/.claude/settings.json (may need manual cleanup)"
echo "  - ~/.claude/logs/"
echo "  - ~/.claude/teams-webhook-url"
