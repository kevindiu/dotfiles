#!/bin/bash

set -euo pipefail

echo "🚀 Starting SSH daemon..."

SSH_KEYS_DIR="$HOME/.security/ssh-host-keys"

setup_ssh_directories() {
    echo "🔧 Setting up SSH runtime directories..."
    if [ "$(id -u)" -ne 0 ]; then
        echo "ℹ️  Not running as root; skipping SSH runtime directory setup"
        return
    fi
    mkdir -p /var/run/sshd /usr/share/empty.sshd
    chmod 755 /usr/share/empty.sshd
    echo "✅ SSH runtime directories ready"
}

run_dev_home_setup() {
    local setup_script="/usr/local/bin/setup-directories.sh"

    if [ ! -x "$setup_script" ]; then
        echo "ℹ️  setup-directories.sh not found; skipping dev home refresh"
        return
    fi

    echo "🛠️  Refreshing dev home directories..."
    if [ "$(id -u)" -eq 0 ]; then
        su - "${DEV_USER:-dev}" -c "HOME=$HOME $setup_script"
    else
        env HOME="$HOME" "$setup_script"
    fi
    echo "✅ Dev home directories refreshed"
}

adjust_docker_permissions() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "⚠️  Cannot adjust Docker permissions without root privileges"
        return
    fi

    # If the socket isn't mounted, we can't do anything.
    # This happens during build time or if the user forgot the volume mount.
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

    if ! id -nG "${DEV_USER:-dev}" 2>/dev/null | tr ' ' '\n' | grep -qx docker; then
        usermod -aG docker "${DEV_USER:-dev}"
        echo "✅ Added ${DEV_USER:-dev} user to docker group"
    fi

    chgrp docker /var/run/docker.sock 2>/dev/null || true
    chmod g+rw /var/run/docker.sock 2>/dev/null || true
}

setup_ssh_directories

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

# 600 Permission is mandatory. SSHD will refuse to start if keys are world-readable.
# This fixes issues where keys mounted from host might have loose permissions (755).
echo "🔒 Enforcing strict permissions on SSH host keys..."
chmod 600 "$SSH_KEYS_DIR"/ssh_host_*_key
echo "✅ SSH host key permissions verified"

run_dev_home_setup

adjust_docker_permissions

# Prepare runtime SSH configuration adapting to configured DEV_USER
TARGET_USER="${DEV_USER:-dev}"
USER_HOME="/home/${TARGET_USER}"
RUNTIME_SSHD_CONF="/var/run/sshd/sshd_config"
mkdir -p /var/run/sshd
sed -e "s|/home/dev|${USER_HOME}|g" \
    -e "s|AllowUsers dev|AllowUsers ${TARGET_USER}|g" \
    /etc/ssh/sshd_config > "$RUNTIME_SSHD_CONF"

echo "🌐 Starting SSH daemon on port 2222..."
exec /usr/sbin/sshd -D -f "$RUNTIME_SSHD_CONF"
