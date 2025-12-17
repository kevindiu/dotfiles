# Coding Standards

**Philosophy**: "Why, Not What".

## Rules
- **Comments**: Explain **context/reasoning**, not behavior.
  - ❌ `# Install package`
  - ✅ `# Use official repo for stability`
- **Shell**: `#!/bin/bash`, `set -euo pipefail`. Use emoji for UX.
- **Hacks**: Document *fixes* (e.g., `detach-on-destroy` logic).
