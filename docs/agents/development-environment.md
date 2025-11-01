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
- `make build` to build images and start services on first run or after dependency changes.
- `make shell` to attach via `docker exec`; the session auto-opens tmux.
- `make ssh-setup` followed by `ssh dev-environment` for remote access with staged keys.
- `make stop` / `make start` to pause or resume the stack without rebuilding.

### Workspace Layout
- Host `./workspace` mounts to `/workspace`; Go projects inside follow `/workspace/<org>/<repo>`.
- `scripts/setup-directories.sh` manages symlinks so Go code appears under `~/go/src/github.com`.
- Persistent caches live in `~/.go-cache`, `~/.vscode`, and other volume-backed directories; verify the links remain intact after upgrades.

### Editor & Terminal Workflows
- Neovim launches via `nvim` (aliases provided); ensure leader bindings such as `,f`, `,bg`, `,rg`, `,r`, `,b`, `,t`, and `,tf` remain accurate.
- Go files should format on save through `gopls`; YAML defaults to two spaces with guides.
- tmux prefix is `Ctrl+a`; maintain key bindings for splits (`|`, `-`) and pane navigation (`h/j/k/l`).
- zsh provides autosuggestions, syntax highlighting, and auto-start tmux; watch `configs/.zshrc` when adjusting plugins.

### Common Tasks
- Running Go tests:
  ```bash
  make shell
  cd /workspace/myproject
  go test ./...
  ```
- Building an application image from within the environment:
  ```bash
  make shell
  docker build -t my-image .
  ```
- Kubernetes tooling (kubectl, helm, k9s) ships in the image; ensure kubeconfig setup steps remain documented in `README.md`.
- Temporary tooling installs can use `sudo pacman -S --noconfirm <package>` but should be captured in install scripts for persistence.

### Clean Up
- Encourage users to exit tmux panes with `exit`, detach via `Ctrl+a d`, and rely on `make clean` for pruning unused Docker resources.
- `make rm` removes containers and volumes; update documentation when defaults or prompts change.
