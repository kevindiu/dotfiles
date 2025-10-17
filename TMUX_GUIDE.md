# Tmux Guide for Development

Complete guide for using Tmux as your terminal multiplexer for Go development and general productivity.

## What is Tmux?

Tmux lets you:
- Run multiple terminal sessions in one window
- Split your terminal into panes (side-by-side or stacked)
- Keep sessions running even when you disconnect
- Organize work into different sessions and windows

## Quick Start

```bash
tmux                 # Start new session
tmux new -s work     # Start named session "work"
tmux ls              # List sessions
tmux attach -t work  # Attach to "work" session
```

## Key Concepts

| Concept | Description |
|---------|-------------|
| **Session** | A collection of windows (like a workspace) |
| **Window** | Like a browser tab, contains panes |
| **Pane** | Split section of a window |
| **Prefix** | `Ctrl+a` (press before all tmux commands) |

## Essential Commands (Prefix = `Ctrl+a`)

### Session Management
```bash
tmux new -s name     # Create named session
tmux ls              # List sessions
tmux attach -t name  # Attach to session
tmux kill-session -t name  # Kill session

# Inside tmux:
Ctrl+a d            # Detach from session
Ctrl+a s            # List and switch sessions
```

### Window Management
```bash
Ctrl+a c            # Create new window (same directory)
Ctrl+a ,            # Rename window
Ctrl+a n            # Next window
Ctrl+a p            # Previous window
Ctrl+a 0-9          # Switch to window number
Ctrl+a &            # Kill window
Alt+Left/Right      # Quick window switching
```

### Pane Management (Split Windows)
```bash
Ctrl+a |            # Split vertically (same directory)
Ctrl+a -            # Split horizontally (same directory)
Ctrl+a h/j/k/l      # Navigate panes (vim-style)
Ctrl+a H/J/K/L      # Resize panes
Ctrl+a x            # Kill pane
Ctrl+a z            # Zoom/unzoom pane (full screen toggle)
```

### Copy Mode (Scrollback)
```bash
Ctrl+a v            # Enter copy mode
# In copy mode:
v                   # Start selection
y                   # Copy selection
r                   # Rectangle selection
q                   # Exit copy mode
Ctrl+a p            # Paste
```

## Go Development Workflows

### Basic Development Session
```bash
tmux new -s go-dev
# Window 1: Editor
vim main.go

Ctrl+a |            # Split vertically
# Right pane: Run/test
go run main.go

Ctrl+a -            # Split horizontally
# Bottom right: Monitor logs/output
tail -f app.log
```

### Multi-Project Setup
```bash
# Session for each project
tmux new -s project1
tmux new -s project2 
tmux new -s testing

# Switch between projects
Ctrl+a s            # List sessions
# Select project with arrow keys
```

### Testing Workflow
```bash
# Window 1: Code
vim handler.go

Ctrl+a c            # New window
# Window 2: Tests
vim handler_test.go

Ctrl+a |            # Split
# Right pane: Run tests
go test ./...

Ctrl+a -            # Split bottom
# Monitor test coverage
go test -cover ./...
```

### Full Development Layout
```bash
Ctrl+a |            # Split vertically (Code | Terminal)
# Left: Editor (Vim)
# Right: Terminal commands

Ctrl+a l            # Focus right pane
Ctrl+a -            # Split horizontally
# Top right: Build/run
# Bottom right: Tests

# Result:
# +----------+----------+
# |          |  Build   |
# |   Vim    +----------+
# |          |  Tests   |
# +----------+----------+
```

## Advanced Features

### Named Windows for Organization
```bash
Ctrl+a c            # New window
Ctrl+a ,            # Rename to "editor"

Ctrl+a c            # New window  
Ctrl+a ,            # Rename to "tests"

Ctrl+a c            # New window
Ctrl+a ,            # Rename to "logs"
```

### Session Templates
Create a startup script:
```bash
#!/bin/bash
# ~/go-session.sh
tmux new-session -d -s go-dev

# Window 1: Editor
tmux send-keys 'vim .' C-m

# Window 2: Tests
tmux new-window -t go-dev -n tests
tmux send-keys 'go test ./...' C-m

# Window 3: Build
tmux new-window -t go-dev -n build
tmux send-keys 'go build' C-m

# Attach to session
tmux attach-session -t go-dev
```

### Synchronize Panes
```bash
Ctrl+a :            # Command mode
setw synchronize-panes on   # Type in all panes simultaneously
setw synchronize-panes off  # Turn off
```

