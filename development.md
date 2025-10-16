# Development Workflows & Best Practices

This document provides development workflows, best practices, and tool configurations for AI agents responsible for enhancing the developer experience in this dotfiles environment.

## 🎯 Development Environment Goals

### Primary Objectives
- **Consistency**: Identical development experience across different machines
- **Performance**: Optimized for fast builds and efficient resource usage
- **Completeness**: All necessary tools pre-installed and configured
- **Persistence**: Work and configurations survive container restarts
- **Integration**: Seamless VS Code Remote-SSH experience

### Developer Personas Supported
- **Go Developers**: Full Go toolchain with debugging support
- **Cloud Engineers**: Kubernetes, AWS, Terraform tooling
- **Full-Stack Developers**: Node.js, Docker, general CLI tools
- **DevOps Engineers**: Container tooling, CI/CD utilities

## 🛠️ Tool Configuration & Workflows

### Go Development

**Environment Setup:**
```bash
# Go paths (from .zshrc)
export PATH=$PATH:/usr/local/go/bin:$GOBIN

# Performance optimizations (from profile.d/99-development.sh)
export GOPROXY=direct
export GOSUMDB=off

# Build cache optimization (from setup-directories.sh)
# ~/.cache/go-build -> ~/.go-cache/build-cache
# ~/go/pkg -> ~/.go-cache/pkg
```

**Development Workflow:**
```bash
# Create new Go project
mkcd /workspace/my-project
go mod init github.com/username/my-project

# Development with live reload (if using air)
go install github.com/cosmtrek/air@latest
air

# Debugging with Delve
dlv debug ./cmd/main.go
```

**Recommended Project Structure:**
```
/workspace/project-name/
├── cmd/                 # Main applications
├── internal/           # Private application code
├── pkg/               # Public library code
├── api/               # API definitions (OpenAPI/gRPC)
├── configs/           # Configuration files
├── scripts/           # Build and deployment scripts
├── deployments/       # Docker/K8s configs
└── docs/             # Documentation
```

### Node.js Development

**Environment Setup:**
```bash
# Node optimizations (from profile.d/99-development.sh)
export NODE_OPTIONS="--max-old-space-size=4096"
export NPM_CONFIG_PROGRESS=false
export NPM_CONFIG_AUDIT=false
export NPM_CONFIG_FUND=false

# Cache configuration (from .env)
export NPM_CONFIG_CACHE=/home/dev/.npm
```

**Package Management:**
```bash
# Use npm (pre-installed)
npm init
npm install <package>

# Or use pnpm for better performance
corepack enable
corepack prepare pnpm@latest --activate
pnpm init
```

### Kubernetes Development

**Tools Available:**
- `kubectl` - Kubernetes CLI
- `helm` - Package manager for Kubernetes  
- `k9s` - Terminal UI for Kubernetes

**Workflow:**
```bash
# Connect to cluster
kubectl config set-context <context-name>

# Development with k9s
k9s

# Helm development
helm create my-chart
helm template my-chart ./my-chart
helm install my-release ./my-chart
```

### Docker Development

**Docker-in-Docker Setup:**
- Docker socket mounted from host
- Docker CLI pre-installed
- Docker Compose available

**Workflow:**
```bash
# Build images
docker build -t my-app .

# Multi-stage builds
docker build --target development -t my-app:dev .

# Compose development
docker-compose up -d
docker-compose logs -f
```

### AWS Development

**Tools Available:**
- AWS CLI with SSO support
- AWS credentials persistent storage

**Setup Workflow:**
```bash
# Configure AWS CLI
aws configure sso
aws configure set region us-west-2

# Use with different profiles
aws --profile dev s3 ls
aws --profile prod ec2 describe-instances
```

## 🔧 Editor & IDE Configuration

### Vim Configuration

**Features Enabled:**
- Go development plugins (vim-go, YouCompleteMe)
- File management (NERDTree)
- Git integration (vim-fugitive)
- Syntax highlighting (vim-polyglot)
- Status line (vim-airline)

**Key Mappings:**
```vim
# Leader key mappings
<leader>r  # Run Go program
<leader>b  # Build Go program  
<leader>t  # Test Go program
<C-n>      # Toggle NERDTree
```

