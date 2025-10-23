# AI Agent Index for Dotfiles Repository

This repository delivers a Docker-based development environment with persistent tooling for Go and cloud-native work. Use this index to jump to the agent playbooks that outline current responsibilities and procedures.

**Important**: Document the **current state** only. Do not describe historical behaviour, deprecated settings, or removed features.
**Important**: Update the corresponding documentation immediately after every code or configuration change.

## How to Use This Index
- Start with the repository structure for high-level context
- Open the role-specific playbook that matches your responsibilities
- Review shared references (README, guides, scripts) before making changes
- Update the relevant playbook whenever configs or workflows change

## Agent Playbooks
- [System Administrator Agent](docs/agents/system-administrator.md)
- [Development Environment Agent](docs/agents/development-environment.md)
- [Security Agent](docs/agents/security.md)
- [Documentation Agent](docs/agents/documentation.md)
- [Build & Automation Agent](docs/agents/build-automation.md)

## Shared References
- `README.md` — user onboarding and daily usage
- `docs/NEOVIM_GUIDE.md` — Neovim usage instructions
- `docs/TMUX_GUIDE.md` — tmux usage instructions
- `Dockerfile`, `docker-compose.yml`, `Makefile`, `.env`
- `scripts/` — automation entrypoints
- `configs/` — shell, editor, tmux, and Linux system configs

## 📁 Repository Structure

```
dotfiles/
├── README.md              # User documentation
├── agents.md              # This file - AI agent index
├── docs/
│   ├── NEOVIM_GUIDE.md    # Neovim usage guide
│   ├── TMUX_GUIDE.md      # tmux usage guide
│   ├── architecture.md    # System design documentation
│   ├── maintenance.md     # Operational procedures
│   ├── development.md     # Development workflows  
│   ├── security.md        # Security considerations
│   └── agents/            # Role-specific playbooks
├── Makefile               # Build and management commands
├── Dockerfile             # Container image definition
├── docker-compose.yml     # Service orchestration
├── .env                   # Environment configuration
├── .gitignore             # Git ignore patterns
├── configs/               # Configuration files
│   ├── .zshrc             # Zsh shell configuration
│   ├── nvim/              # Neovim configuration
│   │   └── init.lua       # Main Neovim config file
│   ├── .tmux.conf         # Tmux multiplexer configuration
│   └── linux/             # Linux system configurations
│       └── etc/           # System configuration files
│           ├── ssh/sshd_config                 # SSH daemon config
│           ├── profile.d/99-development.sh     # Environment variables
│           ├── sysctl.d/99-optimized.conf      # Kernel parameters
│           ├── security/limits.d/99-container.conf  # Resource limits
│           ├── locale.conf                     # Locale settings
│           └── timezone                        # Timezone config
└── scripts/               # Automation scripts
    ├── init-volumes.sh
    ├── install-pacman-tools.sh
    ├── install-aur-tools.sh
    ├── install-go-tools.sh
    ├── install-zsh-plugins.sh
    ├── setup-directories.sh
    └── start-sshd.sh
```

## Notes
- `workspace/` holds user projects and is not tracked in git
- Persistent volumes: security-tools, go-cache, shell-history, git-tools, aws-config, vscode-config, npm-cache, docker-config, nvim-cache
- Make targets provide the primary entrypoints (`make build`, `make shell`, `make ssh-setup`)

---

*This index is maintained by AI agents. Last updated: 2025-01-16*
