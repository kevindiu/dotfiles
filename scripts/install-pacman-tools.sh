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
    "curl"
    "wget"
    "starship"
    "zoxide"
    "neovim"
    "lua-language-server"
    "go"
)

echo "🔄 Installing ${#tools[@]} pacman tools..."
sudo pacman -S --noconfirm --needed "${tools[@]}"

echo "✅ Pacman tools installation completed!"
