#!/bin/bash

set -euo pipefail

echo "📦 Installing pacman tools..."

# Core tools from official repositories (stable, fast updates)
# We prefer official packages over AUR where possible for build speed and reliability.
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
    "starship"
    "zoxide"
)

echo "🔄 Installing ${#tools[@]} pacman tools..."
sudo pacman -S --noconfirm --needed "${tools[@]}"

echo "🧹 Cleaning package cache..."
sudo pacman -Scc --noconfirm || true

echo "✅ Pacman tools installation completed!"
