# Neovim Guide for Go Development & YAML Editing

Complete guide for using Neovim as your primary Go development editor with modern LSP features and TreeSitter syntax highlighting.

## Quick Start

Open Neovim and start coding:
```bash
make shell          # Enter development environment  
nvim main.go        # Open your Go file
nvim deployment.yaml # Open Kubernetes YAML file
```

## Neovim Modes

| Mode | Key | Purpose |
|------|-----|---------|
| Normal | `Esc` | Navigate and run commands |
| Insert | `i` | Type text |
| Visual | `v` | Select text |
| Command | `:` | Run Neovim commands |

## Essential Navigation

### Basic Movement
```vim
h j k l              # Left, Down, Up, Right
w / b                # Forward/backward by word
0 / $                # Start/end of line
gg / G               # Top/bottom of file
Ctrl+f / Ctrl+b      # Page down/up
/{text}              # Search (n = next, N = previous)
jj                   # Exit insert mode (alternative to Esc)
```

### Command Mode
```vim
;                    # Enter command mode (easier than :)
:                    # Repeat last f/F/t/T search
```

### Visual Enhancements
- **TreeSitter syntax highlighting** - Superior syntax highlighting for Go, YAML, JSON
- **Tokyo Night colorscheme** - Modern dark theme optimized for development
- **True color support** - Full 24-bit colors in terminal

### Jump Commands
```vim
*                    # Find word under cursor
#                    # Find word under cursor (backwards)
%                    # Jump to matching bracket
Ctrl+o / Ctrl+i      # Jump back/forward in jump list
gnn                  # Start TreeSitter text selection
```

## File & Buffer Management

### File Operations (Leader = `,`)
```vim
,f                   # Find files (Telescope fuzzy search)
,bg                  # Switch between buffers (Telescope)
,rg                  # Search text in files (Telescope live_grep)
,fh                  # Recent files history (Telescope)
Ctrl+p               # Alternative file finder
Ctrl+n               # Toggle file tree (nvim-tree)
```

