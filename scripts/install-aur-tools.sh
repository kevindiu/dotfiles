#!/bin/bash

set -euo pipefail

echo "📦 Installing AUR tools..."

yay -Syyu --noconfirm --needed

# Core AUR tools for development environment
aur_tools=(
    "neovim-nightly-bin"
    "lua-language-server"
    "oh-my-zsh-git"
    "go-bin"
)

for tool in "${aur_tools[@]}"; do
    echo "🔄 Installing $tool..."
    yay -S --noconfirm --needed "$tool"
    echo "✅ Successfully installed $tool"
done

echo "✅ AUR tools installation completed!"
