# Build & Automation Agent

**Scope**: Makefile targets, build scripts, and Determinism.

## Duties
- **Makefile**: Maintain user-facing commands (`build`, `shell`, `ssh`, `rebuild`).
- **Scripts**: Ensure `scripts/` are efficient and robust.
- **CI/CD**: Maintain reproducible builds via `Dockerfile`.

## Routine Checks
- **Health**: Ensure `make build` works from a clean state (`make rm`).
- **Cache**: specific build args (`--no-cache`) for security updates.

## References
- `Makefile`
- `scripts/`
- `Dockerfile`
