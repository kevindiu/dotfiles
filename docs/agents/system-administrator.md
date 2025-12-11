# System Administrator Agent

**Scope**: Container lifecycle, storage, and security hardening.

## Duties
- **Container**: Keep `Dockerfile` and `docker-compose.yml` optimized and secure.
- **Storage**: Maintain volume mounts and permissions (`init-volumes.sh`, `setup-directories.sh`).
- **Access**: Enforce SSH hardening (key-only, non-root, port 2222).
- **User**: Maintain `dev` user (UID/GID 1001) and limited sudo scope.

## Routine Checks
- **Health**: Monitor `docker ps` for `healthy` status.
- **Volumes**: Verify correct ownership (`dev:dev`) on all cache volumes.
- **Security**: Audit `no-new-privileges` and tmpfs mounts.

## References
- `Dockerfile`, `docker-compose.yml`
- `scripts/init-volumes.sh`, `scripts/start-sshd.sh`
- `configs/linux/etc/**`
