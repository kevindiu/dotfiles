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

