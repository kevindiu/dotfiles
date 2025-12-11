# Security Agent

**Scope**: Access control, credentials, and runtime hardening.

## Duties
- **SSH**: Maintain strict sshd config (key-only, port 2222).
- **Secrets**: Ensure credentials live in persistent volumes (`~/.aws`, `~/.git_tools`), never in the image.
- **Updates**: Monitor security updates for base system and key tools (openssh, docker).
- **Runtime**: Audit `no-new-privileges` and capabilities.

## Routine Checks
- **Logs**: Watch `docker-compose logs` for auth failures.
- **Permissions**: Verify `scripts/init-volumes.sh` correctly sets `700` on security directories.

## References
- `configs/linux/etc/ssh/sshd_config`
- `scripts/init-volumes.sh`
- `docker-compose.yml`
