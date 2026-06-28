# Dotfiles Development Environment

A consistent, containerized development environment for Go, Cloud Native, and AI Agent development.

## Quick Start

```bash
cp .env.example .env  # customize if needed
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
| `make start` | Start existing containers |
| `make stop` | Stop containers |
| `make restart` | Restart containers (stop + start) |
| `make ssh-setup` | Configure SSH key authentication |
| `make ssh` | Connect via SSH |
| `make test` | Run smoke tests on the container |
| `make update` | Update system packages (via safe `sudo` shim) |
| `make rebuild` | Rebuild image with fresh dependencies (`--no-cache`) |
| `make clean` | Remove temporary build artifacts |
| `make rm` | Remove everything including volumes |
| `make logs` | Show container logs |
| `make status` | Show container and volume status |
| `make build-info` | Show build cache information |
| `make scan` | Scan container image with Trivy |
| `make backup` | Backup workspace and persistent volumes |
| `make restore` | Restore from a backup (`BACKUP=path/to/file.tar.gz`) |
| `make install` | Install auto-shell to host shell config |
| `make uninstall` | Remove auto-shell from host shell config |

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
- **Tmux**: `configs/.tmux.conf`
- **Starship Prompt**: `configs/starship.toml`
- **Neovim**: `configs/nvim/`
- **SSH**: `configs/linux/etc/ssh/sshd_config`
- **System Tuning**: `configs/linux/etc/`
- **Environment**: `.env.example` (copy to `.env` to customize)
- **Scripts**: `scripts/`
- **Docs**: `docs/` (User Guides), `.agent/` (AI Context)
- **CI**: `.github/workflows/ci.yml` (Hadolint + ShellCheck + Build)
