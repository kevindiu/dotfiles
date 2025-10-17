# Development Environment Dotfiles

A complete, ready-to-use development environment that runs in Docker. Perfect for Go development, cloud-native projects, and general programming. No more "it works on my machine" - get a consistent development environment anywhere.

## 🚀 Quick Start

```bash
git clone https://github.com/kevindiu-kinto/dotfiles.git
cd dotfiles
make build
make shell
```

## 🛠 What's Included

### Development Tools
- **Go** (latest) + tools (gopls, dlv)
- **Node.js** + npm 
- **Kubernetes** - kubectl, helm, k9s, kubectx, stern
- **Cloud** - AWS CLI with SSO support
- **Terraform** (via tfenv)
- **Git** + GitHub CLI + GPG
- **Docker** + Compose with Docker-in-Docker
- **CLI Tools** - ripgrep, fd, bat, fzf, jq, yq, httpie, lazygit, zip

### Base System
- **Manjaro Linux** with latest packages
- **Zsh** with Oh My Zsh (default shell)
- **Tmux** for terminal multiplexing
- **Vim** with comprehensive Go development and YAML editing setup
- **SSH** server for remote access

### Key Features
- 🚀 **One Command Setup** - \`make build\` and you're ready to code
- 💾 **Persistent Data** - Your work, configs, and credentials are saved across restarts
- 🔑 **Remote Access Ready** - SSH server with key-based authentication
- 🐹 **Go Development** - Full IDE experience with gopls, delve debugger, syntax highlighting, auto-formatting, and comprehensive keybindings
- ☁️ **Cloud Development** - AWS CLI, kubectl, helm, and Terraform pre-configured
- 🐳 **Container Native** - Docker-in-Docker for building and testing containers
- ⚡ **Fast Startup** - Optimized builds with caching and parallel execution
- 🔒 **Security Hardened** - Restricted privileges and secure SSH configuration

## 📋 Commands

### Getting Started
```bash
make build           # Initial setup - builds and starts everything
make shell           # Enter your development environment
```

### Daily Usage
```bash
make start           # Start the environment (after stopping)
make stop            # Stop the environment (keeps your data)
make install         # Auto-enter container when opening terminal
```

### SSH Access
```bash
make ssh-setup       # Set up SSH key authentication (one-time setup)
make ssh             # Connect via SSH
```

### Maintenance
```bash
make clean           # Clean up Docker cache and temporary files
make build-info      # Show Docker build cache information
make rm              # Remove everything (⚠️ deletes all your work)
make help            # Show all available commands
```

## 🔐 SSH Access

### Option 1: Automatic Setup (Recommended)
```bash
make ssh-setup       # Handles everything automatically
```
Then connect: `ssh dev-environment`

### Option 2: Manual Setup
1. Add to `~/.ssh/config`:
   ```
   Host dev-environment
     HostName localhost
     Port 2222
     User dev
   ```
2. Connect: `ssh dev-environment`
3. Password: `dev`

The automatic setup creates SSH keys for passwordless access and handles all configuration.

### Use Cases
- Remote development from another machine
- VS Code Remote-SSH extension
- Terminal access from different locations
- Automated deployment scripts

## 💡 Tips

- **First time**: Run \`make build\` to set everything up
- **Daily use**: Just \`make shell\` to start coding
- **Remote access**: Use `make ssh-setup` once for passwordless SSH access
- **Auto-entry**: Run \`make install\` to automatically enter the container when you open a terminal
- **Persistent data**: Your code, Git config, AWS credentials, and shell history are saved between sessions

## 🗂 What Gets Persisted

Your development environment saves:
- All your code and projects in \`/workspace\`
- Git configuration and credentials
- SSH keys and GPG keys
- AWS credentials and config
- Shell history (zsh, bash, tmux)
- Go module cache and compiled binaries
- npm cache and global packages
- Vim plugins and configuration
- Editor extensions and settings

## 🔧 Customization

- **Shell config**: Edit \`configs/.zshrc\`
- **Neovim config**: Edit `configs/nvim/init.lua`
- **Tmux config**: Edit \`configs/.tmux.conf\` (see \`TMUX_GUIDE.md\` for usage)
- **Add tools**: Modify \`scripts/install-*-tools.sh\`

## 🐛 Troubleshooting

**Container won't start?**
```bash
make clean && make build
```

**SSH connection issues?**
```bash
make ssh-setup  # Resets SSH configuration
```

**Want to start fresh?**
```bash
make rm         # ⚠️ This deletes everything
make build      # Rebuild from scratch
```
