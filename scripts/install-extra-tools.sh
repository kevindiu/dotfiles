#!/bin/bash

set -euo pipefail

aur_tools=(
    "gradle"
    "github-copilot-cli"
    "aws-cli-bin"
    "tfenv"
    "k9s"
    "go-bin"
)

pacman_tools=(
    "jdk-openjdk"
    "kubectl"
    "helm"
    "kubectx"
    "stern"
)

echo "📦 Installing AUR tools..."

for tool in "${aur_tools[@]}"; do
    echo "🔄 Installing $tool..."
    yay -S --noconfirm --needed "$tool"
    echo "✅ Successfully installed $tool"
done

echo "✅ Extra AUR tools installation completed!"

echo "🔄 Installing ${#pacman_tools[@]} pacman tools..."
sudo pacman -S --noconfirm --needed "${pacman_tools[@]}"

echo "🧹 Cleaning package cache..."
sudo pacman -Scc --noconfirm || true

echo "✅ Extra Pacman tools installation completed!"
