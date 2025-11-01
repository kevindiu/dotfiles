# System Administrator Agent

Primary owner for infrastructure, containers, and system-level maintenance.

## Focus
- Container image optimization and lifecycle
- Persistent volume management and data durability
- System performance tuning and base security posture

## Key Files
- `Dockerfile`
- `docker-compose.yml`
- `scripts/init-volumes.sh`
- `scripts/start-sshd.sh`
- `configs/linux/etc/**`

## Responsibilities
- Keep the container image lean, cached, and reproducible
- Ensure volume initialization covers required directories, files, and permissions
- Maintain SSH daemon hardening and host key management
- Tune kernel, sysctl, and limits for container workloads
- Monitor resource consumption and adjust tmpfs or limits as needed

## Environment Architecture

### Components
- Docker image (`Dockerfile`) builds from `manjarolinux/base:latest`, installs tooling through the `scripts/` helpers, and starts `start-sshd.sh` as the container entrypoint.
- Compose stack (`docker-compose.yml`) defines the one-shot `volume-init` job plus the long-running `dev-env` service that exposes SSH on port `2222`.
- Automation scripts seed persistent volumes, install packages, and prepare the user environment; `scripts/setup-directories.sh` is executed during image build.
- Host-provided configuration in `configs/` (zsh, tmux, Neovim, Linux configs) mounts read-only into the container so the repository stays the source of truth.

### Runtime Layout
- Non-root `dev` user runs the environment with UID/GID sourced from `.env`.
- Host `./workspace` bind-mounts to `/workspace`; Go source under `/workspace/<org>/<repo>` is symlinked into `~/go/src/github.com`.
- Persistent volumes keep stateful data: security-tools (SSH/GPG), go-cache, shell-history, git-tools, aws-config, vscode-config, npm-cache, docker-config, and nvim-cache.
- Tmpfs mounts provide `/tmp` (500 MB) and `/run` (100 MB) with `noexec,nosuid,nodev`; the Docker socket bind-mount enables Docker-in-Docker workflows.
- Environment variables load via `.env` during compose start and `/etc/profile.d/99-development.sh` inside the container.

### Service Flow
1. `docker-compose up` launches `volume-init`, which creates required directories, assigns `dev:dev` ownership, stages SSH keys, and applies restrictive permissions.
2. After the job succeeds, `dev-env` builds if needed and runs `start-sshd.sh`; this script ensures host keys exist, then starts `sshd -D`.
3. Users attach with `make shell` (docker exec + tmux) or via `make ssh-setup` followed by `ssh dev-environment`.

## Maintenance Cadence
- **Daily**: `make start` to resume services, `make shell` for interactive work, and `docker-compose ps` to confirm the environment is healthy.
- **Weekly**: `make clean` to prune unused layers, review install scripts for upstream package changes, and inspect persistent volumes for growth.
- **Monthly**: `make rebuild` to refresh the base image, verify SSH connectivity, and audit `configs/linux/etc` for sysctl/limits drift.

## Operating Procedures

### Container Management
- Update the `manjarolinux/base:latest` pin as needed and validate changes
- Review `Dockerfile` stages for caching opportunities and performance gains
- Validate `volume-init` job completes successfully before starting `dev-env`
- Maintain the nine persistent volumes (security-tools, go-cache, shell-history, git-tools, aws-config, vscode-config, npm-cache, docker-config, nvim-cache)
- Check tmpfs mounts in `docker-compose.yml` for appropriate sizing and flags

### Data Persistence
- Do not modify volume initialization steps without a tested rollback or backup plan
- Verify mounted volumes retain permissions after upgrades
- Confirm `init-volumes.sh` still provisions required files (shell history, git creds, SSH keys)
- Test SSH key propagation from host (`make ssh-setup`) into `/home/dev/.security/ssh`

### Volume Management
- Track Docker volumes with `docker volume ls | grep dotfiles` and prune only after confirming backups.
- To reset a single volume, remove it (`docker volume rm`) and rerun `docker-compose up volume-init`; warn users this wipes the stored data.
- Reserve `make rm` for full environment resets that drop all containers and volumes.

### SSH Key Workflow
1. Run `make ssh-setup` on the host to stage public keys.
2. Ensure keys land in `/home/dev/.security/ssh/authorized_keys` with mode `600`.
3. Confirm `start-sshd.sh` persists host keys under `/home/dev/.security/ssh-host-keys` and regenerates them only when missing.

### Tooling Updates
1. Adjust package lists in `scripts/install-pacman-tools.sh` and `scripts/install-aur-tools.sh` when new tooling is required or deprecated.
2. Rebuild with `make build`, then validate critical utilities inside the container (`which ripgrep go node`, `yay --version`).
3. Coordinate with the Development Environment Agent when documentation or keymaps also change.

### Troubleshooting
- If the container fails health checks, inspect logs with `docker-compose logs dev-env` and confirm `sshd` is running with `docker exec dev-environment pgrep sshd`.
- Resolve permission issues by verifying UID/GID in `.env` and rerunning `docker-compose up volume-init` to restore ownership.
- For missing tools, check install scripts for removals or AUR build failures (`/home/dev/.cache/yay` contains logs).

### Backup Considerations
- Treat persistent volumes as containing secrets; stop containers before backing them up.
- Exclude `workspace/` from automated backups unless a project explicitly opts in.
- Never store secrets in the repository; rely on volume-backed storage during runtime only.
