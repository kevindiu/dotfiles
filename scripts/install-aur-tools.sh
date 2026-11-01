#!/bin/bash

set -euo pipefail

echo "📦 Installing AUR tools..."

# Core AUR tools for development environment
aur_tools=(
    "oh-my-zsh-git"
)

for tool in "${aur_tools[@]}"; do
    echo "🔄 Installing $tool..."
    yay -S --noconfirm --needed "$tool"
    echo "✅ Successfully installed $tool"
done

echo "✅ AUR tools installation completed!"
