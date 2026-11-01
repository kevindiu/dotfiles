#!/bin/bash

set -euo pipefail

echo "🧩 Installing Tmux Plugin Manager (TPM)..."

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
    echo "⬇️  Cloning TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    echo "✅ TPM installed"
else
    echo "✅ TPM already installed"
fi

if [ -x "${TPM_DIR}/bin/install_plugins" ]; then
    echo "🔄 Pre-installing tmux plugins..."
    "${TPM_DIR}/bin/install_plugins" || true
fi

chown -R "$(id -un):$(id -gn)" "$HOME/.tmux"
