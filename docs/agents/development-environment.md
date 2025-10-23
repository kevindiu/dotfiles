# Development Environment Agent

Owner for developer tooling, editor experience, and daily workflows.

## Focus
- Shell, editor, and tmux configuration quality
- Tool installation scripts and upgrade cadence
- Go-first developer experience with strong YAML support

## Key Files
- `configs/.zshrc`
- `configs/nvim/init.lua`
- `configs/.tmux.conf`
- `scripts/install-pacman-tools.sh`
- `scripts/install-aur-tools.sh`
- `scripts/install-go-tools.sh`
- `scripts/install-zsh-plugins.sh`
- `scripts/setup-directories.sh`

## Responsibilities
- Keep Neovim, tmux, and zsh configs aligned with current workflow conventions
- Ensure installation scripts stay idempotent and fast, and prune unused tools
- Maintain Go tooling (gopls, delve) and ensure caches map to persistent volumes
- Validate Telescope, TreeSitter, and LSP integrations for Go and YAML
- Guarantee `setup-directories.sh` covers symlinks, VS Code data, and Go cache links

## Tool Updates
- Track pacman packages (ripgrep, fd, bat, go, nodejs, kubectl, helm, kubectx, stern, yamllint, etc.) for version drift
- Refresh AUR packages (neovim-nightly-bin, tfenv, aws-cli-bin, k9s, oh-my-zsh-git) and handle breaking changes
- Update Go tools (`gopls`, `dlv`) and confirm new versions work with existing configs
- Review zsh plugin repos for upstream changes that may require config tweaks

## Workflow Validation
- Confirm Neovim keybindings for `,f`, `,bg`, `,rg`, diagnostics (`]d`/`[d`, `,e`), and Telescope align with `../NEOVIM_GUIDE.md`
- Ensure tmux prefix, pane shortcuts, mouse support, and history persistence match `../TMUX_GUIDE.md`
- Validate auto-entry behaviour in `.zshrc` and the `make install` target
- Keep documentation guides aligned with actual keymaps and scripts
