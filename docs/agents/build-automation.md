# Build & Automation

**Scope**: Makefile, Scripts, Dockerfile.

## Rules
- **Makefile**: Must support `build`, `shell`, `ssh` (port 2222), `rebuild`.
- **Scripts**: Must be idempotent and robust (set -euo pipefail).
- **Cache**: specific build args (`--no-cache`) for security updates.
- **Health**: `make build` must work from clean state (`make rm`).
