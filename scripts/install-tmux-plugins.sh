#!/bin/bash

set -euo pipefail

echo "🧩 Installing Tmux Plugin Manager (TPM)..."

TPM_DIR="/home/dev/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
    echo "⬇️  Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "✅ TPM installed"
else
    echo "✅ TPM already installed"
fi

chown -R dev:dev /home/dev/.tmux
