# Development Workflows

Practical guide for working inside the containerized environment.

## Environment Entry
- `make build` – build images and start services (first run or after updates).
- `make shell` – attach to `dev-env` via `docker exec`; launches tmux automatically.
- `make ssh-setup` then `ssh dev-environment` – remote access with key auth.
- `make stop` / `make start` – stop or resume containers without rebuilding.

## Workspace Layout
- Host `./workspace` is mounted at `/workspace` inside the container.
- Go projects live under `/workspace/<org>/<repo>`; symlinked to `~/go/src/github.com`.
- Go caches reside in persistent volume (`~/.go-cache`), symlinked to `~/go/pkg` and `~/.cache/go-build`.
- VS Code server files are persisted in `~/.vscode`; link maintained by `scripts/setup-directories.sh`.

## Neovim Usage
- Launch: `nvim` (aliased from `vim` and `vi`).
- Keybindings (leader `,`):
  - `,f` – file finder (Telescope)
  - `,bg` – buffer list
  - `,rg` – project search
  - `,e`, `]d`, `[d` – diagnostics
  - `,r`, `,b`, `,t`, `,tf` – Go run/build/test helpers
- Go files auto-format on save via `gopls`.
- YAML files use 2-space indentation with cursorline/column guides.
- Refer to `docs/NEOVIM_GUIDE.md` for full keymap and workflow details.

## tmux Usage
- Auto-started when entering the container from an interactive shell.
- Prefix is `Ctrl+a`; pane navigation uses Vim keys (`h/j/k/l`).
- Splits:
  - `Ctrl+a |` – vertical split
  - `Ctrl+a -` – horizontal split
- Persistent history stored in `/home/dev/.shell_history/tmux_history`.
- See `docs/TMUX_GUIDE.md` for additional layouts and shortcuts.

## Shell Environment
- Default shell: zsh with Oh My Zsh (`configs/.zshrc`).
- Autosuggestions and syntax highlighting installed via persistent plugins.
- `mkcd` helper creates and enters directories.
- Git aliases: `gs`, `ga`, `gc`, `gp`, etc.
- Auto-start tmux when launching an interactive shell (can be disabled by editing `.zshrc`).

## Common Tasks
- **Run Go tests**
  ```bash
  make shell
  cd /workspace/myproject
  go test ./...
  ```
- **Build Docker image from inside environment**
  ```bash
  make shell
  docker build -t my-image .
  ```
- **Use kubectl/helm/k9s**
  - Tools are installed by default; configure kubeconfig within the workspace.
- **Install additional tools (temporary)**
  ```bash
  make shell
  sudo pacman -S --noconfirm <package>
  ```
  *Persisted changes should go into the relevant install script before rebuilding.*

## Clean Up
- Exit tmux pane/window with `exit`; detach from tmux using `Ctrl+a d`.
- `make clean` removes stopped containers and prunes Docker caches.
- `make rm` removes containers and volumes (prompts before destructive action).
