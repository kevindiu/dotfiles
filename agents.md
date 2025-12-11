# AI Agent Index

This index guides AI agents to their specific playbooks.

**Current State Only**: Do not describe historical behavior. Update immediately after changes.

## Agent Playbooks
- [System Administrator](docs/agents/system-administrator.md): Container lifecycle, storage, base hardening.
- [Development Environment](docs/agents/development-environment.md): Shell, editors, languages, tools.
- [Security](docs/agents/security.md): Access control, secrets, runtime usage.
- [Documentation](docs/agents/documentation.md): Guides, README, indexes.
- [Build & Automation](docs/agents/build-automation.md): Makefile, CI/CD, scripts.

## Shared References
- `README.md`: Canonical user guide and command reference.
- `docker-compose.yml`: services, volumes, networks.
- `configs/`: User customizations (.zshrc, nvim, tmux).
- `scripts/`: Implementation details for setup/install.

## Persistent Volumes
- **Data**: `workspace`, `go-cache`, `npm-cache`, `nvim-cache`
- **Config**: `aws-config`, `git-tools`, `docker-config`, `vscode-config`, `shell-history`
- **Security**: `security-tools` (SSH host keys, GPG)
- **AI Context**: `antigravity-cache`, `gemini-cache`

*Last updated: 2025-12-12*
