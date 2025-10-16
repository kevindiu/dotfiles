#!/bin/bash

set -euo pipefail

echo "🐚 Installing zsh plugins..."

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

# Ensure plugins directory exists
mkdir -p "$ZSH_CUSTOM/plugins"

# Configure git for faster cloning
git config --global advice.detachedHead false

# Plugin installation function
install_plugin() {
    local name="$1"
    local url="$2"
    local target="$ZSH_CUSTOM/plugins/$name"
    
    if [ ! -d "$target" ]; then
        echo "🔄 Installing $name..."
        if git clone --depth 1 --single-branch "$url" "$target"; then
            echo "✅ $name installed successfully"
        else
            echo "❌ Failed to install $name"
            return 1
        fi
    else
        echo "✅ $name already installed"
    fi
}

# Track background processes
pids=()

# Install plugins in parallel
install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions" &
pids+=($!)

install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git" &
pids+=($!)

# Wait for all installations to complete
failed=0
for pid in "${pids[@]}"; do
    if ! wait "$pid"; then
        ((failed++))
    fi
done

if [ $failed -eq 0 ]; then
    echo "🎉 All zsh plugins installed successfully!"
else
    echo "⚠️  $failed zsh plugins failed to install"
    exit 1
fi