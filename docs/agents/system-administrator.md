# System Administrator Agent

**Scope**: Own container lifecycle, persistent storage, and base hardening for the development environment.

## Duties
- Keep `Dockerfile` and `docker-compose.yml` aligned with `agents.md > 📁 Repository Structure`.
- Maintain volume initialization (`scripts/init-volumes.sh`, `scripts/setup-directories.sh`) so ownership stays `dev:dev`.
- Manage SSH service posture through `scripts/start-sshd.sh` and `configs/linux/etc/**`.
- Track UID/GID expectations in `.env` and communicate changes to other agents.
- Oversee the `backup` and `restore` workflows to ensure data safety.

## Routine Checks
- After compose or Dockerfile edits, confirm `volume-init` runs before `dev-env` and SSH exposes port 2222 for user `dev` only.
- Review persistent volumes (security-tools, go-cache, shell-history, git-tools, aws-config, vscode-config, npm-cache, docker-config, nvim-cache) for correct mount paths and permissions.
- Ensure tmpfs mounts (`/tmp`, `/run` with `noexec,nosuid,nodev`) and the Docker socket bind do not drift.
- Re-run `docker-compose up volume-init` when `.env` UID/GID values change and record the update.
- Check `docker ps` to confirm the container status is `healthy` (verifying `sshd` is active).

## Guardrails
- Coordinate destructive actions (volume removal, `make rm`) with the Build & Automation agent.
- Never relax SSH or sysctl hardening without documenting the rationale and remediation.
- Back up sensitive volumes before structural changes or resets.

## References
- `Dockerfile`, `docker-compose.yml`
- `scripts/init-volumes.sh`, `scripts/start-sshd.sh`, `scripts/setup-directories.sh`
- `configs/linux/etc/**`
- `.env`, `agents.md > 📁 Repository Structure`, `agents.md > Notes`
