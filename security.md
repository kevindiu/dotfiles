# Security Policies & Procedures

This document provides comprehensive security guidelines, policies, and procedures for AI agents responsible for maintaining the security posture of this dotfiles development environment.

## 🔐 Security Principles

### Core Security Tenets
1. **Principle of Least Privilege**: Users and processes have minimum necessary permissions
2. **Defense in Depth**: Multiple layers of security controls
3. **Zero Trust**: Verify explicitly, never assume trust
4. **Secure by Default**: Secure configurations as the baseline
5. **Fail Securely**: System failures should not compromise security

### Threat Model
**Assets to Protect:**
- Source code and intellectual property
- Development credentials and keys
- Container runtime environment
- Host system access
- Network communications

**Threat Actors:**
- External attackers via network
- Malicious containers or images
- Compromised host systems
- Insider threats
- Supply chain attacks

## 🏗️ Container Security Architecture

### Container Isolation

**User Security Model:**
```yaml
# Non-root execution (actual configuration)
user: "1001:1001"  # dev user, not root
init: true         # Proper init system for signal handling

# Note: No explicit security_opt in current config
# Security hardening (enabled)
security_opt:
  - no-new-privileges:true
```

**Resource Limits:**
```yaml
# Temporary filesystems with security restrictions
tmpfs:
  - /tmp:noexec,nosuid,nodev,size=500m     # No execution from /tmp, increased size
  - /run:noexec,nosuid,nodev,size=100m     # No execution from /run

# System resource limits via configs/linux/etc/security/limits.d/99-container.conf:
# - File descriptors: 65536 (soft/hard)
# - Processes: 32768 (soft/hard)
# - Core dumps: disabled (0)
# - Stack size: 8192KB (soft), 32768KB (hard)
```

### Network Security

**Port Exposure Policy:**
```yaml
ports:
  - "2222:2222"  # SSH - restricted to localhost only
  - "8080:8080"  # Development web server
  - "3000:3000"  # Node.js applications  
  - "9000:9000"  # Additional services
```

**Network Isolation:**
```yaml
networks:
  dev-network:
    driver: bridge
    internal: false  # Allow internet access for development
    ipam:
      config:
        - subnet: 172.20.0.0/16  # Private subnet
```

**Firewall Recommendations:**
```bash
# Host firewall rules (iptables/ufw)
# Allow SSH only from localhost
iptables -A INPUT -p tcp --dport 2222 -s 127.0.0.1 -j ACCEPT
iptables -A INPUT -p tcp --dport 2222 -j REJECT

# Allow development ports only from local network
iptables -A INPUT -p tcp --dport 3000:9000 -s 192.168.0.0/16 -j ACCEPT
iptables -A INPUT -p tcp --dport 3000:9000 -s 10.0.0.0/8 -j ACCEPT
iptables -A INPUT -p tcp --dport 3000:9000 -j REJECT
```

## 🔑 Authentication & Authorization

### SSH Security Configuration

**SSH Daemon Configuration (`configs/linux/etc/ssh/sshd_config`):**
```bash
# Actual SSH configuration (security-focused)
Port 2222
Protocol 2

# Host keys from persistent storage
HostKey /home/dev/.security/ssh-host-keys/ssh_host_rsa_key
HostKey /home/dev/.security/ssh-host-keys/ssh_host_ecdsa_key
HostKey /home/dev/.security/ssh-host-keys/ssh_host_ed25519_key

# Security settings
PermitRootLogin no
AuthorizedKeysFile .ssh/authorized_keys
AllowUsers dev
PermitEmptyPasswords no

# Logging
SyslogFacility AUTH
LogLevel INFO
```

**SSH Key Management:**
```bash
# Key Generation (Ed25519 preferred)
ssh-keygen -t ed25519 -f ~/.ssh/dev-environment -C "dev-environment-key"

# Key Rotation Schedule
# - Development keys: Every 90 days
# - Host keys: Every 365 days or on compromise
# - Emergency rotation: Immediately on suspected compromise
```

**Authorized Keys Security:**
```bash
# Proper file permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Key validation
ssh-keygen -l -f ~/.ssh/authorized_keys  # List fingerprints
```

### User Access Control

**Sudo Configuration (Temporary Privilege Escalation):**
```bash
# Build-time: Temporary elevated access for system setup
dev ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/yay, /usr/bin/mkdir, /usr/bin/chmod, /usr/bin/usermod, /usr/bin/groupadd, /usr/bin/groupmod

# Runtime: Minimal access after setup completion  
dev ALL=(ALL) NOPASSWD: /usr/bin/pacman, /usr/bin/yay
```

