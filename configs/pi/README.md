# Pi Coding Agent Configuration

This directory exports global Pi Coding Agent configurations to the host system.
It is mounted into the container at `/home/dev/.pi/agent/`.

## Structure
- `settings.json`: Global settings (theme, thinking level, compaction rules).
- `keybindings.json`: Custom keybinding definitions for Pi TUI.
- `models.json`: Custom model definitions and API providers (optional).
- `agents/`: Custom subagent definition files (`<name>.md`).
- `auth.json`: Authentication credentials (git-ignored for security).
- `sessions/`: Local chat and task session history (git-ignored).

## Usage inside the Container
```bash
# Start an interactive Pi coding session
pi

# Run with a prompt
pi "Explain this codebase"

# Configure authentication or models
pi /login
pi /settings
```
