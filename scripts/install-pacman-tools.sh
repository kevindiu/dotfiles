#!/bin/bash

set -euo pipefail

echo "📦 Installing pacman tools..."

tools=(
    "ripgrep"
    "fd"
    "bat"
    "ca-certificates"
    "exa"
    "fzf"
    "jq"
    "yq"
    "lazygit"
    "docker"
    "docker-compose"
    "github-cli"
    "openssh"
    "gnupg"
    "kubectl"
    "nodejs"
    "npm"
    "helm"
    "kubectx"
    "stern"
    "yamllint"
    "tmux"
    "zsh"
    "wget"
)

echo "🔄 Installing ${#tools[@]} pacman tools..."
sudo pacman -S --noconfirm --needed "${tools[@]}"

echo "🧹 Cleaning package cache..."
sudo pacman -Scc --noconfirm || true

echo "✅ Pacman tools installation completed!"
