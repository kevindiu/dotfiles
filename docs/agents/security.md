# Security

**Scope**: Hardening, Secrets.

## Rules
- **SSH**: Port 2222, key-only, no root login.
- **Secrets**: Persist in `~/.aws`, `~/.git_tools`. NEVER in image.
- **Perms**: `scripts/init-volumes.sh` must enforce `700` on security dirs.
- **Runtime**: `no-new-privileges` enabled in compose.
