#!/bin/bash

set -euo pipefail

echo "📦 Installing pacman tools..."

tools=(
    "ripgrep"
    "fd"
    "bat"
    "ca-certificates"
    "eza"
    "fzf"
    "jq"
    "unzip"
    "go-yq"
    "lazygit"
    "docker"
    "docker-compose"
    "github-cli"
    "openssh"
    "gnupg"
    "nodejs"
    "npm"
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