**Security Benefits:**
- **Temporary elevation**: System setup commands only available during build
- **Permanent minimal access**: Only package management in running container
- **Principle of least privilege**: No persistent system-level sudo access

**File Permissions Audit:**
```bash
# Regular permission checks
find /home/dev -type f -perm /022 -ls  # World-writable files
find /home/dev -type d -perm /022 -ls  # World-writable directories
find /home/dev -type f -perm /4000 -ls  # SUID files
find /home/dev -type f -perm /2000 -ls  # SGID files
```

## 🛡️ Data Protection

### Secrets Management

**Prohibited in Repository:**
- Private keys (SSH, GPG, API keys)
- Passwords or tokens
- Certificates
- Database connection strings
- Cloud credentials

**Git Hooks for Secret Detection:**
```bash
#!/bin/sh
# .git/hooks/pre-commit
# Check for potential secrets

# Common secret patterns
if git diff --cached --name-only | xargs grep -l -E "(password|secret|key|token)" >/dev/null 2>&1; then
    echo "⚠️  Potential secret detected in commit"
    echo "Review files for sensitive information"
    exit 1
fi

# Check for private key headers
if git diff --cached | grep -q "BEGIN.*PRIVATE KEY"; then
    echo "❌ Private key detected in commit"
    exit 1
fi
```

**Environment Variable Security:**
```bash
# Safe environment variables
export ENVIRONMENT=development
export LOG_LEVEL=debug

# Unsafe - never commit these patterns
export API_KEY=secret123          # ❌ Never commit
export DATABASE_PASSWORD=pass123  # ❌ Never commit

# Use secrets management instead
export API_KEY_FILE=/run/secrets/api_key      # ✅ File-based secrets
export DATABASE_URL_FILE=/run/secrets/db_url  # ✅ External secret store
```

### Volume Security

**Volume Encryption (Host Level):**
```bash
# Encrypt Docker volumes directory (recommended for production)
# This is host-level configuration, outside container scope

# Example: LUKS encryption for volume storage
cryptsetup luksFormat /dev/sdb
cryptsetup luksOpen /dev/sdb docker_volumes
mkfs.ext4 /dev/mapper/docker_volumes
mount /dev/mapper/docker_volumes /var/lib/docker
```

**Sensitive Data Volumes:**
```yaml
# Restricted access volumes
volumes:
  security-tools:          # SSH keys, GPG keys
    driver: local
    driver_opts:
      type: none
      o: bind,mode=700     # Strict permissions
  
  git-tools:              # Git credentials
    driver: local
    driver_opts:
      type: none
      o: bind,mode=755
```

**Volume Backup Security:**
```bash
# Encrypted backup procedure
backup_volume() {
    local volume_name=$1
    local backup_path=$2
    
    # Create encrypted backup
    docker run --rm \
        -v "${volume_name}:/data:ro" \
        -v "${backup_path}:/backup" \
        alpine \
        sh -c "tar czf - /data | gpg --cipher-algo AES256 --compress-algo 1 --symmetric --output /backup/${volume_name}-$(date +%Y%m%d).tar.gz.gpg"
}
```

## 🔍 Security Monitoring

### Audit Logging

**Container Activity Monitoring:**
```bash
# Enable Docker daemon logging
# /etc/docker/daemon.json
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "10m",
        "max-file": "3"
    },
    "audit": true
}
```

**SSH Access Monitoring:**
```bash
# Monitor SSH connections
tail -f /var/log/auth.log | grep sshd

# Failed authentication attempts
grep "Failed password" /var/log/auth.log

# Successful connections
grep "Accepted publickey" /var/log/auth.log
```

### Security Scanning

**Container Image Scanning:**
```bash
# Scan base image for vulnerabilities
docker scout cves manjarolinux/base:latest

# Scan built image
docker scout cves dev-environment:latest

# Alternative: Trivy scanning
trivy image manjarolinux/base:latest
trivy image dev-environment:latest
```

**Dependency Scanning:**
```bash
# Go dependency scanning
go list -json -m all | nancy sleuth

# Node.js dependency scanning
npm audit
npm audit --audit-level high

# Container filesystem scanning
trivy fs /path/to/container/filesystem
```

**Configuration Scanning:**
```bash
# Docker Compose security scan
docker-compose config | docker run --rm -i checkconfig/docker-compose-security-checker

# Dockerfile security scan
docker run --rm -i hadolint/hadolint < Dockerfile
```

## ⚠️ Incident Response

### Security Incident Classification

