#!/bin/bash

set -euo pipefail

echo "🐹 Installing Go tools..."

go_tools=(
    "golang.org/x/tools/gopls@latest"
    "github.com/go-delve/delve/cmd/dlv@latest"
)

install_go_tool() {
    local tool="$1"
    echo "🔄 Installing $tool..."
    if go install "$tool"; then
        echo "✅ Successfully installed $tool"
    else
        echo "❌ Failed to install $tool"
        return 1
    fi
}

pids=()

for tool in "${go_tools[@]}"; do
    install_go_tool "$tool" &
    pids+=($!)
done

failed=0
for pid in "${pids[@]}"; do
    if ! wait "$pid"; then
        ((failed+=1))
    fi
done

if [ $failed -eq 0 ]; then
    echo "🎉 All Go tools installed successfully!"
else
    echo "⚠️  $failed Go tools failed to install"
    exit 1
fi