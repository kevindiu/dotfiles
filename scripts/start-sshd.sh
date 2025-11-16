#!/bin/bash

set -euo pipefail

echo "🚀 Starting SSH daemon..."

SSH_KEYS_DIR="/home/dev/.security/ssh-host-keys"

adjust_docker_permissions() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "⚠️  Cannot adjust Docker permissions without root privileges"
        return
    fi

    if [ ! -S /var/run/docker.sock ]; then
        echo "ℹ️  Docker socket not mounted; skipping permission fix"
        return
    fi

    local socket_gid docker_group_gid
    socket_gid=$(stat -c '%g' /var/run/docker.sock 2>/dev/null || echo "")
    docker_group_gid=$(getent group docker | cut -d: -f3 2>/dev/null || echo "")

    if [ -n "$socket_gid" ] && [ "$socket_gid" != "$docker_group_gid" ]; then
        if getent group docker >/dev/null 2>&1; then
            groupmod -g "$socket_gid" docker
        else
            groupadd -g "$socket_gid" docker
        fi
        echo "✅ Docker group GID aligned with socket ($socket_gid)"
    fi

    if ! id -nG dev 2>/dev/null | tr ' ' '\n' | grep -qx docker; then
        usermod -aG docker dev
        echo "✅ Added dev user to docker group"
    fi

    chgrp docker /var/run/docker.sock 2>/dev/null || true
    chmod g+rw /var/run/docker.sock 2>/dev/null || true
}

# Ensure SSH keys directory exists with secure permissions
mkdir -p "$SSH_KEYS_DIR"
chmod 700 "$SSH_KEYS_DIR"

# Generate SSH host keys if they don't exist
if [ ! -f "$SSH_KEYS_DIR/ssh_host_rsa_key" ]; then
    echo "🔑 Generating SSH host keys in persistent storage..."
    
    if ssh-keygen -f "$SSH_KEYS_DIR/ssh_host_rsa_key" -N '' -t rsa -b 4096 && \
       ssh-keygen -f "$SSH_KEYS_DIR/ssh_host_ecdsa_key" -N '' -t ecdsa -b 521 && \
       ssh-keygen -f "$SSH_KEYS_DIR/ssh_host_ed25519_key" -N '' -t ed25519; then
        echo "✅ SSH host keys generated successfully"
    else
        echo "❌ Failed to generate SSH host keys"
        exit 1
    fi
else
    echo "✅ SSH host keys already exist, reusing from persistent storage..."
fi

adjust_docker_permissions

echo "🌐 Starting SSH daemon on port 2222..."

exec /usr/sbin/sshd -D
