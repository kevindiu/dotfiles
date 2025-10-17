# Vim Guide for Go Development

Complete guide for using Vim as your primary Go development editor.

## Quick Start

Open Vim and start coding:
```bash
make shell          # Enter development environment
vim main.go         # Open your Go file
```

## Vim Modes

| Mode | Key | Purpose |
|------|-----|---------|
| Normal | `Esc` | Navigate and run commands |
| Insert | `i` | Type text |
| Visual | `v` | Select text |
| Command | `:` | Run Vim commands |

## Essential Navigation

### Basic Movement
```vim
h j k l              # Left, Down, Up, Right
w / b                # Forward/backward by word
0 / $                # Start/end of line
gg / G               # Top/bottom of file
Ctrl+f / Ctrl+b      # Page down/up
/{text}              # Search (n = next, N = previous)
```

### Jump Commands
```vim
*                    # Find word under cursor
#                    # Find word under cursor (backwards)
%                    # Jump to matching bracket
Ctrl+o / Ctrl+i      # Jump back/forward in jump list
```

## File & Buffer Management

### File Operations (Leader = `,`)
```vim
,f                   # Find files (fuzzy search)
,bg                  # Switch between buffers
,rg                  # Search text in files
Ctrl+n               # Toggle file tree
```

### Buffer Navigation  
```vim
,bn / ,bp            # Next/previous buffer
,bd                  # Close current buffer
,bl                  # List all buffers
:e filename          # Open file
```

### Window Management
```vim
,vs / ,hs            # Vertical/horizontal split
Ctrl+h/j/k/l         # Navigate between splits
,=                   # Resize splits evenly
Ctrl+w w             # Switch to next window
```

### Tab Management
```vim
,tn                  # New tab
,tc                  # Close tab
Tab / Shift+Tab      # Next/previous tab
```

## Go Development Shortcuts

### Build & Test
```vim
,r                   # Run Go program
,b                   # Build Go program
,t                   # Run all tests
,tf                  # Test current function
,c                   # Toggle test coverage
```

### Navigation & Documentation
```vim
,ds                  # Go to definition (split)
,dv                  # Go to definition (vertical)
,dt                  # Go to definition (tab)
,gd                  # Show documentation
,gi                  # Show type information
,gr                  # Find references
,ga                  # Switch between file and test
```

### Code Generation
```vim
,ie                  # Insert "if err != nil" block
```

### Debugging
```vim
,db                  # Toggle breakpoint
,dr                  # Start debugging
,dt                  # Debug tests
```

## Text Editing

### Basic Editing
```vim
i / a                # Insert before/after cursor
o / O                # New line below/above
dd                   # Delete line
yy                   # Copy line
p / P                # Paste below/above
u                    # Undo
Ctrl+r               # Redo
```

### Advanced Editing
```vim
ciw                  # Change inner word
di(                  # Delete inside parentheses
yi"                  # Copy text inside quotes
ca{                  # Change around braces
```

### Visual Mode
```vim
v                    # Character selection
V                    # Line selection
Ctrl+v               # Block selection
```

## Search & Replace

### Search
```vim
/pattern             # Search forward
?pattern             # Search backward
n / N                # Next/previous match
*                    # Search word under cursor
```

### Replace
```vim
:s/old/new           # Replace first in line
:s/old/new/g         # Replace all in line  
:%s/old/new/g        # Replace all in file
:%s/old/new/gc       # Replace with confirmation
```

## Git Integration

### Git Commands
```vim
,gs                  # Git status
,gc                  # Git commit
,gp                  # Git push
,gl                  # Git log
```

### Git Gutters
- `+` Green = Added lines
- `~` Yellow = Modified lines  
- `-` Red = Removed lines

## Go Development Workflows

### Starting a New Project
```vim
,f                   # Find/create main.go
i                    # Enter insert mode
# Type your Go code
:w                   # Save
,r                   # Run to test
```

### Test-Driven Development
```vim
,f                   # Open your Go file
,ga                  # Switch to test file
i                    # Write test
:w                   # Save
,tf                  # Run test function
,ga                  # Back to main file
i                    # Implement feature
,tf                  # Test again
```

### Debugging Workflow
```vim
,db                  # Set breakpoint on current line
,dr                  # Start debugger
# Use debugger commands to step through
```

### Code Exploration
```vim
# On any function/type:
,gd                  # Read documentation
,ds                  # Jump to definition
,gr                  # See all usages
```

## Useful Commands

### File Operations
```vim
:w                   # Save file
:w filename          # Save as filename
:q                   # Quit
:wq                  # Save and quit
:q!                  # Quit without saving
```

### Buffer Operations
```vim
:ls                  # List buffers
:b 2                 # Switch to buffer 2
:bd                  # Delete current buffer
:ba                  # Open all buffers in windows
```

### Configuration
```vim
:PlugInstall         # Install plugins
:PlugUpdate          # Update plugins
:PlugClean           # Remove unused plugins
:GoUpdateBinaries    # Update Go tools
```

## Pro Tips

### Efficient File Navigation
1. Use `,f` instead of file trees - much faster
2. Use `,bg` to switch between recently opened files
3. Use `,ga` to jump between Go files and tests

### Multi-File Editing
1. Open multiple files with `,f`
2. Use splits (`,vs`) to see files side-by-side
3. Use buffers (`,bn`) to switch quickly

### Go-Specific Tips
1. `,gd` on any function to understand what it does
2. `,gr` to see everywhere a function is used
3. `,ie` to quickly add error handling
4. Use `,tf` to test individual functions while developing

### Search Tips  
1. Use `,rg` to search across all files
2. Use `/` for in-file search
3. Use `*` to search for word under cursor

### Productivity Shortcuts
1. `ciw` to change a word quickly
2. `di(` to delete everything in parentheses
3. `.` to repeat last change
4. `u` to undo, `Ctrl+r` to redo

## Common Patterns

### Opening Multiple Related Files
```vim
,f                   # Open handler.go
,vs                  # Split vertically
,f                   # Open models.go in split
Ctrl+h               # Focus left split
,ga                  # Open handler_test.go
```

### Refactoring Function Names
```vim
*                    # Select function name
cgn newname          # Change and move to next
.                    # Repeat change
.                    # Repeat again (for each occurrence)
```

### Quick Error Handling
```vim
# After a function call that returns error:
,ie                  # Insert if err != nil block
```

This Vim setup provides a complete IDE experience optimized for Go development. Focus on using the fuzzy finder (`,f`) and buffer management (`,bg`) for the most efficient workflow.