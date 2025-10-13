#!/bin/bash

set -euo pipefail

echo "📁 Setting up directories and configurations..."

setup_directories() {
    mkdir -p ~/.vim/undodir ~/.config

    if [ ! -L ~/go/src/github.com ]; then
        mkdir -p ~/go/src
        ln -sf /workspace ~/go/src/github.com
        echo "✅ Created symlink: ~/go/src/github.com -> /workspace"
    fi
}

setup_ssh_directories() {
    echo "🔧 Setting up SSH directories..."
    sudo mkdir -p /var/run/sshd /usr/share/empty.sshd
    sudo chmod 755 /usr/share/empty.sshd
    echo "✅ SSH directories setup completed"
}

setup_symlinks() {
    echo "🔗 Setting up symlinks..."

    ln -sf /home/dev/.git_tools/git-credentials/credentials /home/dev/.git-credentials
    ln -sf /home/dev/.git_tools/git-config/.gitconfig /home/dev/.gitconfig
    ln -sf /home/dev/.shell_history/bash_history /home/dev/.bash_history
    ln -sf /home/dev/.security/ssh /home/dev/.ssh
    ln -sf /home/dev/.security/gnupg /home/dev/.gnupg
    ln -sf /home/dev/.git_tools/gh /home/dev/.config/gh

    echo "✅ Symlinks setup completed"
}

setup_directories
setup_symlinks
setup_ssh_directories

echo '✅ Directory setup completed!'
