# Dotfiles Development Environment

A consistent, containerized development environment for Go, Cloud Native, and AI Agent development.

## Quick Start

```bash
make build
make shell
```

## Features

- **Base System**: Manjaro Linux (Rolling)
- **Languages**: Go (Latest), Node.js, Python
- **Cloud Tools**: AWS CLI, Terraform, Kubernetes (kubectl, helm, k9s)
- **Editors**: Neovim (Language Server Protocol configured), VS Code Remote ready
- **Data Persistence**:
  - Source code (`/workspace`)
  - Shell history & Configs
  - **AI Agent Context** (`~/.antigravity`, `~/.gemini`)
- **Transport**: SSH Server with Docker socket forwarding

## Commands

| Command | Description |
|---------|-------------|
| `make build` | Build and start the environment |
| `make shell` | Enter container shell (tmux/zsh) |
| `make ssh-setup` | Configure passwordless SSH access |
| `make ssh` | Connect via SSH |
| `make update` | Update system packages |
| `make clean` | Remove temporary build artifacts |

## SSH & Remote Access

To enable passwordless SSH (required for VS Code Remote):

```bash
make ssh-setup
ssh dev-environment
```

## Configuration

- **Zsh**: `configs/.zshrc`
- **Neovim**: `configs/nvim/init.lua`
- **Tmux**: `configs/.tmux.conf` (Safe mode: `touch ~/.no_auto_tmux` to disable auto-start)
