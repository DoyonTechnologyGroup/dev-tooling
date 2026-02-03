# Dev Tooling for Claude Code

A comprehensive set of automations, hooks, and templates for Claude Code.

## Features

### Hooks (`~/.claude/hooks/`)

| Hook | Event | Description |
|------|-------|-------------|
| `play-sound.sh` | Stop | Plays Glass sound when Claude finishes |
| `play-permission-sound.sh` | Notification | Plays Funk sound when permission needed |
| `play-error-sound.sh` | PostToolUseFailure | Plays Basso sound on tool errors |
| `desktop-notify.sh` | Notification | Shows native macOS notifications |
| `notify-teams.sh` | Stop | Sends Teams webhook notification |
| `auto-format.sh` | PostToolUse | Auto-formats files after edit/write |
| `auto-lint.sh` | PostToolUse | Runs linters and feeds errors to Claude |
| `auto-test.sh` | PostToolUse | Runs tests in background (async) |
| `log-session.sh` | Stop | Logs session info to sessions.log |
| `track-cost.sh` | Stop | Tracks token usage to usage.csv |
| `protect-branch.sh` | PreToolUse | Blocks edits on main/master branch |

### Custom Commands (`~/.claude/commands/`)

- `/test` - Run project tests
- `/lint` - Run linters
- `/fmt` - Format all files
- `/deploy` - Deploy project (detects platform)
- `/pr` - Create pull request with summary

### Project Templates (`templates/`)

- `python/` - Python project with Black, Ruff, pytest
- `nextjs/` - Next.js with Prettier, ESLint
- `streamlit/` - Streamlit app template

## Usage

### Create a New Project from Template

```bash
~/code/dev-tooling/scripts/new-project.sh python my-api
~/code/dev-tooling/scripts/new-project.sh nextjs my-app
~/code/dev-tooling/scripts/new-project.sh streamlit my-dashboard
```

### Set Up Teams Notifications

Create `~/.claude/teams-webhook-url` with your webhook URL:

```bash
echo "https://your-org.webhook.office.com/..." > ~/.claude/teams-webhook-url
```

### View Session Logs

```bash
cat ~/.claude/logs/sessions.log
```

### View Token Usage

```bash
cat ~/.claude/logs/usage.csv
```

## File Structure

```
~/.claude/
├── settings.json          # Global hooks config
├── hooks/
│   ├── play-sound.sh
│   ├── play-permission-sound.sh
│   ├── play-error-sound.sh
│   ├── desktop-notify.sh
│   ├── notify-teams.sh
│   ├── auto-format.sh
│   ├── auto-lint.sh
│   ├── auto-test.sh
│   ├── log-session.sh
│   ├── track-cost.sh
│   └── protect-branch.sh
├── commands/
│   ├── test.md
│   ├── lint.md
│   ├── fmt.md
│   ├── deploy.md
│   └── pr.md
├── logs/
│   ├── sessions.log
│   └── usage.csv
└── teams-webhook-url

~/code/dev-tooling/
├── templates/
│   ├── python/.claude/
│   ├── nextjs/.claude/
│   └── streamlit/.claude/
├── scripts/
│   └── new-project.sh
└── README.md
```

## Customization

### Sound Files

Set environment variables to use custom sounds:

```bash
export CLAUDE_DONE_SOUND="/path/to/sound.aiff"
export CLAUDE_PERMISSION_SOUND="/path/to/sound.aiff"
export CLAUDE_ERROR_SOUND="/path/to/sound.aiff"
```

### Disabling Hooks

Remove or comment out hooks in `~/.claude/settings.json` to disable them.

### Adding New Templates

1. Create a new directory under `templates/`
2. Add `.claude/settings.json` with project-specific hooks
3. Add `.claude/CLAUDE.md` with project instructions
