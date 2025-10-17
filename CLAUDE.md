# Claude Code Project Configuration

@agents.md

## User Preferences

### Communication Style
- **Direct, no-fluff responses** - Skip marketing language and unnecessary elaboration
- **User-focused documentation** - Clear, actionable information only
- **Concise answers** - Answer what's asked, nothing more

### Documentation Guidelines
- **User guides focus on HOW TO USE** - Not configuration details or implementation
- **Current state only** - Document what exists now, not historical changes
- **README.md**: User-focused, essential information only
- **Technical docs**: Current state reference, actionable procedures

## Development Environment

### Primary Tools & Focus
- **Go development** - Primary programming language with full IDE experience
- **YAML editing** - Kubernetes manifests, Docker Compose files
- **Cloud-native development** - kubectl, helm, k9s, kubectx, stern
- **Container-based workflow** - Docker development environment

### Vim Configuration
- **Main editor for Go development** - Fully configured with gopls, CoC.nvim
- **Live documentation preview** - Show docs during completion navigation
- **Usage-focused guides** - VIM_GUIDE.md should explain shortcuts and workflows, not config

## Automatic Documentation Updates

**CRITICAL RULE: Update documentation immediately after ANY changes**

### Mandatory Update Triggers
- ✅ Configuration file changes → Update relevant guides
- ✅ Tool additions/removals → Update README.md + guides  
- ✅ Vim/tmux modifications → Update guides (focus on usage)
- ✅ New capabilities → Update all relevant documentation
- ✅ User preference discoveries → Update CLAUDE.md

### Update Style Requirements
- **User guides**: Focus on HOW TO USE features
- **Technical docs**: Current configuration and procedures
- **No implementation details** in user-facing guides
- **Direct, actionable content** only

## Project Structure

### Key Files
- `configs/.vimrc` - Vim configuration (well-organized sections)
- `configs/.zshrc` - Shell configuration
- `configs/.tmux.conf` - Terminal multiplexer config
- `VIM_GUIDE.md` - How to use Vim for Go development
- `TMUX_GUIDE.md` - How to use tmux workflows
- `README.md` - User-focused setup and usage

### Data Persistence
- 9 persistent volumes for development data
- Code, configs, credentials saved across restarts
- Vim plugins cached to avoid reinstallation

## Development Workflows

### Go Development Pattern
1. Use `,f` (fuzzy finder) for file navigation
2. Use `,bg` for buffer switching
3. Use `,ga` to switch between Go files and tests
4. Live completion with documentation preview
5. Integrated debugging with delve

### Container Management
- `make build` - Initial setup
- `make shell` - Enter development environment
- `make ssh-setup` - Configure remote access
- Persistent data across rebuilds