#!/bin/bash

set -euo pipefail

echo "🚀 Starting SSH daemon..."

SSH_KEYS_DIR="/home/dev/.security/ssh-host-keys"

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

if command -v start-rootless-docker.sh >/dev/null 2>&1; then
    echo "🐳 Starting rootless Docker daemon..."
    if ! su - dev -c "/usr/local/bin/start-rootless-docker.sh"; then
        echo "⚠️  Failed to start rootless Docker daemon" >&2
    fi
else
    echo "⚠️  Rootless Docker launcher not found; skipping Docker startup" >&2
fi

echo "🌐 Starting SSH daemon on port 2222..."

exec /usr/sbin/sshd -D
