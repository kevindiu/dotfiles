#!/bin/bash

set -euo pipefail

echo "📦 Installing pacman tools..."

tools=(
    "ripgrep"
    "fd"
    "bat"
    "exa"
    "fzf"
    "jq"
    "yq"
    "lazygit"
    "docker"
    "docker-compose"
    "github-cli"
    "gnupg"
    "go"
    "nodejs"
    "npm"
    "kubectl"
    "helm"
)

echo "🔄 Installing ${#tools[@]} pacman tools..."
sudo pacman -S --noconfirm --needed "${tools[@]}"

echo "🧹 Cleaning package cache..."
sudo pacman -Scc --noconfirm || true

echo "✅ Pacman tools installation completed!"
