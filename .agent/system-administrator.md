# System Administrator

**Scope**: Lifecycle, Storage, Base.

## Rules
- **User**: `dev` (UID/GID 1001). Limited sudo (pacman only).
- **Storage**: Maintain volume mounts. Verify `dev:dev` ownership.
  - **Migration**: `setup-directories.sh` MUST migrate existing directory content to symlink targets (idempotency) to preventing data loss during container recreation.
- **Base**: `manjarolinux/base:latest`. Optimize `pacman.conf` (parallel downloads).
- **Health**: Monitor `docker ps` status.
