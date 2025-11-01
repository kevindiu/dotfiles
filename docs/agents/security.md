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
- SSH only accepts the `dev` user on port 2222; keep `AllowUsers dev` and password auth disabled. `make ssh-setup` must provision keys and `StrictHostKeyChecking accept-new`. Host keys live at `/home/dev/.security/ssh-host-keys`; regenerate only when empty.

### Container Hardening
- Preserve non-root execution (UID/GID from `.env`), `security_opt: no-new-privileges:true`, and hardened tmpfs mounts (`/tmp`, `/run` with `noexec,nosuid,nodev`). Confirm sudoers cleanup stays in the final Docker layer.

### Secrets & Credentials
- Sensitive volumes: `/home/dev/.security`, `/home/dev/.git_tools`, `/home/dev/.aws`—the full map is in the System Administrator playbook. `scripts/init-volumes.sh` must leave files at `700/600`. Never move secrets into the repository.

### Package Security
- Use `make build` to pick up pacman/yay updates; verify key tools (OpenSSH, kubectl, helm, AWS CLI) post-upgrade. Capture release notes and regressions so the README or playbooks can flag follow-up actions.

### Network & Monitoring
- Keep the bridge subnet `172.20.0.0/16` and exposed ports (2222, 8080, 3000, 9000) accurate in the docs. Review `docker-compose logs dev-env` for auth noise, ensure `MaxAuthTries`/`LoginGraceTime` stay in `sshd_config`, and watch `docker stats dev-environment` for unusual resource spikes.

### Incident Response
- Remove compromised keys from `/home/dev/.security/ssh/authorized_keys`, rerun `make ssh-setup`, and note the action here.
- For a suspect volume, stop containers, back up required data, delete the specific volume, and rerun `docker-compose up volume-init`.
- Ship emergency rebuilds immediately when critical CVEs land and document the change.

## Security Procedures
- Verify `scripts/start-sshd.sh` regenerates host keys only when missing and stores them in `/home/dev/.security/ssh-host-keys`
- Ensure `init-volumes.sh` handles ownership via `chown` only when running as root and applies restrictive modes
- Confirm `docker-compose.yml` retains `security_opt: no-new-privileges:true` and tmpfs mount flags
- Periodically scan for sensitive data in volumes before enabling backups or sharing
- Include security-impact notes in documentation whenever auth or permissions change
