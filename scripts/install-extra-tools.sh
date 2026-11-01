#!/bin/bash

set -euo pipefail

aur_tools=(
    "aws-cli-bin"
    "tfenv"
)

pacman_tools=(
    "jdk-openjdk"
    "kubectl"
    "helm"
    "kubectx"
    "stern"
    "k9s"
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

install_gradle() {
    echo "📦 Checking and installing Gradle..."
    if sudo pacman -S --noconfirm --needed gradle 2>/dev/null; then
        echo "✅ Gradle installed via pacman"
    else
        echo "⬇️  Downloading Gradle standalone binary..."
        local gradle_ver="8.10.2"
        local install_dir="$HOME/.local/share/gradle"
        local bin_dir="$HOME/.local/bin"
        mkdir -p "$install_dir" "$bin_dir"
        curl -fsSL "https://services.gradle.org/distributions/gradle-${gradle_ver}-bin.zip" -o /tmp/gradle.zip
        unzip -qo /tmp/gradle.zip -d "$install_dir"
        ln -sfn "$install_dir/gradle-${gradle_ver}/bin/gradle" "$bin_dir/gradle"
        rm -f /tmp/gradle.zip
        echo "✅ Gradle ${gradle_ver} installed"
    fi
}
install_gradle

echo "✅ Extra Pacman tools installation completed!"
