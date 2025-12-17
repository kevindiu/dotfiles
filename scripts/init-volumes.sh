#!/bin/bash

set -euo pipefail

echo "🚀 Initializing Docker volumes..."

DEV_UID="${DEV_USER_ID:-1001}"
DEV_GID="${DEV_GROUP_ID:-1001}"

# Define volumes with their permissions and ownership
# Format: "path"="chmod:chown_uid:chown_gid"
# Note: chown only runs if we are root (uid 0)
declare -A volume_config=(
    ["/mnt/go-cache"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/go-cache/pkg"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/go-cache/pkg/mod"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/go-cache/pkg/sumdb"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/go-cache/pkg/tool"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/go-cache/build-cache"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/go-cache/bin"]="755:$DEV_UID:$DEV_GID"

    ["/mnt/shell-history"]="755:$DEV_UID:$DEV_GID"
    
    ["/mnt/git-tools"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/git-tools/gh"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/git-tools/git-credentials"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/git-tools/git-config"]="755:$DEV_UID:$DEV_GID"

    # Security tools need stricter permissions (700 for dir)
    ["/mnt/security-tools"]="700:$DEV_UID:$DEV_GID"
    ["/mnt/security-tools/ssh"]="700:$DEV_UID:$DEV_GID"
    ["/mnt/security-tools/gnupg"]="700:$DEV_UID:$DEV_GID"
    ["/mnt/security-tools/ssh-host-keys"]="700:$DEV_UID:$DEV_GID"

    ["/mnt/aws-config"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/docker-config"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/npm-cache"]="755:$DEV_UID:$DEV_GID"
    
    ["/mnt/vscode-config"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/vscode-config/extensions"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/vscode-config/bin"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/vscode-config/data"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/vscode-config/data/User"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/vscode-config/data/Machine"]="755:$DEV_UID:$DEV_GID"

    ["/mnt/nvim-cache"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/nvim-cache/lazy"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/nvim-cache/undo"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/nvim-cache/backup"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/nvim-cache/swap"]="755:$DEV_UID:$DEV_GID"

    ["/mnt/antigravity-cache"]="755:$DEV_UID:$DEV_GID"
    ["/mnt/gemini-cache"]="755:$DEV_UID:$DEV_GID"
)

init_volumes() {
    echo "🔧 Processing volumes..."
    
    for path in "${!volume_config[@]}"; do
        config="${volume_config[$path]}"
        perm=$(echo "$config" | cut -d: -f1)
        uid=$(echo "$config" | cut -d: -f2)
        gid=$(echo "$config" | cut -d: -f3)

        # 1. Create directory
        if [ ! -d "$path" ]; then
            # echo "  creating $path"
            mkdir -p "$path"
        fi

        # 2. Set Ownership (only if root)
        if [ "$(id -u)" = "0" ]; then
             # Only chown if it differs to save time/IO? 
             # For robustness, we just do it.
             chown "$uid:$gid" "$path"
        fi

        # 3. Set Permissions (if we own it or are root)
        # If we are not root, we can only chmod if we own the file.
        if [ "$(id -u)" = "0" ] || [ -O "$path" ]; then
            chmod "$perm" "$path" 2>/dev/null || true
        fi
    done
}

init_files() {
    echo "� initializing files..."
    
    # Git credentials file needs to be 600
    if [ ! -f /mnt/git-tools/git-credentials/credentials ]; then
        touch /mnt/git-tools/git-credentials/credentials
    fi
    # If we can set perms
    chmod 600 /mnt/git-tools/git-credentials/credentials 2>/dev/null || true
    if [ "$(id -u)" = "0" ]; then
        chown "$DEV_UID:$DEV_GID" /mnt/git-tools/git-credentials/credentials
    fi

    # Shell history files need to be 644
    for file in bash_history zsh_history tmux_history; do
        path="/mnt/shell-history/$file"
        if [ ! -f "$path" ]; then
            touch "$path"
        fi
        chmod 644 "$path" 2>/dev/null || true
        if [ "$(id -u)" = "0" ]; then
            chown "$DEV_UID:$DEV_GID" "$path"
        fi
    done
}

init_volumes
init_files

echo "🎉 Volume initialization completed successfully!"
