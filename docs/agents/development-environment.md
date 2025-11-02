# Development Environment Agent

**Scope**: Keep shell, editor, and workflow tooling consistent with documented user experience.

## Duties
- Maintain `configs/.zshrc`, `configs/.tmux.conf`, and `configs/nvim/init.lua` so they match `README.md`, `docs/NEOVIM_GUIDE.md`, and `docs/TMUX_GUIDE.md`.
- Ensure installation scripts (`scripts/install-*.sh`, `scripts/setup-directories.sh`) stay idempotent and point caches at persistent volumes.
- Preserve Go-first ergonomics: working LSP/TreeSitter, Go keybindings, and VS Code server links.

## Routine Checks
- After config or script edits, run `make shell` to confirm tmux auto-start, Neovim keymaps (`,f`, `,bg`, `,rg`, diagnostics, Go helpers), and zsh plugins.
- Verify `scripts/setup-directories.sh` continues to wire Go cache, VS Code server, and workspace symlinks correctly.
- Update `README.md > Quick Start`, `README.md > Tips`, and both editor guides whenever behaviour changes.
- Promote temporary tooling into the relevant install script before release.

## Guardrails
- Add or remove keybindings only with matching updates in the Neovim/tmux guides.
- Notify Build & Automation and Documentation agents before removing tooling or altering default workflows.
- Keep changes compatible with UID/GID defaults supplied by the System Administrator agent.

## References
- `configs/.zshrc`, `configs/.tmux.conf`, `configs/nvim/init.lua`
- `scripts/install-pacman-tools.sh`, `scripts/install-aur-tools.sh`, `scripts/install-go-tools.sh`, `scripts/install-zsh-plugins.sh`, `scripts/setup-directories.sh`
- `README.md > Quick Start`, `README.md > Tips`
- `docs/NEOVIM_GUIDE.md`, `docs/TMUX_GUIDE.md`