**Plugin Management:**
```bash
# Update plugins
:PlugUpdate

# Install new plugins (edit .vimrc first)
:PlugInstall
```

### VS Code Remote-SSH

**Setup Process:**
1. Run `make ssh-setup` (one-time)
2. Open VS Code
3. Install "Remote - SSH" extension
4. Connect to "dev-environment"

**Recommended Extensions:**
- Go (golang.go)
- Docker (ms-azuretools.vscode-docker)
- Kubernetes (ms-kubernetes-tools.vscode-kubernetes-tools)
- GitLens (eamodio.gitlens)
- Remote - SSH (ms-vscode-remote.remote-ssh)

**VS Code Settings Sync:**
Extensions and settings persist in the `vscode-config` volume.

### Tmux Workflow

**Key Bindings:**
```bash
C-a         # Prefix key (instead of C-b)
C-a |       # Split horizontally  
C-a -       # Split vertically
C-a h/j/k/l # Navigate panes (vim-style)
C-a r       # Reload config
```

**Session Management:**
```bash
# Auto-start tmux (configured in .zshrc)
# Creates new session on shell entry

# Manual session management
tmux new-session -s project-name
tmux attach-session -t project-name
tmux list-sessions
```

## 📁 Project Organization

### Workspace Structure

**Recommended Layout:**
```bash
/workspace/
├── personal/           # Personal projects
│   └── github.com/username/
├── work/              # Work-related projects
│   └── company-domain/
├── experiments/       # Temporary/learning projects
├── templates/         # Project templates
└── tools/            # Custom development tools
```

**Project Templates:**

**Go Microservice Template:**
```bash
mkdir -p /workspace/templates/go-microservice
cd /workspace/templates/go-microservice

# Basic structure
mkdir -p {cmd/server,internal/{handler,service,repository},pkg,configs,deployments}
touch {README.md,Dockerfile,docker-compose.yml,.env.example}
go mod init template/go-microservice
```

**Node.js API Template:**
```bash
mkdir -p /workspace/templates/nodejs-api
cd /workspace/templates/nodejs-api

npm init -y
npm install express helmet cors dotenv
npm install -D nodemon jest supertest

# Create basic structure
mkdir -p {src/{controllers,services,middleware,models},tests,config}
```

### Git Configuration

**Global Settings:**
```bash
# Git configuration persists in git-tools volume
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global push.autoSetupRemote true

# GPG signing (if GPG key configured)
git config --global commit.gpgsign true
git config --global user.signingkey <your-key-id>
```

**Workflow Aliases (in .zshrc):**
```bash
alias gs='git status'
alias ga='git add'
alias gc='git commit -S'  # GPG signed commits
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gm='git merge'
```

**GitHub CLI Integration:**
```bash
# Authentication (persists in git-tools volume)
gh auth login

# Common workflows
gh repo create my-project --private
gh pr create --title "Feature: add new functionality"
gh pr list
gh pr view
gh pr merge
```

## ⚡ Performance Optimization

### Build Performance

**Go Build Optimization:**
```bash
# Build cache (configured via symlinks in setup-directories.sh)
# ~/.cache/go-build -> ~/.go-cache/build-cache
# ~/go/pkg -> ~/.go-cache/pkg

# Module cache location
GOMODCACHE=/home/dev/.go-cache/pkg/mod

# ARM64 optimizations (from .zshrc)
export MAKEFLAGS="-j$(nproc) -march=armv8-a+crypto+crc+aes+sha2"
export CFLAGS="-march=armv8-a+crypto+crc+aes+sha2 -mtune=apple-m1 -O3 -pipe"
```

**Docker Build Optimization:**
```dockerfile
# Use BuildKit caching
# --mount=type=cache,target=/go/pkg/mod
# --mount=type=cache,target=/root/.cache/go-build
```

**Node.js Performance:**
```bash
# Use npm cache
export NPM_CONFIG_CACHE=/home/dev/.npm

# Memory optimization
export NODE_OPTIONS="--max-old-space-size=4096"
```

### Development Server Optimization

**Port Forwarding Strategy:**
- `3000` - Primary web application port
- `8080` - Secondary web services  
- `9000` - Additional services/APIs