## Configuration Features

### Custom Key Bindings (Already Configured)
```bash
Ctrl+a |            # Vertical split (instead of %)
Ctrl+a -            # Horizontal split (instead of ")
Ctrl+a h/j/k/l      # Vim-style pane navigation
Ctrl+a H/J/K/L      # Resize panes
Alt+Left/Right      # Quick window switching
```

### Mouse Support
- Click to select panes
- Drag borders to resize panes
- Scroll to navigate history
- Right-click for context menu

### Persistent History
- Command history saved to `/home/dev/.shell_history/tmux_history`
- 10,000 lines of scrollback buffer
- History persists across container restarts

## Common Workflows

### Daily Development Startup
```bash
# Start your development session
tmux new -s dev

# Set up layout
Ctrl+a |            # Split for code/terminal
Ctrl+a h            # Focus left pane
vim .               # Open editor

Ctrl+a l            # Focus right pane  
Ctrl+a -            # Split for run/test
```

### Code Review Session
```bash
# Main window: Browse code
vim main.go

Ctrl+a c            # New window for testing changes
go run main.go

Ctrl+a c            # New window for git operations
git log --oneline
git diff HEAD~1
```

### Debugging Session  
```bash
# Window 1: Code with breakpoints
vim main.go

Ctrl+a c            # Window 2: Debugger
dlv debug

Ctrl+a c            # Window 3: Logs/output
tail -f debug.log
```

### Remote Development
```bash
# SSH into container with tmux
ssh dev-environment
tmux attach          # Resume previous session

# Or start new session
tmux new -s remote-work
```

## Productivity Tips

### Quick Session Management
```bash
# Create session for each project
alias tmux-go='tmux new -s golang'
alias tmux-api='tmux new -s api-server'  
alias tmux-web='tmux new -s webapp'

# Quick attach
alias ta='tmux attach'
alias tls='tmux ls'
```

### Window Layouts
```bash
Ctrl+a Space        # Cycle through layouts
Ctrl+a M-1          # Even horizontal
Ctrl+a M-2          # Even vertical
Ctrl+a M-3          # Main horizontal
Ctrl+a M-4          # Main vertical
```

### Copying from Tmux
```bash
# Method 1: Tmux copy mode
Ctrl+a v            # Enter copy mode
# Navigate and select text
v                   # Start selection
y                   # Copy

# Method 2: Mouse (with mouse mode enabled)
# Just select text with mouse, automatically copied

# Method 3: System clipboard
# Select text, then Ctrl+Shift+C (terminal shortcut)
```

## Troubleshooting

### Common Issues
```bash
# Config not loading
Ctrl+a r            # Reload config

# Panes not responding
Ctrl+a :            # Enter command mode
kill-server         # Restart tmux server

# Colors not working
# Check TERM variable in shell
echo $TERM          # Should show "screen-256color"
```

### Escape Sequences in Vim
```bash
# If Vim feels slow when pressing Esc:
# This is already configured (escape-time 10)
# But you can adjust if needed:
Ctrl+a :
set -s escape-time 1
```

## Useful Commands Reference

### Session Commands
```bash
tmux new -s name     # New named session
tmux ls              # List sessions
tmux attach -t name  # Attach to session
tmux kill-session -t name  # Kill session
tmux rename-session -t old new  # Rename session
```

### Window Commands
```bash
Ctrl+a c            # New window
Ctrl+a ,            # Rename window
Ctrl+a w            # List windows
Ctrl+a f            # Find window
Ctrl+a &            # Kill window
```

### Pane Commands
```bash
Ctrl+a %            # Split horizontal (default)
Ctrl+a "            # Split vertical (default)
Ctrl+a |            # Split vertical (custom)
Ctrl+a -            # Split horizontal (custom)
Ctrl+a x            # Kill pane
Ctrl+a !            # Break pane into window
```

### System Commands
```bash
Ctrl+a ?            # List all key bindings
Ctrl+a :            # Command prompt
Ctrl+a t            # Show time
Ctrl+a ~            # Show messages
```

## Best Practices

1. **Use named sessions** for different projects
2. **Organize windows by function** (code, tests, logs, etc.)
3. **Split panes strategically** - don't make them too small
4. **Use mouse when convenient** but learn keyboard shortcuts
5. **Detach rather than kill** sessions to preserve work
6. **Create startup scripts** for complex layouts
7. **Use zoom** (`Ctrl+a z`) when you need full screen focus

This tmux configuration is optimized for Go development with vim-style navigation and persistent history across container restarts.