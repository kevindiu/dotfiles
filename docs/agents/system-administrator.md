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
- Treat `README.md > Repository Structure` as the canonical layout; update that first when shape changes.
- `Dockerfile` builds from `manjarolinux/base:latest`, installs tooling with the `scripts/` helpers, and launches `start-sshd.sh`.
- `docker-compose.yml` runs the `volume-init` job before starting the long-lived `dev-env` service (SSH on port 2222).
- Host configs under `configs/` mount read-only; automation lives in `scripts/` (`setup-directories.sh` executes during image build).
- Runtime facts to keep accurate:
  - User: non-root `dev` with UID/GID sourced from `.env`.
  - Host `./workspace` bind-mounts to `/workspace`; Go projects symlink into `~/go/src/github.com`.
  - Persistent volumes: security-tools (SSH/GPG), go-cache, shell-history, git-tools, aws-config, vscode-config, npm-cache, docker-config, nvim-cache.
  - Tmpfs: `/tmp` (500 MB) and `/run` (100 MB) with `noexec,nosuid,nodev`; Docker socket bind-mount enables Docker CLI usage.

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
- Track Docker volumes with `docker volume ls | grep dotfiles`; prune or reset only after backups and user confirmation.
- To rebuild a single volume, `docker volume rm <name>` then `docker-compose up volume-init`; call out data loss risks up front.
- Defer to the Build & Automation playbook for `make rm` usage; align messaging before destructive runs.

### SSH Key Workflow
1. `make ssh-setup` stages public keys on the host.
2. Verify `/home/dev/.security/ssh/authorized_keys` owns the entry with mode `600`.
3. `scripts/start-sshd.sh` must persist host keys under `/home/dev/.security/ssh-host-keys` and regenerate only when missing.

### Tooling & Troubleshooting
- When install lists change (`scripts/install-*.sh`), rebuild with `make build` and spot-check critical binaries (`go`, `ripgrep`, `yay`).
- For container health issues, check `docker-compose logs dev-env` and confirm `sshd` is running (`docker exec dev-environment pgrep sshd`).
- Permission problems usually trace to UID/GID drift in `.env`; rerun `docker-compose up volume-init` to reapply ownership.

### Backup Expectations
- Treat every persistent volume as sensitive; stop containers before copying data.
- Exclude `workspace/` from automated backups unless a project opts in.
- Secrets must never leave the volume boundaries or enter the repository.
