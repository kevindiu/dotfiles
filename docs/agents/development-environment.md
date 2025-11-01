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

## Daily Workflows

### Environment Entry
- Use `README.md` sections **Quick Start** and **Daily Usage** as the canonical command reference (`make build`, `make shell`, `make start/stop`, `make ssh-setup`).
- Confirm `make shell` still auto-attaches to tmux; record deviations in `README.md` immediately.

### Workspace Layout
- Host `./workspace` mounts to `/workspace`; keep Go project layout guidance in sync with `README.md > What Gets Persisted`.
- `scripts/setup-directories.sh` must uphold symlinks into `~/go/src/github.com`; validate after changes to Go tooling or volume paths.

### Editor & Terminal Workflows
- Neovim (`nvim`) leader bindings should mirror `docs/NEOVIM_GUIDE.md`; audit after plugin or keymap changes.
- Ensure tmux prefix/key bindings, mouse support, and history persistence align with `docs/TMUX_GUIDE.md`.
- zsh features (autosuggestions, tmux auto-start) remain defined in `configs/.zshrc`; note adjustments in the README tips section as needed.

### Common Tasks
- Keep Go/Kubernetes workflows documented once in `README.md > Tips`; use this playbook only to flag automation or cache considerations.
- Capture any temporary package installs in the relevant `scripts/install-*-tools.sh` before release and mirror expectations in the README.

### Clean Up
- Keep cleanup behaviour (`make clean`, `make rebuild`) documented in `README.md > Maintenance`; ensure destructive commands reference Build & Automation guidelines before altering behaviour.
