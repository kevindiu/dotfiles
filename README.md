# Dotfiles Development Environment

A consistent, containerized development environment for Go, Cloud Native, and AI Agent development.

## Quick Start

```bash
make build
make shell
```

## Features

- **Base System**: Manjaro Linux **Unstable** (Arch Linux Stable Sync)
- **Languages**: Go (Latest), Node.js (LTS), Python
- **Cloud Tools**: AWS CLI (Latest), Terraform, Kubernetes (kubectl, helm, k9s)
- **Editors**: Neovim (Language Server Protocol configured), VS Code Remote ready
- **Data Persistence**:
  - Source code (`/workspace`)
  - Shell history & Configs
  - **AI Agent Context** (`~/.antigravity`, `~/.gemini`)
- **Transport**: SSH Server with Docker socket forwarding
- **Security**: Hardened with `no-new-privileges` and a `sudo-wrapper` shim for safe updates.

## Commands

| Command | Description |
|---------|-------------|
| `make build` | Build and start the environment |
| `make shell` | Enter container shell (tmux/zsh) |
| `make ssh-setup` | Configure passwordless SSH access |
| `make ssh` | Connect via SSH |
| `make update` | Update system packages (via safe `sudo` shim) |
| `make clean` | Remove temporary build artifacts |

## SSH & Remote Access

To enable passwordless SSH (required for VS Code Remote):

```bash
make ssh-setup
ssh dev-environment
```

## Troubleshooting

**Permission Denied on Volumes?**
This environment runs as user `dev` (UID 1001). If your host files (e.g., `workspace/`) are owned by root or another UID, you will see permission errors.
- **Fix**: Run `sudo chown -R 1001:1001 workspace/` on your host.

## Configuration

- **Zsh**: `configs/.zshrc`
- **Configs**: `configs/`
- **Scripts**: `scripts/`
- **Docs**: `docs/` (User Guides), `.agent/` (AI Context)