**Severity Levels:**
1. **Critical**: Active compromise, data breach, or system takeover
2. **High**: Vulnerability with high exploit probability
3. **Medium**: Security weakness requiring attention
4. **Low**: Minor security improvement opportunity

### Incident Response Procedures

**Immediate Response (Critical/High):**
```bash
# 1. Isolate the environment
make stop  # Stop containers immediately

# 2. Preserve evidence
docker logs dev-environment > incident-logs-$(date +%Y%m%d-%H%M%S).txt
docker inspect dev-environment > incident-inspect-$(date +%Y%m%d-%H%M%S).txt

# 3. Assessment
# - Determine scope of compromise
# - Identify potential data exposure
# - Review access logs

# 4. Containment
# - Revoke compromised credentials
# - Block suspicious network activity
# - Isolate affected systems

# 5. Recovery
make clean  # Clean compromised containers
make rm     # Remove potentially compromised volumes (if necessary)
# Restore from clean backup
make build  # Rebuild from clean state
```

**Investigation Steps:**
```bash
# Review container logs
docker-compose logs > full-incident-logs.txt

# Check file system changes
docker diff dev-environment

# Network connection analysis
docker exec dev-environment netstat -tupln
docker exec dev-environment ss -tulpn

# Process analysis
docker exec dev-environment ps aux
```

### Post-Incident Actions

**Recovery Verification:**
```bash
# Verify clean state
docker system prune -af  # Remove all unused containers/images
docker volume prune -f   # Remove unused volumes (careful!)

# Rebuild from scratch
make build

# Security validation
make ssh-setup  # Regenerate SSH keys
# Update all credentials
# Review and update security configurations
```

**Lessons Learned:**
1. Document incident timeline
2. Identify root cause
3. Update security measures
4. Review detection capabilities
5. Update incident response procedures

## 🔧 Security Hardening Checklist

### Container Hardening

- [ ] **User Security**
  - [ ] Container runs as non-root user (dev:1001)
  - [ ] No unnecessary sudo privileges
  - [ ] Proper file permissions on sensitive files

- [ ] **Network Security**  
  - [ ] SSH on non-standard port (2222)
  - [ ] Key-based authentication only
  - [ ] Network isolation configured
  - [ ] Unnecessary ports closed

- [ ] **Resource Security**
  - [ ] tmpfs mounted with security flags (noexec, nosuid)
  - [ ] Resource limits configured
  - [ ] No unnecessary capabilities

### Host Security

- [ ] **Docker Security**
  - [ ] Docker daemon secured
  - [ ] Docker socket access restricted
  - [ ] Image scanning enabled
  - [ ] Registry authentication configured

- [ ] **System Security**
  - [ ] Host firewall configured
  - [ ] System updates current
  - [ ] Audit logging enabled
  - [ ] Intrusion detection active

### Operational Security

- [ ] **Access Control**
  - [ ] SSH keys rotated regularly
  - [ ] Access reviewed quarterly
  - [ ] Unused accounts removed
  - [ ] Strong authentication enforced

- [ ] **Monitoring**
  - [ ] Log monitoring active
  - [ ] Security alerts configured
  - [ ] Vulnerability scanning scheduled
  - [ ] Backup verification regular

## 📋 Security Compliance

### Security Standards Alignment

**Container Security Standards:**
- CIS Docker Benchmark compliance
- NIST Container Security Guide adherence  
- Docker Security Best Practices implementation

**Development Security:**
- OWASP Secure Coding Practices
- SANS Secure Development Guidelines
- Industry-specific compliance (if applicable)

### Regular Security Reviews

**Monthly Security Tasks:**
- [ ] Review SSH access logs
- [ ] Update base container images  
- [ ] Scan for vulnerabilities
- [ ] Review user permissions
- [ ] Test backup/recovery procedures

**Quarterly Security Tasks:**
- [ ] Rotate SSH keys
- [ ] Review security configurations
- [ ] Update security documentation
- [ ] Conduct security training
- [ ] Test incident response procedures

**Annual Security Tasks:**
- [ ] Complete security audit
- [ ] Review threat model
- [ ] Update security policies
- [ ] Evaluate security tools
- [ ] Plan security improvements

### Documentation Requirements

**Security Documentation:**
- Security policies and procedures (this document)
- Incident response runbooks
- Security configuration baselines  
- Risk assessment documentation
- Security training materials

---

*This security documentation is maintained by AI agents. Report security issues immediately through appropriate channels.*

**Emergency Contacts:**
- Security Team: [security@organization.com]
- Incident Response: [incident@organization.com]  
- Development Team: [dev@organization.com]

**Last Security Review:** 2025-01-16  
**Next Review Due:** 2025-04-16