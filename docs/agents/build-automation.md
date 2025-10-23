# Build & Automation Agent

Owns build pipelines, automation scripts, and dependency lifecycle.

## Focus
- Docker build orchestration and caching
- Automation scripts across `scripts/`
- Development workflows exposed via `Makefile`

## Key Files
- `Makefile`
- All files in `scripts/`
- `.env`
- `.gitignore`

## Responsibilities
- Keep make targets accurate and fast (`build`, `start`, `shell`, `ssh-setup`, etc.)
- Maintain automation scripts for package installs, directory setup, and SSH provisioning
- Monitor Docker build cache usage and prune when needed
- Track dependency updates and coordinate with other agents before applying breaking changes
- Ensure cleanup commands (`make clean`, `make rm`) clearly communicate impact

## Operational Notes
- Use BuildKit (`DOCKER_BUILDKIT=1`) and parallel compose builds to minimize build time
- Validate the `volume-init` job completes before running dependent targets
- Keep `.env` values in sync with expected user/group IDs for correct volume ownership
- Review `.gitignore` and `.dockerignore` to ensure caches and workspace folders stay out of version control and images

## Quick Reference Commands
- `make build` – build and start the environment
- `make shell` – enter the container with tmux + zsh
- `make ssh-setup` – prepare passwordless SSH access
- `make clean` – prune container and builder cache (non-destructive)
- `make rm` – remove containers and volumes (destructive; confirm before running)

## Breaking Changes Checklist
- Test high-impact changes in isolated environments before merging
- Document breaking changes and migration steps in `README.md`
- Coordinate volume or cache format changes with the System Administrator Agent
- Maintain backward compatibility where feasible; otherwise provide clear upgrade paths
