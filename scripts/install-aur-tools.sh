#!/bin/bash

set -euo pipefail

echo "📦 Installing AUR tools..."

yay -Syyu --noconfirm --needed

# Tools requiring AUR (Arch User Repository)
# - neovim-nightly: We need 0.10+ features not in stable yet
# - aws-cli-bin: Official binary is faster/easier than building from source
# - tfenv: manage multiple terraform versions
aur_tools=(
    "neovim-nightly-bin"
    "tfenv"
    "aws-cli-bin"
    "k9s"
    "oh-my-zsh-git"
    "go-bin"
)

for tool in "${aur_tools[@]}"; do
    echo "🔄 Installing $tool..."
    yay -S --noconfirm --needed "$tool"
    echo "✅ Successfully installed $tool"
done

echo "✅ AUR tools installation completed!"