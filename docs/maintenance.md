# Maintenance

Operational procedures for keeping the development environment healthy and current.

## Regular Tasks
- **Daily**
  - `make start` to launch containers if stopped.
  - `make shell` for interactive work; detach with `exit` when done.
  - `docker-compose ps` or `make status` to confirm service health.
- **Weekly**
  - `make clean` to prune unused Docker layers without touching volumes.
  - Review `scripts/install-*-tools.sh` for upstream updates and adjust package lists.
  - Check persistent volumes for excessive growth.
- **Monthly**
  - Refresh base image by running `make build` (triggers Dockerfile rebuild).
  - Verify SSH access (`make ssh-setup` then `ssh dev-environment`) still succeeds.
  - Audit `configs/linux/etc` for required sysctl/limits tuning.

## Updating Tooling
1. Update package lists in `scripts/install-pacman-tools.sh` or `scripts/install-aur-tools.sh`.
2. Rebuild image: `make build`.
3. Confirm tools inside container:
   ```bash
   make shell
   which ripgrep go node
   yay --version
   ```
4. Update `docs/NEOVIM_GUIDE.md` or other guides if keybindings or tooling behaviour changes.

## Volume Management
- Volumes are managed by Docker Compose; inspect with `docker volume ls | grep dotfiles`.
- To reset a single volume:
  ```bash
  docker volume rm dotfiles_security-tools
  docker-compose up volume-init
  ```
  *This wipes data for that volume—ensure backups before removal.*
- For full reset, use `make rm` (prompts before deleting containers and volumes).

## SSH Key Workflow
1. Run `make ssh-setup` on the host to generate/upload keys.
2. The script places public keys in `~/.ssh/dev-environment.pub` and installs them into `/home/dev/.security/ssh/authorized_keys`.
3. `start-sshd.sh` ensures host keys live in `/home/dev/.security/ssh-host-keys`.
4. Test login via `ssh dev-environment`.

## Troubleshooting
- **Container fails healthcheck**
  - `docker-compose logs dev-env`
  - Confirm `sshd` running: `docker exec dev-environment pgrep sshd`
- **Permissions issues**
  - Validate UID/GID in `.env`.
  - Re-run `docker-compose up volume-init` to reset ownership and permissions.
- **Tool missing**
  - Check install scripts for removed package.
  - Rebuild image; if AUR install failed, inspect `yay` logs in `/home/dev/.cache/yay`.

## Backup Considerations
- Persistent volumes contain credentials and caches; back up after stopping containers.
- Exclude `workspace/` from automated backups unless explicitly required by the user.
- Never store secrets in the repository; volumes hold sensitive data at runtime.
