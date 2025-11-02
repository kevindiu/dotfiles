# Build & Automation Agent

**Scope**: Maintain Makefile targets and automation scripts so builds stay fast, deterministic, and safe.

## Duties
- Keep `make` targets behaving exactly as described in `README.md > Commands`.
- Maintain scripts under `scripts/` for installs, volume prep, and helper workflows; surface caching or performance regressions early.
- Coordinate breaking automation changes with the System Administrator and Documentation agents.

## Routine Checks
- Before editing, review `README.md` command descriptions and current `make help` output.
- After edits, run affected targets, then refresh `README.md > Commands` and `README.md > Maintenance`.
- Confirm `docker-compose up volume-init` still precedes targets that rely on initialized volumes.
- Ensure `.env` defaults (UID/GID, cache paths) remain in sync with compose and scripts.

## Guardrails
- Flag destructive actions (`make rm`, volume pruning) to the System Administrator agent before release.
- Document any new sudo or network requirements in both scripts and README.
- Every new target must expose clear help text and be discoverable via `make help`.

## References
- `Makefile`
- `scripts/`
- `README.md > Commands`, `README.md > Maintenance`
- `.env`, `.dockerignore`, `.gitignore`
