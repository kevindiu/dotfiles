#!/bin/bash

set -euo pipefail

echo "📁 Setting up directories and configurations..."

ensure_symlink() {
    local target="$1"
    local link_name="$2"
    
    # If link already exists and points to target, nothing to do
    if [ -L "$link_name" ] && [ "$(readlink "$link_name")" = "$target" ]; then
        return
    fi
    
    # If it's a directory but not a link, and we need to preserve content
    if [ -d "$link_name" ] && [ ! -L "$link_name" ]; then
        if [ "$(find "$link_name" -mindepth 1 -print -quit 2>/dev/null)" ]; then
            echo "ℹ️  Migrating existing content from $link_name to $target"
            # Ensure target exists before copying into it
            mkdir -p "$target"
            cp -a "$link_name/." "$target/" 2>/dev/null || true
        fi
        rm -rf "$link_name"
    elif [ -e "$link_name" ] || [ -L "$link_name" ]; then
        # Remove file or incorrect symlink
        rm -f "$link_name"
    fi
    
    # Ensure directory of link exists
    mkdir -p "$(dirname "$link_name")"
    
    ln -sfn "$target" "$link_name"
    echo "✅ Linked $link_name -> $target"
}

setup_directories() {
    local go_cache_root="$HOME/.go-cache"
    local vscode_root="$HOME/.vscode"
    local vscode_data_root="$vscode_root/data"

    mkdir -p ~/.config/nvim \
        "$go_cache_root/pkg/mod" "$go_cache_root/pkg/sumdb" "$go_cache_root/pkg/tool" \
        "$go_cache_root/build-cache" ~/.cache \
        "$vscode_root/extensions" "$vscode_root/bin" \
        "$vscode_data_root/User" "$vscode_data_root/Machine" \
        "$HOME/.go-tmp"

    ensure_symlink "/workspace" "$HOME/go/src/github.com"
    ensure_symlink "$go_cache_root/pkg" "$HOME/go/pkg"
    ensure_symlink "$go_cache_root/build-cache" "$HOME/.cache/go-build"

    # Setup Go bin symlink for persistent binaries
    local go_bin_default="$HOME/go/bin"
    local go_bin_persistent="$go_cache_root/bin"
    
    mkdir -p "$go_bin_persistent"
    
    # Special handling for bin directory migration which has slightly different logic (moving out)
    if [ -d "$go_bin_default" ] && [ ! -L "$go_bin_default" ]; then
        echo "📦 Moving existing Go binaries to persistent storage..."
        cp -r "$go_bin_default"/* "$go_bin_persistent"/ 2>/dev/null || true
        rm -rf "$go_bin_default"
    fi
    
    ensure_symlink "$go_bin_persistent" "$go_bin_default"

    # VS Code Configs
    ensure_symlink "$vscode_data_root" "$HOME/.config/Code"
    ensure_symlink "$vscode_root" "$HOME/.vscode-server"
    ensure_symlink "$vscode_root" "$HOME/.vscode-server-insiders"
    ensure_symlink "$vscode_root" "$HOME/.vscode-remote"
}

setup_symlinks() {
    echo "🔗 Setting up symlinks..."
    
    local dev_home="/home/dev"
    local security_home="$dev_home/.security"
    local tools_home="$dev_home/.git_tools"
    
    ensure_symlink "$tools_home/git-credentials/credentials" "$dev_home/.git-credentials"
    ensure_symlink "$tools_home/git-config/.gitconfig" "$dev_home/.gitconfig"
    ensure_symlink "$dev_home/.shell_history/bash_history" "$dev_home/.bash_history"
    ensure_symlink "$security_home/ssh" "$dev_home/.ssh"
    ensure_symlink "$security_home/gnupg" "$dev_home/.gnupg"
    ensure_symlink "$tools_home/gh" "$dev_home/.config/gh"

    echo "✅ Symlinks setup completed"
}

setup_directories
setup_symlinks

echo '✅ Directory setup completed!'
