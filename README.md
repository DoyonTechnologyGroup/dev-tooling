# Dev Tooling for Claude Code & Cursor

A comprehensive set of automations, hooks, and the Ralph workflow for AI-assisted development.

## Quick Install

```bash
git clone https://github.com/DoyonTechnologyGroup/dev-tooling.git
cd dev-tooling && ./install/install.sh
```

Or if you already have the repo:

```bash
./install/install.sh
```

## What You Get

### Slash Commands

| Command | Purpose |
|---------|---------|
| `/ralph` | Smart workflow - bootstraps projects, plans features, executes tasks, records lessons |
| `/deps` | Check for outdated dependencies and security issues |
| `/test` | Run project tests |
| `/lint` | Run linters |
| `/fmt` | Format all files |
| `/pr` | Create pull request with summary |

### Hooks (Claude Code)

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
| `teams-toggle.sh` | Utility | Toggle Teams notifications on/off |

## The Ralph Workflow

Ralph is a structured workflow for AI-assisted development that works across tools.

### How It Works

Just type `/ralph` - it figures out what to do based on context:

| Context | What Happens |
|---------|--------------|
| New project (no scaffold) | Bootstraps CLAUDE.md, docs/, lessons/, checks.yml |
| Scaffold exists, no tasks | Enters planning mode |
| Tasks defined | Executes next task |
| Task in progress | Resumes interrupted work |
| Something failed | Records a lesson |

### Cross-Tool Compatibility

When `/ralph` bootstraps a project, it creates:

- `CLAUDE.md` - The rules (source of truth)
- `docs/ralph-workflow.md` - Full workflow spec
- `.cursorrules` - Pointer file for Cursor
- `.github/copilot-instructions.md` - Pointer file for Copilot

**One source of truth, works everywhere.** Your Claude Code work is compatible with Cursor users.

### The Lesson System

Ralph learns from mistakes:

1. Task fails twice → Automatic lesson recorded
2. You say "that's wrong" → Lesson recorded
3. Same lesson 3+ times → Promoted to permanent rule in CLAUDE.md

Lessons compound. The project gets smarter over time.

## Setup

### Teams Notifications (Optional)

1. Create an Incoming Webhook in Teams:
   - Channel → Manage channel → Connectors → Incoming Webhook → Configure
   - Copy the webhook URL

2. Save it:
```bash
echo "YOUR_WEBHOOK_URL" > ~/.claude/teams-webhook-url
```

3. Toggle on/off:
```bash
~/.claude/hooks/teams-toggle.sh on   # Enable
~/.claude/hooks/teams-toggle.sh off  # Disable
~/.claude/hooks/teams-toggle.sh      # Toggle
```

### View Logs

```bash
# Session history
cat ~/.claude/logs/sessions.log

# Token usage
cat ~/.claude/logs/usage.csv
```

## Project Templates

Quickly scaffold new projects:

```bash
./scripts/new-project.sh python my-api
./scripts/new-project.sh nextjs my-app
./scripts/new-project.sh streamlit my-dashboard
```

## Customization

### Sound Files (macOS)

```bash
export CLAUDE_DONE_SOUND="/path/to/sound.aiff"
export CLAUDE_PERMISSION_SOUND="/path/to/sound.aiff"
export CLAUDE_ERROR_SOUND="/path/to/sound.aiff"
```

### Disable Specific Hooks

Edit `~/.claude/settings.json` to remove or comment out hooks.

## Uninstall

```bash
./install/uninstall.sh
```

## File Structure

```
~/.claude/
├── settings.json
├── hooks/
│   └── *.sh
├── commands/
│   └── *.md
├── logs/
│   ├── sessions.log
│   └── usage.csv
└── teams-webhook-url

# Per-project (created by /ralph)
your-project/
├── CLAUDE.md              # Project rules
├── .cursorrules           # Pointer for Cursor
├── .github/
│   └── copilot-instructions.md
├── docs/
│   ├── ralph-workflow.md  # Full workflow spec
│   ├── prd.json           # Tasks and state
│   ├── plan.md            # Current plan
│   └── progress.md        # Execution log
├── lessons/
│   └── *.md               # Learned lessons
└── checks.yml             # Policy gates
```
