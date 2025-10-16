# AI Agent Index for Dotfiles Repository

This repository provides a Docker-based development environment for consistent, portable development. This index helps AI agents understand the repository structure and maintenance responsibilities.

**Important**: All documentation in this repository focuses on **current state** only. Do not include historical changes, removed features, or deprecated configurations in any documentation files.

## 📁 Repository Structure

```
dotfiles/
├── agents.md              # This file - AI agent index
├── architecture.md        # System design documentation
├── maintenance.md         # Operational procedures
├── development.md         # Development workflows  
├── security.md           # Security considerations
├── README.md             # User documentation
├── Makefile              # Build and management commands
├── Dockerfile            # Container image definition
├── docker-compose.yml    # Service orchestration
├── .env                  # Environment configuration
├── .gitignore           # Git ignore patterns
├── configs/             # Configuration files
│   ├── .zshrc           # Zsh shell configuration
│   ├── .vimrc           # Vim editor configuration
│   ├── .tmux.conf       # Tmux multiplexer configuration
│   └── linux/           # Linux system configurations
│       └── etc/         # System configuration files
│           ├── ssh/sshd_config      # SSH daemon config
│           ├── profile.d/99-development.sh  # Environment variables
│           ├── sysctl.d/99-optimized.conf   # Kernel parameters
│           ├── security/limits.d/99-container.conf  # Resource limits
│           ├── locale.conf          # Locale settings
│           └── timezone             # Timezone config
└── scripts/             # Automation scripts
    ├── init-volumes.sh          # Volume initialization
    ├── install-pacman-tools.sh  # System package installation
    ├── install-aur-tools.sh     # AUR package installation
    ├── install-go-tools.sh      # Go development tools
    ├── install-zsh-plugins.sh   # Zsh plugin setup
    ├── setup-directories.sh     # Directory structure setup
    └── start-sshd.sh           # SSH daemon startup
```

## 🤖 AI Agent Roles & Responsibilities

### 1. **System Administrator Agent**
- **Focus**: Infrastructure, containers, and system-level maintenance
- **Key Files**: 
  - `Dockerfile`, `docker-compose.yml`
  - `scripts/init-volumes.sh`, `scripts/start-sshd.sh`
  - `configs/linux/etc/`
- **Responsibilities**:
  - Container image optimization
  - Volume management and persistence
  - System security hardening
  - Performance tuning

### 2. **Development Environment Agent**
- **Focus**: Developer tools, configurations, and workflows
- **Key Files**:
  - `configs/.zshrc`, `configs/.vimrc`, `configs/.tmux.conf`
  - `scripts/install-*-tools.sh`
  - `scripts/setup-directories.sh`
- **Responsibilities**:
  - Tool installation and configuration
  - Shell environment optimization
  - Editor and IDE integration
  - Development workflow enhancement

### 3. **Security Agent**
- **Focus**: Access control, authentication, and secure practices
- **Key Files**:
  - `configs/linux/etc/ssh/sshd_config`
  - `scripts/start-sshd.sh`
  - Volume permission configurations
- **Responsibilities**:
  - SSH configuration and key management
  - User permissions and access control
  - Security vulnerability assessment
  - Compliance with security best practices

### 4. **Documentation Agent**
- **Focus**: Maintaining accurate and helpful documentation
- **Key Files**:
  - `README.md`, `agents.md`, `*.md` files
  - Inline documentation in scripts and configs
- **Responsibilities**:
  - User-facing documentation updates
  - Code documentation and comments
  - Troubleshooting guides
  - Change log maintenance

### 5. **Build & Automation Agent**
- **Focus**: Build processes, CI/CD, and automation
- **Key Files**:
  - `Makefile`
  - All `scripts/` files
  - `.gitignore`, `.env`
- **Responsibilities**:
  - Build optimization and caching
  - Automation script maintenance
  - Dependency management
  - Performance monitoring

## 🔧 Common Maintenance Tasks

### Container Management
- Update base image versions (manjarolinux/base:latest)
- Optimize multi-stage build caching
- Manage 8 persistent volumes (security-tools, go-cache, shell-history, git-tools, aws-config, vscode-config, npm-cache, docker-config)
- Monitor resource usage and system limits

### Tool Updates
- Update Go tools (gopls, delve debugger)
- Refresh pacman packages (25 tools: ripgrep, fd, bat, go, nodejs, kubectl, helm, etc.)
- Update AUR packages (tfenv, aws-cli-bin, k9s, oh-my-zsh-git)
- Update zsh plugins (autosuggestions, syntax-highlighting)
- Maintain editor configurations (vim-go, YouCompleteMe, NERDTree)

### Security Updates
- Review and update SSH configurations
- Audit user permissions
- Update security-related packages
- Review access patterns

### Documentation
- Keep README.md synchronized with current state
- Update troubleshooting sections with current procedures
- Maintain accurate command references
- Focus on current configuration, not historical changes

## 🚨 Critical Considerations

### Data Persistence
- Never modify volume initialization without backup procedures
- Ensure persistent data remains accessible across updates
- Test volume mounting and permissions thoroughly

### Breaking Changes
- Always test changes in isolated environments
- Document any breaking changes in README.md
- Provide migration paths for existing users
- Consider backward compatibility

### Security
- Never commit secrets or credentials
- Maintain principle of least privilege
- Regular security audits of configurations
- Keep SSH and access configurations secure

## 📋 Quick Reference Commands

```bash
# Build and start environment
make build

# Enter development shell
make shell

# SSH setup for VS Code
make ssh-setup

# Clean and rebuild
make clean && make build

# Remove everything (dangerous)
make rm
```

## 🔗 Related Files

- `architecture.md` - Detailed system design and component relationships
- `maintenance.md` - Step-by-step maintenance procedures
- `development.md` - Development workflows and best practices
- `security.md` - Security policies and procedures
- `README.md` - User-facing documentation and usage instructions

## 📝 Documentation Standards

When updating documentation:
1. **Current state only** - Document what exists now, not what was removed or changed
2. **Clear and actionable** - Focus on procedures and current configuration
3. **User-focused vs Technical** - README.md for users, other .md files for technical details
4. **Architecture as reference** - `architecture.md` describes current system design
5. **Maintenance as procedures** - `maintenance.md` provides current operational steps

### **CRITICAL: Documentation Update Requirements**

**MANDATORY RULE: After making ANY changes to code, configuration, or scripts, you MUST:**
1. **Assess documentation impact** - Review which documentation files may be affected
2. **Update ALL relevant documentation** - Ensure documentation reflects the new reality
3. **Do this automatically** - Don't wait for user to request documentation updates

**Comprehensive update triggers:**
- **ANY file changes** → Check if documentation needs updates
- **Security changes** → Update `security.md` and `architecture.md`
- **Build process changes** → Update `architecture.md` and `maintenance.md`  
- **User-facing changes** → Update `README.md`
- **Tool additions/removals** → Update `architecture.md` and `README.md`
- **Configuration changes** → Update relevant technical documentation
- **Script modifications** → Update `maintenance.md` if procedures change
- **Docker changes** → Update `architecture.md` and possibly `README.md`
- **Environment variable changes** → Update `architecture.md`

**Documentation Update Process (AUTOMATIC):**
1. **After completing ANY task** - Always ask: "What documentation is now outdated?"
2. **Identify ALL affected files** - Don't miss any .md files that need updates
3. **Update technical accuracy** - Ensure all examples, commands, and descriptions are current
4. **Update user instructions** - Keep README.md aligned with actual functionality
5. **Validate completeness** - Ensure documentation tells the complete current story

---

*This index is maintained by AI agents. Last updated: 2025-01-16*