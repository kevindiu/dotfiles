# Vim Guide for Go Development & YAML Editing

Complete guide for using Vim as your primary Go development editor and for editing YAML files (Kubernetes manifests, Docker Compose, etc.).

## Quick Start

Open Vim and start coding:
```bash
make shell          # Enter development environment
vim main.go         # Open your Go file
vim deployment.yaml # Open Kubernetes YAML file
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

## Language-Specific Features

### Go Development Shortcuts

#### Build & Test
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

#### Code Completion & Intelligence
```vim
# Auto-completion with live documentation preview:
Tab / Shift+Tab      # Navigate completion menu (shows docs automatically)
Enter               # Accept completion
Ctrl+Space          # Manual completion trigger
Ctrl+d              # Show detailed documentation for current item
Esc                 # Cancel completion

# Code intelligence powered by CoC.nvim + gopls:
:CocInfo            # Check CoC status and configuration
:CocList extensions # Show installed extensions
:CocRestart         # Restart language server if needed
```

#### Code Generation
```vim
,ie                  # Insert "if err != nil" block
```

#### Debugging
```vim
,db                  # Toggle breakpoint
,dr                  # Start debugging
,dt                  # Debug tests
```

### YAML Editing Features

#### Auto-Formatting & Linting
- **2-space indentation** - Automatic YAML-standard spacing
- **Auto-format on save** - Fixes whitespace and trailing lines
- **yamllint integration** - Real-time syntax checking
- **Cursor guides** - Visual line and column indicators for alignment

#### YAML-Specific Navigation
```vim
zc                   # Fold YAML section
zo                   # Unfold YAML section
zR                   # Unfold all sections
zM                   # Fold all sections
```

#### Indentation Management
```vim
>>                   # Indent line (2 spaces)
<<                   # Un-indent line (2 spaces)
=                    # Auto-indent selected text
gg=G                 # Auto-indent entire file
```

#### YAML Validation
- Syntax errors highlighted automatically
- Invalid indentation marked with warnings
- Missing required fields flagged

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

## Development Workflows

### Go Development

#### Starting a New Project
```vim
,f                   # Find/create main.go
i                    # Enter insert mode
# Type your Go code
:w                   # Save
,r                   # Run to test
```

#### Test-Driven Development
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

#### Debugging Workflow
```vim
,db                  # Set breakpoint on current line
,dr                  # Start debugger
# Use debugger commands to step through
```

#### Code Exploration
```vim
# On any function/type:
,gd                  # Read documentation
,ds                  # Jump to definition
,gr                  # See all usages
```

### YAML Development

#### Kubernetes Manifest Editing
```vim
,f                   # Find deployment.yaml
i                    # Edit manifest
# Auto-indentation and linting active
:w                   # Save (auto-formats)
```

#### Working with Large YAML Files
```vim
# Navigate large Kubernetes manifests:
zM                   # Fold all sections
/apiVersion          # Search for specific sections
zR                   # Unfold all when needed

# Quick indentation fixes:
gg=G                 # Auto-indent entire file
V                    # Select lines
=                    # Fix indentation for selection
```

#### Multi-File YAML Management
```vim
# Open related YAML files:
,f                   # deployment.yaml
,vs                  # Split vertically
,f                   # service.yaml
,hs                  # Split horizontally  
,f                   # configmap.yaml

# Result: All related K8s resources visible simultaneously
```

#### YAML Validation Workflow
```vim
# Open YAML file - automatic linting active
vim deployment.yaml

# Fix highlighted syntax errors:
# - Red underlines = syntax errors
# - Yellow warnings = style issues
# - Cursor guides help with alignment

:w                   # Save triggers auto-format
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

### Configuration & Maintenance
```vim
:PlugInstall         # Install plugins
:PlugUpdate          # Update plugins  
:PlugClean           # Remove unused plugins
:GoUpdateBinaries    # Update Go tools
:CocUpdate           # Update CoC extensions
:CocInstall coc-go   # Reinstall Go extension if needed
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