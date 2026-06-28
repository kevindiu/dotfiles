# Development Environment

**Scope**: Shell, Neovim, Tools.

## Rules
- **Parity**: `configs/` must match user guides in `docs/`.
- **Neovim**: Neovim 0.10+ (Nightly). Maintain LSP (gopls, lua_ls), DAP (dlv), Neotest, and lazy bootstrapping.
- **Keybindings**: Any new plugin keybindings must be added to both the code (`keymaps.lua` or plugin config) and `docs/NEOVIM_GUIDE.md`.
- **Persistence**: `~/.vscode*`, `~/.antigravity`, `~/.gemini` must be persistent.
- **Symlinks**: Run `scripts/setup-directories.sh` to fix drift.
