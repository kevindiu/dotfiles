#!/bin/bash

set -euo pipefail

echo "🚀 Initializing Docker volumes..."

DEV_UID="${DEV_USER_ID:-1001}"
DEV_GID="${DEV_GROUP_ID:-1001}"

init_volume_structure() {
    echo "📁 Creating directory structures..."
    
    local dirs=(
        "/mnt/shell-history"
        "/mnt/git-tools/"{gh,git-credentials,git-config}
        "/mnt/security-tools/"{ssh,gnupg,ssh-host-keys}
        "/mnt/aws-config"
        "/mnt/docker-config"
        "/mnt/npm-cache"
        "/mnt/vscode-config/"{extensions,bin}
        "/mnt/vscode-config/data/"{User,Machine}
        "/mnt/go-cache/pkg/"{mod,sumdb,tool}
        "/mnt/go-cache/"{build-cache,bin}
        "/mnt/nvim-cache/"{lazy,undo,backup,swap}
        "/mnt/antigravity-cache"
        "/mnt/gemini-cache"
    )

    for dir in "${dirs[@]}"; do
        # Use simple mkdir since brace expansion happens before loop in zsh/bash 
        # but here we rely on the expansion in the array definition if using bash/zsh properly.
        # However, safest in sh is to simple expanding.
        # Let's keep it simple: direct expansion works in the array declaration in bash.
        mkdir -p $dir
    done
    
    echo "✅ Directory structures created"
}

init_volume_files() {
    echo "📄 Creating initial files..."
    
    mkdir -p /mnt/git-tools/git-credentials
    touch /mnt/git-tools/git-credentials/credentials
    
    touch /mnt/shell-history/{bash_history,zsh_history,tmux_history}
    
    echo "✅ Initial files created"
}

set_volume_ownership() {
    echo "👤 Setting volume ownership..."
    
    # Skip chown when running as dev user - files are already owned correctly
    if [ "$(id -u)" = "0" ]; then
        chown -R "$DEV_UID:$DEV_GID" /mnt/{security-tools,go-cache,shell-history,git-tools,aws-config,vscode-config,npm-cache,docker-config,nvim-cache,antigravity-cache,gemini-cache}
        echo "✅ Volume ownership set to dev:dev (${DEV_UID}:${DEV_GID})"
    else
        echo "✅ Running as dev user - ownership already correct"
    fi
}

set_volume_permissions() {
    echo "🔒 Setting volume permissions..."
    
    # Set permissions for directories and files we can modify
    chmod -R 755 /mnt/{go-cache,git-tools,aws-config,vscode-config,npm-cache,docker-config,antigravity-cache,gemini-cache} 2>/dev/null || true
    
    chmod 755 /mnt/shell-history 2>/dev/null || true
    chmod 644 /mnt/shell-history/{bash_history,zsh_history,tmux_history} 2>/dev/null || true
    
    # Only set permissions on security-tools if we own the files
    if [ "$(id -u)" = "0" ]; then
        chmod -R 700 /mnt/security-tools
    else
        # Set permissions only on files we own, ignore errors for others
        find /mnt/security-tools -user $(id -u) -exec chmod 700 {} \; 2>/dev/null || true
    fi
    
    chmod 600 /mnt/git-tools/git-credentials/credentials 2>/dev/null || true
    
    echo "✅ Volume permissions configured"
}

init_volume_structure
init_volume_files
set_volume_ownership
set_volume_permissions

echo "🎉 Volume initialization completed successfully!"