### Buffer Navigation  
```vim
,bn / ,bp            # Next/previous buffer
,bd                  # Close current buffer
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

### Go Development with Native LSP

#### Build & Test
```vim
,r                   # Run Go program (terminal)
,b                   # Build Go program (terminal)
,t                   # Run all tests (terminal)
,tf                  # Test current function (interactive)
```

#### LSP Navigation & Documentation
```vim
K                    # Show documentation (LSP hover)
,gd / ,h             # Show documentation (alternative bindings)
,ds                  # Go to definition
,gr                  # Find all references (Telescope)
,gi                  # Find implementations (Telescope)
,gt                  # Find type definitions (Telescope)
,gs                  # Document symbols (current file)
,gw                  # Workspace symbols (project-wide search)
,rn                  # Rename symbol
,ca                  # Code actions
```

#### Navigation History
```vim
,,                   # Go back to previous location
,.                   # Go forward to next location
,jl                  # Show jump list (navigation history)
Ctrl+o               # Standard go back
Ctrl+i               # Standard go forward
```

#### Error Handling & Diagnostics
```vim
,e                   # Show error details (floating window)
]d                   # Go to next diagnostic/error
[d                   # Go to previous diagnostic/error
,dl                  # Show all diagnostics in location list
```

#### Error Indicators
- **✗** Red signs = Errors
- **⚠** Yellow signs = Warnings  
- **💡** Blue signs = Hints
- **ℹ** Info signs = Information
- **Virtual text** = Inline error messages
- **Underlines** = Problematic code sections

#### Code Completion
```vim
# Native LSP completion with nvim-cmp:
Tab / Shift+Tab      # Navigate completion menu
Enter               # Accept completion
Ctrl+Space          # Manual completion trigger
Esc                 # Cancel completion
```

#### TreeSitter Features
```vim
,ts                  # Show TreeSitter install info
,tu                  # Update TreeSitter parsers
gnn                  # Start incremental selection
grn / grm            # Expand/shrink selection
```

### YAML Editing Features

#### Auto-Formatting & Syntax
- **TreeSitter YAML parsing** - Advanced syntax understanding
- **2-space indentation** - Automatic YAML-standard spacing
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

### Advanced Editing with TreeSitter
```vim
ciw                  # Change inner word
di(                  # Delete inside parentheses
yi"                  # Copy text inside quotes
ca{                  # Change around braces
gnn                  # Select current node (TreeSitter)
```

### Visual Mode
```vim
v                    # Character selection
V                    # Line selection
Ctrl+v               # Block selection
```

## Search & Replace

### Telescope Search
```vim
,f                   # Find files by name
,rg                  # Live grep in all files
,bg                  # Search open buffers
,fh                  # Search file history
```

### In-File Search
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

### Git Commands (Fugitive)
```vim
,gs                  # Git status
,gc                  # Git commit
,gp                  # Git push
,gl                  # Git log
```

### Git Signs (Gitsigns.nvim)
- `+` Green = Added lines
- `~` Yellow = Modified lines  
- `_` Red = Removed lines

## Development Workflows

### Go Development with LSP

#### Starting a New Project
```vim
,f                   # Find/create main.go
i                    # Enter insert mode
# Type your Go code with LSP completion
:w                   # Save
,r                   # Run to test
```

#### Error-Driven Development
```vim
,f                   # Open your Go file
i                    # Write code
# LSP shows errors automatically
,e                   # View error details
]d                   # Jump to next error
# Fix error with LSP assistance
,ca                  # Use code actions if available
```

#### Code Exploration with LSP
```vim
# On any function/type:
K                    # Read documentation
,ds                  # Jump to definition
,gr                  # See all usages
,rn                  # Rename symbol
```

### YAML Development

#### Kubernetes Manifest Editing
```vim
,f                   # Find deployment.yaml
i                    # Edit manifest
# TreeSitter syntax highlighting active
:w                   # Save
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

## Plugin Management

### Lazy.nvim Commands
```vim
:Lazy                # Open plugin manager
:Lazy sync           # Install/update plugins
:Lazy clean          # Remove unused plugins
:Lazy profile        # Show startup times
```

### TreeSitter Commands
```vim
:TSUpdate            # Update all parsers
:TSInstall go        # Install specific parser
:TSInstallInfo       # Show installation status
:checkhealth nvim-treesitter # Check TreeSitter health
```

### LSP Commands
```vim
:LspInfo             # Show LSP status
:LspRestart          # Restart LSP servers
:checkhealth lsp     # Check LSP health
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

### Configuration & Maintenance
```vim
:Lazy sync           # Update plugins
:TSUpdate            # Update TreeSitter parsers
:checkhealth         # Check Neovim health
```

## Pro Tips

### Efficient File Navigation
1. Use `,f` (Telescope) instead of file trees - much faster
2. Use `,bg` to switch between recently opened files
3. Use `,rg` for project-wide text search

### Multi-File Editing
1. Open multiple files with `,f`
2. Use splits (`,vs`) to see files side-by-side
3. Use buffers (`,bn`) to switch quickly

### Go Development with LSP
1. `K` on any function to understand what it does (native LSP)
2. `,gr` to see everywhere a function is used
3. Use `,e` and `]d`/`[d` to navigate and fix errors
4. `,ca` for automated code fixes and refactoring

### Error Navigation
1. Errors show automatically with LSP diagnostics
2. Use `]d` and `[d` to jump between errors
3. Use `,e` to see detailed error information
4. Visual indicators make errors obvious

### TreeSitter Selection
1. Use `gnn` to start smart text selection
2. Use `grn` to expand selection to larger syntax nodes
3. Much more accurate than traditional vim text objects

## Common Patterns

### Opening Multiple Related Files
```vim
,f                   # Open handler.go
,vs                  # Split vertically
,f                   # Open models.go in split
Ctrl+h               # Focus left split
,f test              # Find and open test file
```

### LSP-Powered Refactoring
```vim
,ds                  # Go to definition
,rn                  # Rename symbol (all references)
,gr                  # Check all references before renaming
,ca                  # Use code actions for automated fixes
```

### Error-Driven Development
```vim
# Write code with intentional errors
i                    # Insert mode
# LSP shows errors automatically
Esc                  # Normal mode
]d                   # Jump to first error
,e                   # See error details
,ca                  # Try code action
# Fix manually if needed
]d                   # Next error
```

This Neovim setup provides a modern IDE experience with native LSP support, TreeSitter syntax highlighting, and Telescope fuzzy finding. The configuration emphasizes built-in Neovim features over external plugins for better performance and reliability.
