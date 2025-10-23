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

## Security Procedures
- Verify `scripts/start-sshd.sh` regenerates host keys only when missing and stores them in `/home/dev/.security/ssh-host-keys`
- Ensure `init-volumes.sh` handles ownership via `chown` only when running as root and applies restrictive modes
- Confirm `docker-compose.yml` retains `security_opt: no-new-privileges:true` and tmpfs mount flags
- Periodically scan for sensitive data in volumes before enabling backups or sharing
- Include security-impact notes in documentation whenever auth or permissions change

