# Architecture

Current system design for the Docker-based development environment.

## Components
- **Docker image (`Dockerfile`)**: builds from `manjarolinux/base:latest`, installs developer tooling via scripts, configures the `dev` user, and starts `start-sshd.sh`.
- **Compose stack (`docker-compose.yml`)**
  - `volume-init` one-shot job seeds persistent volumes using `scripts/init-volumes.sh`.
  - `dev-env` container runs the full development environment with SSH on port 2222.
- **Automation scripts (`scripts/`)**: shell helpers for package installation, directory setup, volume init, and SSH host-key management.
- **Configuration mounts (`configs/`)**: host-provided zsh, tmux, Neovim, and Linux system configs injected read-only into the container.

## Runtime Layout
- **User**: non-root `dev` (UID/GID 1001 by default) for daily work.
- **Workspace**: host `./workspace` bind-mounted to `/workspace` inside the container.
- **Persistent volumes**
  - security-tools → SSH keys, GPG, secrets (`/home/dev/.security`)
  - go-cache → module, build, and bin caches (`/home/dev/.go-cache`)
  - shell-history → shell/tmux history (`/home/dev/.shell_history`)
  - git-tools → Git credentials/config (`/home/dev/.git_tools`)
  - aws-config → AWS CLI state (`/home/dev/.aws`)
  - vscode-config → VS Code server files (`/home/dev/.vscode`)
  - npm-cache → npm cache (`/home/dev/.npm`)
  - docker-config → Docker CLI config (`/home/dev/.docker`)
  - nvim-cache → Neovim data (`/home/dev/.local/share/nvim`)
- **Tmpfs mounts**: `/tmp` (500 MB) and `/run` (100 MB) with `noexec,nosuid,nodev` for overlay performance and security.
- **Docker socket**: `/var/run/docker.sock` bind-mounted to enable Docker-in-Docker workflows.

## Service Flow
1. `docker-compose up` starts `volume-init`, which:
   - Creates volume directories/files.
   - Copies host SSH public key if present.
   - Applies ownership (`dev:dev`) and permissions.
2. After success, `dev-env` builds (if needed) and runs:
   - Executes `scripts/setup-directories.sh` during image build to create symlinks and permissions.
   - Launches `start-sshd.sh`, ensuring host keys exist in persistent storage, then runs `sshd -D`.
3. Users connect via `make shell` (docker exec + tmux) or SSH (`make ssh-setup` + `ssh dev-environment`).

## Configuration Injection
- Read-only mounts keep canonical configs in the repository (`configs/.zshrc`, `configs/nvim/init.lua`, `configs/.tmux.conf`, Linux configs under `configs/linux/etc`).
- Environment variables sourced from `.env` (UID/GID defaults, npm cache).
- Runtime environment variables loaded via `/etc/profile.d/99-development.sh`.

## Networking
- Bridge network `dev-network` with subnet `172.20.0.0/16`.
- Ports exposed: 2222 (SSH), 8080, 3000, 9000 for application testing.
- `security_opt: no-new-privileges:true` prevents privilege escalation inside the container.

## Build Optimizations
- BuildKit enabled via `make build`.
- Cache mounts for pacman/yay, npm, Go modules/build outputs, and zsh caches keep image rebuilds fast.
- Multi-stage Dockerfile separates base system, tooling install, and final configuration layers.

