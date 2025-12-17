# AI Agent Index

> **Rule**: Update immediately after changes. Do not describe history.

## Playbooks
- [SysAdmin](docs/agents/system-administrator.md): Container, Storage, Access.
- [DevEnv](docs/agents/development-environment.md): Shell, Neovim, Tools.
- [Security](docs/agents/security.md): Secrets, Hardening (port 2222).
- [Docs](docs/agents/documentation.md): README=Truth.
- [Build](docs/agents/build-automation.md): Makefile, CI/CD.
- [Coding](docs/agents/coding.md): Comment rules ("Why vs What").

## Persistent Volumes
- **Data**: `workspace`, `*-cache`
- **Config**: `aws-config`, `git-tools`, `docker-config`, `vscode-config`, `shell-history`
- **Security**: `security-tools` (keys, GPG)
- **AI**: `antigravity-cache`, `gemini-cache`
