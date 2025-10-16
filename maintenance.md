# Maintenance Procedures

This document provides step-by-step maintenance procedures for AI agents responsible for keeping the dotfiles development environment updated, secure, and optimized.

## 🔄 Regular Maintenance Schedule

### Weekly Tasks
- [ ] Update package lists and security patches
- [ ] Check container health and resource usage
- [ ] Review logs for errors or warnings
- [ ] Validate SSH access and key functionality

### Monthly Tasks
- [ ] Update base image to latest version
- [ ] Review and update development tools
- [ ] Audit volume usage and cleanup
- [ ] Security configuration review

### Quarterly Tasks
- [ ] Major tool version upgrades
- [ ] Performance optimization review
- [ ] Documentation updates
- [ ] Backup and disaster recovery testing

## 📦 Package Management

### System Packages (Pacman)

**Update Procedure:**
```bash
# Enter container
make shell

# Update package database
sudo pacman -Sy

# List available updates
sudo pacman -Qu

# Update all packages
sudo pacman -Su --noconfirm

# Clean package cache
sudo pacman -Scc --noconfirm
```

**Adding New Packages:**
1. Edit `scripts/install-pacman-tools.sh`
2. Add package name to `tools` array (current tools: ripgrep, fd, bat, exa, fzf, jq, yq, lazygit, docker, docker-compose, github-cli, gnupg, go, nodejs, npm, kubectl, helm)
3. Test installation in development environment
4. Rebuild container: `make clean && make build`

### AUR Packages (Yay)

**Update Procedure:**
```bash
# Update AUR packages
yay -Su --noconfirm

# Clean AUR cache
yay -Sc --noconfirm
```

**Adding New AUR Packages:**
1. Edit `scripts/install-aur-tools.sh`
2. Add package name to `aur_tools` array (current tools: tfenv, aws-cli-bin, k9s, oh-my-zsh-git)
3. Test installation
4. Rebuild container

### Go Tools

**Update Procedure:**
```bash
# Update specific Go tool
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest

# Clean module cache
go clean -modcache
```

**Adding New Go Tools:**
1. Edit `scripts/install-go-tools.sh`
2. Add tool to `go_tools` array (current tools: golang.org/x/tools/gopls@latest, github.com/go-delve/delve/cmd/dlv@latest)
3. Test installation
4. Rebuild container

## 🐳 Container Maintenance

### Image Updates

**Base Image Update:**
```bash
# Check current base image
docker image inspect manjarolinux/base:latest

# Pull latest base image
docker pull manjarolinux/base:latest

# Rebuild with new base
make clean && make build
```

**Multi-stage Build Optimization:**
```bash
# Build with BuildKit for better caching
export DOCKER_BUILDKIT=1
make build

# Check layer sizes
docker history dev-environment:latest

# Clean build cache if needed
docker builder prune -f
```

### Volume Management

**Volume Health Check:**
```bash
# List all volumes
docker volume ls | grep dotfiles

# Inspect volume details
docker volume inspect dotfiles_go-cache
docker volume inspect dotfiles_security-tools

# Check volume usage
docker system df -v
```

**Volume Cleanup:**
```bash
# Remove unused volumes (DANGEROUS - backup first!)
docker volume prune -f

# Backup specific volume
docker run --rm -v dotfiles_security-tools:/data -v $(pwd):/backup \
  alpine tar czf /backup/security-tools-backup.tar.gz -C /data .

# Restore volume
docker run --rm -v dotfiles_security-tools:/data -v $(pwd):/backup \
  alpine tar xzf /backup/security-tools-backup.tar.gz -C /data
```

**Volume Migration:**
```bash
# Create new volume
docker volume create dotfiles_new-volume

# Copy data between volumes
docker run --rm -v dotfiles_old-volume:/src -v dotfiles_new-volume:/dst \
  alpine cp -a /src/. /dst/
```

## 🔧 Configuration Updates

### Shell Configuration (.zshrc)

**Update Process:**
1. Edit `configs/.zshrc`
2. Test changes in running container:
   ```bash
   make shell
   source ~/.zshrc
   ```
3. Verify functionality
4. Restart container to apply: `make restart`

**Common Updates:**
- Environment variable changes
- Alias additions/modifications
- Plugin updates
- Performance optimizations

### Vim Configuration (.vimrc)

**Plugin Management:**
```bash
# Enter container
make shell

# Update vim-plug
:PlugUpdate

# Install new plugins (after editing .vimrc)
:PlugInstall

# Clean unused plugins
:PlugClean
```

### Tmux Configuration (.tmux.conf)

**Apply Changes:**
```bash
# In tmux session
tmux source-file ~/.tmux.conf

# Or reload from makefile
make restart
```

## 🔐 Security Maintenance

### SSH Key Management

