#!/bin/bash

set -euo pipefail

echo "📁 Setting up directories and configurations..."

setup_directories() {
    local go_cache_root="$HOME/.go-cache"

    local vscode_root="$HOME/.vscode"
    local vscode_server_link="$HOME/.vscode-server"
    local vscode_data_root="$vscode_root/data"
    local host_code_config="$HOME/.config/Code"

    mkdir -p ~/.config/nvim \
        "$go_cache_root/pkg/mod" "$go_cache_root/pkg/sumdb" "$go_cache_root/pkg/tool" \
        "$go_cache_root/build-cache" ~/.cache \
        "$vscode_root/extensions" "$vscode_root/bin" \
        "$vscode_data_root/User" "$vscode_data_root/Machine"

    if [ ! -L ~/go/src/github.com ]; then
        mkdir -p ~/go
        mkdir -p ~/go/src
        ln -sf /workspace ~/go/src/github.com
        echo "✅ Created symlink: ~/go/src/github.com -> /workspace"
    fi

    if [ ! -L ~/go/pkg ]; then
        ln -sfn "$go_cache_root/pkg" ~/go/pkg
        echo "✅ Linked Go pkg cache to ~/.go-cache/pkg"
    fi

    if [ ! -L ~/.cache/go-build ]; then
        ln -sfn "$go_cache_root/build-cache" ~/.cache/go-build
        echo "✅ Linked Go build cache to ~/.go-cache/build-cache"
    fi

    # Setup Go bin symlink for persistent binaries
    local go_bin_default="$HOME/go/bin"
    local go_bin_persistent="$go_cache_root/bin"
    
    mkdir -p "$go_bin_persistent"
    
    # Always ensure proper symlink setup
    if [ -e "$go_bin_default" ] && [ ! -L "$go_bin_default" ]; then
        # Move existing binaries if directory exists
        if [ -d "$go_bin_default" ]; then
            echo "📦 Moving existing Go binaries to persistent storage..."
            cp -r "$go_bin_default"/* "$go_bin_persistent"/ 2>/dev/null || true
        fi
        rm -rf "$go_bin_default"
    fi
    
    # Ensure parent directory exists
    mkdir -p "$(dirname "$go_bin_default")"
    
    # Create or refresh symlink
    if [ ! -L "$go_bin_default" ] || [ "$(readlink "$go_bin_default")" != "$go_bin_persistent" ]; then
        ln -sf "$go_bin_persistent" "$go_bin_default"
        echo "✅ Linked Go bin to ~/.go-cache/bin"
    fi

    if [ ! -L "$host_code_config" ]; then
        if [ -d "$host_code_config" ]; then
            if [ "$(find "$host_code_config" -mindepth 1 -print -quit 2>/dev/null)" ]; then
                echo "ℹ️  Migrating existing VS Code config into ~/.vscode/data"
                cp -a "$host_code_config/." "$vscode_data_root/" 2>/dev/null || true
            fi
            rm -rf "$host_code_config"
        else
            rm -f "$host_code_config"
        fi
        ln -sfn "$vscode_data_root" "$host_code_config"
        echo "✅ Linked VS Code config to ~/.vscode/data"
    fi

    if [ ! -L "$vscode_server_link" ]; then
        if [ -d "$vscode_server_link" ]; then
            if [ "$(find "$vscode_server_link" -mindepth 1 -print -quit 2>/dev/null)" ]; then
                echo "ℹ️  Migrating existing VS Code server files into ~/.vscode"
                cp -a "$vscode_server_link/." "$vscode_root/" 2>/dev/null || true
            fi
            rm -rf "$vscode_server_link"
        else
            rm -f "$vscode_server_link"
        fi
        ln -sfn "$vscode_root" "$vscode_server_link"
        echo "✅ Linked ~/.vscode-server to ~/.vscode"
    fi
}

setup_symlinks() {
    echo "� Setting up symlinks..."
    
    ln -sf /home/dev/.git_tools/git-credentials/credentials /home/dev/.git-credentials
    ln -sf /home/dev/.git_tools/git-config/.gitconfig /home/dev/.gitconfig
    ln -sf /home/dev/.shell_history/bash_history /home/dev/.bash_history
    ln -sf /home/dev/.security/ssh /home/dev/.ssh
    ln -sf /home/dev/.security/gnupg /home/dev/.gnupg
    ln -sf /home/dev/.git_tools/gh /home/dev/.config/gh

    echo "✅ Symlinks setup completed"
}

setup_directories
setup_symlinks

echo '✅ Directory setup completed!'
