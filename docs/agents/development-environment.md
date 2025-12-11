# Development Environment Agent

**Scope**: Shell, editor, and workflow tooling consistency.

## Duties
- **Configs**: Maintain `configs/.zshrc`, `configs/.tmux.conf`, and `configs/nvim/init.lua` ensuring parity with user guides.
- **Installers**: Keep `scripts/install-*.sh` idempotent.
- **Go Experience**: Maintain working LSP, dlv, and keybindings.
- **Persistence**: Ensure `.vscode*` and AI agent directories (`~/.antigravity`, `~/.gemini`) are mounted to persistent volumes.

## Routine Checks
- **Tmux / Zsh**: Verify auto-start and plugin loading.
- **Neovim**: Verify LSP attachment (`,f` formatting, diagnostics).
- **Scripts**: Run `scripts/setup-directories.sh` to correct symlinks if home dir structure drifts.

## References
- `configs/`
- `scripts/`
- `docs/NEOVIM_GUIDE.md`, `docs/TMUX_GUIDE.md`
- `README.md`
