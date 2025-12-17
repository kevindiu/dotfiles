.PHONY: help build rebuild start stop restart clean logs shell ssh status rm install uninstall scan update

BLUE := \033[0;34m
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

.DEFAULT_GOAL := help

help:
	@echo ""
	@echo "🐳 Development Environment Commands"
	@echo "=================================="
	@echo ""
	@printf "\033[1;33mBasic Commands:\033[0m\n"
	@printf "  \033[0;34mbuild\033[0m      Build and start the development environment\n"
	@printf "  \033[0;34mstart\033[0m      Start existing containers\n"
	@printf "  \033[0;34mstop\033[0m       Stop containers\n"
	@printf "  \033[0;34mrestart\033[0m    Restart containers (stop + start)\n"
	@echo ""
	@printf "\033[1;33mMaintenance:\033[0m\n"
	@printf "  \033[0;34mclean\033[0m          Clean cache and temporary data\n"
	@printf "  \033[0;34mrebuild\033[0m        Rebuild image with fresh dependencies\n"
	@printf "  \033[0;34mupdate\033[0m         Update pacman + AUR packages in the container\n"
	@printf "  \033[0;34mrm\033[0m             Remove everything including volumes\n"
	@echo ""
	@printf "\033[1;33mAccess:\033[0m\n"
	@printf "  \033[0;34mshell\033[0m      Open tmux session with zsh in container\n"
	@printf "  \033[0;34minstall\033[0m    Install auto-shell to host shell config\n"
	@printf "  \033[0;34muninstall\033[0m  Remove auto-shell from host shell config\n"
	@printf "  \033[0;34mssh\033[0m        Connect via SSH\n"
	@printf "  \033[0;34mssh-setup\033[0m  Set up SSH key authentication (no password)\n"
	@printf "  \033[0;34mlogs\033[0m       Show container logs\n"
	@printf "  \033[0;34mstatus\033[0m     Show container status\n"
	@printf "  \033[0;34mbuild-info\033[0m Show build cache information\n"
	@printf "  \033[0;34mscan\033[0m       Scan container image with Trivy\n"
	@echo ""
	@echo ""
	@printf "\033[1;33mBackup/Restore:\033[0m\n"
	@printf "  \033[0;34mbackup\033[0m     Backup workspace and persistent volumes to ./backups\n"
	@printf "  \033[0;34mrestore\033[0m    Restore from a backup file\n"
	@echo ""

build:
build:
	@echo "$(BLUE)[BUILD]$(NC) Building development environment..."
	@echo "$(YELLOW)[INFO]$(NC) Using BuildKit for optimized builds..."
	@export DOCKER_BUILDKIT=1 && \
	 export BUILDKIT_PROGRESS=plain && \
	 docker-compose build --parallel || { \
		echo "$(RED)[ERROR]$(NC) Build failed. Check logs above."; \
		exit 1; \
	}
	@echo "$(GREEN)[BUILD SUCCESS]$(NC) Starting services..."
	@$(MAKE) start
	@echo "$(GREEN)[SUCCESS]$(NC) Environment ready!"
	@echo "$(YELLOW)[NOTE]$(NC) SSH access: ssh dev@localhost -p 2222 (password: dev)"
	@echo "$(YELLOW)[TIP]$(NC) Run 'make ssh-setup' for passwordless SSH access"

start:
	@echo "$(BLUE)[START]$(NC) Starting containers..."
	@docker-compose up -d

stop:
	@echo "$(BLUE)[STOP]$(NC) Stopping containers..."
	@docker-compose down

restart:
	@echo "$(BLUE)[RESTART]$(NC) Restarting containers..."
	@$(MAKE) stop
	@$(MAKE) start
	@echo "$(GREEN)[SUCCESS]$(NC) Containers restarted!"

clean:
	@echo "$(YELLOW)[CLEAN]$(NC) Cleaning cache and temporary data..."
	@docker-compose down --remove-orphans
	@docker system prune -f
	@docker builder prune -f
	@echo "$(GREEN)[SUCCESS]$(NC) Cache cleanup complete!"

rm:
	@echo "$(RED)[WARNING]$(NC) This will remove ALL data including Git credentials, GPG keys, etc."
	@read -p "Are you sure? [y/N] " -n 1 -r; echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "$(YELLOW)[RM]$(NC) Removing everything..."; \
		docker-compose down -v --remove-orphans; \
		docker system prune -af; \
		docker builder prune -af; \
		docker volume prune -f; \
		echo "$(GREEN)[SUCCESS]$(NC) Everything removed!"; \
	else \
		echo "$(BLUE)[CANCELLED]$(NC) Operation cancelled."; \
	fi

shell:
	@echo "$(BLUE)[SHELL]$(NC) Opening tmux session with zsh in container..."
	@echo "$(YELLOW)[TIP]$(NC) Use 'exit' to return to host terminal"
	@docker exec -it dev-environment tmux new-session

install:
	@echo "$(BLUE)[INSTALL]$(NC) Setting up auto-shell..."
	@SHELL_CONFIG=""; \
	if [ -f ~/.zshrc ]; then SHELL_CONFIG=~/.zshrc; \
	elif [ -f ~/.bash_profile ]; then SHELL_CONFIG=~/.bash_profile; \
	elif [ -f ~/.bashrc ]; then SHELL_CONFIG=~/.bashrc; \
	else echo "$(RED)[ERROR]$(NC) No shell config file found" && exit 1; fi; \
	\
	if grep -q "DOTFILES_AUTO_SHELL_DONE" "$$SHELL_CONFIG"; then \
		echo "$(YELLOW)[SKIP]$(NC) Already installed in $$SHELL_CONFIG"; \
	else \
		echo "" >> "$$SHELL_CONFIG"; \
		echo "# Auto-enter dotfiles development container" >> "$$SHELL_CONFIG"; \
		echo "if [[ -z \"\$$DOTFILES_AUTO_SHELL_DONE\" ]]; then" >> "$$SHELL_CONFIG"; \
		echo "  export DOTFILES_AUTO_SHELL_DONE=1" >> "$$SHELL_CONFIG"; \
		echo "  if docker ps | grep -q dev-environment; then" >> "$$SHELL_CONFIG"; \
		echo "    echo \"🐳 Auto-entering development container...\"" >> "$$SHELL_CONFIG"; \
		echo "    cd $(shell pwd) && make shell" >> "$$SHELL_CONFIG"; \
		echo "  fi" >> "$$SHELL_CONFIG"; \
		echo "fi" >> "$$SHELL_CONFIG"; \
		echo "$(GREEN)[INSTALLED]$(NC) Added to $$SHELL_CONFIG"; \
	fi
	@echo "$(YELLOW)[NOTE]$(NC) Open a new terminal to auto-enter the container"

uninstall:
	@echo "$(BLUE)[UNINSTALL]$(NC) Removing auto-shell..."
	@SHELL_CONFIG=""; \
	if [ -f ~/.zshrc ]; then SHELL_CONFIG=~/.zshrc; \
	elif [ -f ~/.bash_profile ]; then SHELL_CONFIG=~/.bash_profile; \
	elif [ -f ~/.bashrc ]; then SHELL_CONFIG=~/.bashrc; \
	else echo "$(RED)[ERROR]$(NC) No shell config file found" && exit 1; fi; \
	\
	if grep -q "DOTFILES_AUTO_SHELL_DONE" "$$SHELL_CONFIG"; then \
		echo "$(YELLOW)[REMOVING]$(NC) Removing from $$SHELL_CONFIG"; \
		sed -i.bak '/# Auto-enter dotfiles development container/,/^fi$$/d' "$$SHELL_CONFIG"; \
		echo "$(GREEN)[REMOVED]$(NC) Auto-shell removed from $$SHELL_CONFIG"; \
	else \
		echo "$(YELLOW)[SKIP]$(NC) Auto-shell not found in $$SHELL_CONFIG"; \
	fi
	@echo "$(YELLOW)[NOTE]$(NC) Open a new terminal for normal behavior"

ssh:
	@echo "$(BLUE)[SSH]$(NC) Connecting via SSH..."
	@ssh dev-environment || true

ssh-setup:
	@echo "$(BLUE)[SSH-SETUP]$(NC) Setting up SSH key authentication..."
	@echo "🧹 Cleaning old host keys..."
	@ssh-keygen -R "[localhost]:2222" 2>/dev/null || true
	@if [ ! -f ~/.ssh/dev-environment ]; then \
		echo "🔑 Generating SSH key pair..."; \
		ssh-keygen -t ed25519 -f ~/.ssh/dev-environment -N '' -C "dev-environment-key"; \
	else \
		echo "✅ SSH key already exists"; \
	fi
	@echo "⚙️  Updating SSH config..."
	@if grep -q "^Host dev-environment" ~/.ssh/config 2>/dev/null; then \
		sed -i '' '/^Host dev-environment$$/,/^$$/d' ~/.ssh/config; \
	fi
	@echo "" >> ~/.ssh/config
	@echo "Host dev-environment" >> ~/.ssh/config
	@echo "    HostName localhost" >> ~/.ssh/config
	@echo "    Port 2222" >> ~/.ssh/config
	@echo "    User dev" >> ~/.ssh/config
	@echo "    IdentityFile ~/.ssh/dev-environment" >> ~/.ssh/config
	@echo "    StrictHostKeyChecking accept-new" >> ~/.ssh/config
	@echo "� Checking SSH key installation..."
	@if docker exec dev-environment test -f /home/dev/.ssh/authorized_keys; then \
		echo "✅ SSH key already installed in container"; \
	else \
		echo "📦 Installing SSH key to running container..."; \
		docker exec dev-environment mkdir -p /home/dev/.ssh; \
		cat ~/.ssh/dev-environment.pub | docker exec -i dev-environment sh -c 'cat > /home/dev/.ssh/authorized_keys && chmod 700 /home/dev/.ssh && chmod 600 /home/dev/.ssh/authorized_keys'; \
		echo "✅ SSH key installed"; \
	fi
	@echo "🧪 Testing SSH key authentication..."
	@sleep 2 && ssh dev-environment 'echo "✅ SSH key authentication successful!"' || echo "❌ SSH setup failed - try 'make restart' and test again"
	@echo "$(GREEN)[SUCCESS]$(NC) SSH key authentication configured!"

logs:
	@docker-compose logs -f

status:
	@echo "$(BLUE)[STATUS]$(NC) Container status:"
	@docker-compose ps
	@echo ""
	@echo "$(BLUE)[VOLUMES]$(NC) Persistent volumes:"
	@docker volume ls | grep dotfiles || echo "No dotfiles volumes found"

rebuild:
	@echo "$(BLUE)[REBUILD]$(NC) Rebuilding environment with fresh dependencies..."
	@export DOCKER_BUILDKIT=1 && \
	 export BUILDKIT_PROGRESS=plain && \
	 docker-compose build --pull --no-cache || { \
		echo "$(RED)[ERROR]$(NC) Rebuild failed. Check logs above."; \
		exit 1; \
	}
	@$(MAKE) start
	@echo "$(GREEN)[SUCCESS]$(NC) Environment rebuilt with latest base packages!"

build-info:
	@echo "$(BLUE)[BUILD INFO]$(NC) Docker build cache information:"
	@echo ""
	@echo "$(YELLOW)[CACHE USAGE]$(NC)"
	@docker system df
	@echo ""
	@echo "$(YELLOW)[BUILD CACHE]$(NC)"
	@docker buildx du 2>/dev/null || echo "BuildKit cache info not available"
	@echo ""
	@echo "$(YELLOW)[IMAGE INFO]$(NC)"
	@docker images | grep -E "(dotfiles|dev-environment|manjarolinux)" || echo "No related images found"

scan:
	@echo "$(BLUE)[SCAN]$(NC) Scanning image with Trivy..."
	@docker run --rm \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $$HOME/.cache/trivy:/root/.cache \
		aquasec/trivy:latest image dotfiles-dev-env

update:
	@echo "$(BLUE)[UPDATE]$(NC) Ensuring development container is running..."
	@docker-compose up -d dev-env >/dev/null
	@echo "$(BLUE)[UPDATE]$(NC) Updating system packages via pacman..."
	@docker exec -u root dev-environment bash -lc "pacman -Syyu --noconfirm"
	@echo "$(BLUE)[UPDATE]$(NC) Updating AUR packages via yay..."
	@docker exec dev-environment bash -lc "YAY_SUDO=/usr/local/bin/sudo-wrapper yay -Sua --noconfirm --needed --answerdiff None --answerclean None"
	@echo "$(BLUE)[UPDATE]$(NC) Cleaning package cache..."
	@docker exec -u root dev-environment bash -lc "pacman -Scc --noconfirm || true"
	@echo "$(GREEN)[SUCCESS]$(NC) Container packages updated. Restart with 'make restart' if needed."

backup:
	@echo "$(BLUE)[BACKUP]$(NC) Backing up environment..."
	@mkdir -p backups
	@docker run --rm --volumes-from dev-environment -v $$(pwd)/backups:/backup alpine tar czf /backup/backup-$$(date +%Y%m%d-%H%M%S).tar.gz /home/dev /workspace || echo "$(RED)[ERROR]$(NC) Backup failed. Is the container running?"
	@echo "$(GREEN)[SUCCESS]$(NC) Backup created in ./backups/"

restore:
	@echo "$(RED)[WARNING]$(NC) Restore functionality is a placeholder. Manually extract the tarball to restore."
