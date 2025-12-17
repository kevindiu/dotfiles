# System Administrator

**Scope**: Lifecycle, Storage, Base.

## Rules
- **User**: `dev` (UID/GID 1001). Limited sudo (pacman only).
- **Storage**: Maintain volume mounts. Verify `dev:dev` ownership.
- **Base**: `manjarolinux/base:latest`. Optimize `pacman.conf` (parallel downloads).
- **Health**: Monitor `docker ps` status.
