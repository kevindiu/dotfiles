# Security

**Scope**: Hardening, Secrets.

## Rules
- **SSH**: Port 2222, key-only, no root login.
- **Secrets**: Persist in `~/.aws`, `~/.git_tools`. NEVER in image.
- **Perms**: `scripts/init-volumes.sh` must enforce `700` on security dirs.
- **Runtime**: `no-new-privileges` enabled in compose.

## Privilege Model
- **Sudo**: Minimal (`pacman`, `yay` only).
- **Docker-Root**: User dev has docker.sock access via docker-proxy. Note that container creation privileges on Docker socket effectively allow full host access; this setup is intended for a full-trust local development workstation.
- **Updates**: `yay` updates use `scripts/sudo-wrapper.sh` to leverage this Docker-Root access for package installation without password prompts.