**Rotate SSH Host Keys:**
```bash
# Remove old keys
make shell
sudo rm /home/dev/.security/ssh-host-keys/*

# Restart container to regenerate
make restart

# Update SSH config on host
make ssh-setup
```

**Update Authorized Keys:**
```bash
# Add new public key
cat new-key.pub >> ~/.ssh/authorized_keys

# Remove old keys
vim ~/.ssh/authorized_keys

# Set correct permissions
chmod 600 ~/.ssh/authorized_keys
```

### User Permission Audit

**Check Current Permissions:**
```bash
# Volume permissions
docker exec dev-environment find /home/dev -type d -ls
docker exec dev-environment find /home/dev -type f -perm /022 -ls

# Sudo configuration
docker exec dev-environment sudo -l -U dev
```

**Fix Permission Issues:**
```bash
# Reset volume permissions
make shell
sudo /tmp/init-volumes.sh

# Or rebuild completely
make rm && make build
```

## 📊 Performance Monitoring

### Container Performance

**Resource Usage:**
```bash
# Real-time stats
docker stats dev-environment

# Historical usage
docker exec dev-environment top -n 1

# Disk usage in container
docker exec dev-environment df -h
```

**Build Performance:**
```bash
# Build with timing
time make build

# Analyze build cache usage
docker system df

# Check BuildKit cache
docker buildx du
```

### Volume Performance

**I/O Monitoring:**
```bash
# Volume I/O stats (on host)
iostat -x 1

# Container-specific I/O
docker exec dev-environment iotop -n 1
```

## 🚨 Troubleshooting Procedures

### Container Won't Start

**Diagnostic Steps:**
```bash
# Check container logs
docker-compose logs dev-env

# Check volume initialization
docker-compose logs volume-init

# Verify volumes exist
docker volume ls | grep dotfiles

# Check port conflicts
netstat -tulpn | grep :2222
```

**Common Fixes:**
```bash
# Clean restart
make clean && make build

# Force rebuild without cache
docker-compose build --no-cache

# Reset volumes (DANGEROUS)
make rm && make build
```

### SSH Connection Issues

**Diagnostic Steps:**
```bash
# Test SSH connectivity
ssh -v dev-environment

# Check SSH daemon status
docker exec dev-environment pgrep sshd

# Verify SSH config
docker exec dev-environment cat /etc/ssh/sshd_config
```

**Common Fixes:**
```bash
# Regenerate SSH setup
make ssh-setup

# Restart SSH daemon
docker exec dev-environment sudo systemctl restart sshd

# Reset SSH host keys
make restart
```

### Volume Data Loss

**Recovery Steps:**
1. Stop container: `make stop`
2. Check if volume still exists: `docker volume ls`
3. If volume exists, check contents:
   ```bash
   docker run --rm -v dotfiles_security-tools:/data alpine ls -la /data
   ```
4. Restore from backup if available
5. Reinitialize if necessary: `make rm && make build`

## 📝 Change Management

### Making Configuration Changes

**Standard Process:**
1. Create backup of current configuration
2. Test changes in isolated environment
3. Update relevant scripts/configs
4. Document changes in README.md
5. Test full rebuild process
6. Deploy changes

**Rollback Process:**
1. Identify last known good configuration
2. Restore from Git history: `git checkout <commit> -- <file>`
3. Rebuild container
4. Verify functionality
5. Document rollback in change log

### Version Management

**Tagging Releases:**
```bash
# Tag stable versions
git tag -a v1.0.0 -m "Stable release v1.0.0"
git push origin v1.0.0

# List tags
git tag -l
```

**Branch Strategy:**
- `main` - Stable, tested configurations
- `develop` - Integration branch for new features
- `feature/*` - Individual feature development

## 🧪 Testing Procedures

### Pre-deployment Testing

**Build Test:**
```bash
# Clean build test
make clean && make build

# Verify all services start
make status

# Test SSH connectivity
make ssh-setup && ssh dev-environment 'echo "SSH OK"'
```

**Functionality Test:**
```bash
# Test development tools
make shell
go version
node --version
kubectl version --client
gh --version

# Test persistent data
echo "test" > /workspace/test.txt
exit
make restart
make shell
cat /workspace/test.txt  # Should show "test"
```

### Automated Testing Script

```bash
#!/bin/bash
# test-environment.sh

set -e

echo "🧪 Testing development environment..."

# Build test
make clean && make build

# Service health test
make status | grep "Up"

# SSH test
timeout 30 make ssh-setup
ssh -o ConnectTimeout=10 dev-environment 'echo "SSH connectivity: OK"'

# Tool availability test
make shell << 'EOF'
command -v go || exit 1
command -v node || exit 1
command -v kubectl || exit 1
command -v gh || exit 1
echo "All tools available: OK"
exit
EOF

echo "✅ All tests passed!"
```

---

*This maintenance documentation is updated by AI agents. For architecture details, see `architecture.md`.*