**Resource Monitoring:**
```bash
# Container resource usage
docker stats dev-environment

# Inside container monitoring
htop
iotop
```

## 🔄 Development Workflows

### Daily Development Routine

**Morning Setup:**
```bash
# Start environment
make shell

# Check system status
gs  # git status
docker ps  # running containers
kubectl get pods  # if using k8s
```

**Development Cycle:**
```bash
# Feature development
gco -b feature/new-feature
# ... make changes ...
ga .
gc -m "feat: add new functionality"
gp

# Create PR
gh pr create --title "Feature: new functionality"
```

**End of Day:**
```bash
# Ensure work is saved (persistent volumes handle this)
# Commit any WIP
gc -m "wip: save progress"

# Environment persists automatically
exit  # or just close terminal
```

### Code Review Workflow

**Using GitHub CLI:**
```bash
# List PRs for review
gh pr list

# Review specific PR
gh pr checkout <pr-number>
gh pr view <pr-number>
gh pr diff <pr-number>

# Approve and merge
gh pr review <pr-number> --approve
gh pr merge <pr-number>
```

### Testing Workflows

**Go Testing:**
```bash
# Run tests
go test ./...

# With coverage
go test -cover ./...

# Benchmarks  
go test -bench=. ./...

# Race detection
go test -race ./...
```

**Integration Testing:**
```bash
# Docker Compose for integration tests
docker-compose -f docker-compose.test.yml up --build --abort-on-container-exit
```

## 🚀 Deployment Workflows

### Container Deployment

**Build for Production:**
```bash
# Multi-stage production build
docker build --target production -t my-app:v1.0.0 .

# Push to registry
docker tag my-app:v1.0.0 registry.example.com/my-app:v1.0.0
docker push registry.example.com/my-app:v1.0.0
```

### Kubernetes Deployment

**Using Helm:**
```bash
# Package chart
helm package ./charts/my-app

# Deploy to staging
helm upgrade --install my-app ./charts/my-app -f values-staging.yaml

# Deploy to production
helm upgrade --install my-app ./charts/my-app -f values-production.yaml
```

### AWS Deployment

**Using Terraform:**
```bash
# Initialize terraform
terraform init

# Plan deployment
terraform plan -var-file=environments/dev.tfvars

# Apply changes
terraform apply -var-file=environments/dev.tfvars
```

## 📊 Monitoring & Debugging

### Application Debugging

**Go Debugging with Delve:**
```bash
# Debug running application
dlv attach <pid>

# Debug test
dlv test ./pkg/mypackage

# Remote debugging (if needed)
dlv debug --headless --listen=:2345 --api-version=2
```

**Container Debugging:**
```bash
# Debug container issues
docker logs dev-environment
docker exec -it dev-environment bash
docker inspect dev-environment
```

### Performance Profiling

**Go Profiling:**
```bash
# CPU profiling
go test -cpuprofile=cpu.prof -bench=.
go tool pprof cpu.prof

# Memory profiling  
go test -memprofile=mem.prof -bench=.
go tool pprof mem.prof

# Web interface
go tool pprof -http=:8080 cpu.prof
```

## 🎨 Customization Guidelines

### Adding New Tools

**System Tools (Pacman):**
1. Edit `scripts/install-pacman-tools.sh`
2. Add to `tools` array
3. Test installation
4. Rebuild container

**Language-Specific Tools:**
1. Edit appropriate install script
2. Follow existing patterns
3. Test thoroughly
4. Document in README.md

### Environment Customization

**Shell Customization:**
1. Edit `configs/.zshrc`
2. Add aliases, functions, exports
3. Test in running container
4. Restart container to apply

**Editor Customization:**
1. Edit `configs/.vimrc`
2. Add plugins, settings, mappings
3. Run `:PlugInstall` to apply

### Workflow Integration

**Custom Scripts:**
```bash
# Add to /workspace/tools/
mkdir -p /workspace/tools
echo '#!/bin/bash\necho "Custom tool"' > /workspace/tools/my-tool
chmod +x /workspace/tools/my-tool

# Add to PATH in .zshrc
export PATH="$PATH:/workspace/tools"
```

---

*This development documentation is maintained by AI agents. For system architecture, see `architecture.md`.*