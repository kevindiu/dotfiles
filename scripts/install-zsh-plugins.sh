#!/bin/bash

set -euo pipefail

echo "🐚 Installing zsh plugins..."

ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

mkdir -p "$ZSH_CUSTOM/plugins"

git config --global advice.detachedHead false

install_plugin() {
    local name="$1"
    local url="$2"
    local target="$ZSH_CUSTOM/plugins/$name"
    
    if [ ! -d "$target" ]; then
        echo "🔄 Installing $name..."
        if timeout 60 git clone --depth 1 --single-branch "$url" "$target"; then
            echo "✅ $name installed successfully"
        else
            echo "❌ Failed to install $name"
            return 1
        fi
    else
        echo "✅ $name already installed"
    fi
}

declare -A plugins=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab"
)

pids=()
for name in "${!plugins[@]}"; do
    install_plugin "$name" "${plugins[$name]}" &
    pids+=($!)
done

failed=0
for pid in "${pids[@]}"; do
    if ! wait "$pid"; then
        ((failed+=1))
    fi
done

if [ $failed -eq 0 ]; then
    echo "🎉 All zsh plugins installed successfully!"
else
    echo "⚠️  $failed zsh plugins failed to install"
    exit 1
fi