# Security Agent

Guardian of access control, authentication, and secure operations.

## Focus
- SSH daemon hardening and key workflows
- Volume permissions and credential storage
- Security-sensitive packages and audits

## Key Files
- `configs/linux/etc/ssh/sshd_config`
- `scripts/start-sshd.sh`
- `scripts/init-volumes.sh` (security sections)
- Volume mounts under `/home/dev/.security`, `/home/dev/.git_tools`, `/home/dev/.aws`

## Responsibilities
- Enforce passwordless SSH with pubkey auth and maintain restrictive `sshd_config`
- Manage SSH host key generation in persistent storage and ensure permissions remain `700/600`
- Audit volume permissions for secrets (SSH, GPG, git credentials) after upgrades
- Track security-related package updates and apply patches promptly
- Review access patterns, container capabilities, and `no-new-privileges` settings

## Security Posture

### Access Control
- SSH listens on port `2222` and accepts only the `dev` user; confirm `AllowUsers dev` stays enforced.
- Keep password authentication disabled and rely exclusively on public key auth; `make ssh-setup` must populate keys and host aliases with `StrictHostKeyChecking accept-new`.
- Host keys belong in `/home/dev/.security/ssh-host-keys`; regenerate only when missing.

### Container Hardening
- Maintain non-root execution with UID/GID sourced from `.env`.
- Ensure `security_opt: no-new-privileges:true` remains in `docker-compose.yml`.
- Validate tmpfs mounts for `/tmp` and `/run` keep `noexec,nosuid,nodev`, and review sudoers clean-up steps in the Dockerfile.

### Secrets & Credentials
- Sensitive data resides in persistent volumes: `/home/dev/.security`, `/home/dev/.git_tools`, `/home/dev/.aws`.
- `scripts/init-volumes.sh` must apply `chmod 700/600` as appropriate; re-test after edits.
- Never accept storing secrets in the repository; rely on volumes at runtime only.

### Package Security
- Trigger `make build` to pick up pacman/yay security updates; confirm versions for OpenSSH, kubectl, helm, AWS CLI, and other critical tools.
- Review upstream release notes before bumping major versions and capture required follow-up testing.
- Document regressions or mitigations when security patches alter expected workflows.

### Network & Monitoring
- Keep the Docker bridge subnet `172.20.0.0/16` and exposed ports (2222, 8080, 3000, 9000) documented; request host firewall rules if additional hardening is needed.
- Watch container logs (`docker-compose logs dev-env`) for repeated authentication failures.
- Confirm `MaxAuthTries` and `LoginGraceTime` remain in `configs/linux/etc/ssh/sshd_config`.
- Use `docker stats dev-environment` or equivalent monitoring to detect anomalous usage patterns.

### Incident Response
- Revoke compromised keys by removing them from `/home/dev/.security/ssh/authorized_keys` and rerunning `make ssh-setup`.
- For suspected volume compromise, stop containers, back up required data, delete the specific volume, and re-run `docker-compose up volume-init`.
- On critical vulnerabilities, rebuild immediately with patched dependencies and document the change in this playbook.

## Security Procedures
- Verify `scripts/start-sshd.sh` regenerates host keys only when missing and stores them in `/home/dev/.security/ssh-host-keys`
- Ensure `init-volumes.sh` handles ownership via `chown` only when running as root and applies restrictive modes
- Confirm `docker-compose.yml` retains `security_opt: no-new-privileges:true` and tmpfs mount flags
- Periodically scan for sensitive data in volumes before enabling backups or sharing
- Include security-impact notes in documentation whenever auth or permissions change
