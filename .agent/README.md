# AI Agent Index

> **Rule**: Update all documents immediately after changes. Do not describe history.

## Project Context
This is a **Containerized Development Environment** built on Manjaro Linux (Arch).
- **Goal**: A reproducible, instant-on "Dev Machine" that runs anywhere (Mac/Linux).
- **Stack**: Docker, Go (Latest), Neovim/Antigravity (IDE-layer), Tmux, Zsh.
- **Philosophy**:
  - **Ephemeral Runtime**: The container (`dev-environment`) is disposable.
  - **Persistent Data**: All work, keys, and history live in Docker Volumes (see below).
  - **Security**: Rootless user `dev` (1001), SSH port 2222, minimal sudo.

## Persistent Volumes
- **Data**: `workspace`, `*-cache`
- **Config**: `aws-config`, `git-tools`, `docker-config`, `vscode-config`, `shell-history`
- **Security**: `security-tools` (keys, GPG)
- **AI**: `antigravity-cache`, `gemini-cache`
