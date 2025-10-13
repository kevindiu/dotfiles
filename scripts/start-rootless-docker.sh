#!/bin/bash

set -euo pipefail

uid="$(id -u)"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$uid}"

if [ ! -d "$XDG_RUNTIME_DIR" ]; then
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
fi

export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
export DOCKERD_ROOTLESS_ROOTLESSKIT_PORT_DRIVER="${DOCKERD_ROOTLESS_ROOTLESSKIT_PORT_DRIVER:-slirp4netns}"
export DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS="${DOCKERD_ROOTLESS_ROOTLESSKIT_FLAGS:---copy-up=/etc --copy-up=/run}"

data_root="${DOCKER_ROOTLESS_DATA_ROOT:-$HOME/.local/share/docker-rootless}"
exec_root="${DOCKER_ROOTLESS_EXEC_ROOT:-$XDG_RUNTIME_DIR/docker}"
log_dir="$data_root/log"

mkdir -p "$data_root" "$exec_root" "$log_dir"

if pgrep -u "$uid" -f "dockerd-rootless.sh" >/dev/null 2>&1; then
    echo "Rootless Docker daemon already running."
    exit 0
fi

echo "Starting rootless Docker daemon (rootless mode)..."

setsid dockerd-rootless.sh \
    --data-root "$data_root" \
    --exec-root "$exec_root" \
    --storage-driver fuse-overlayfs \
    --experimental \
    >> "$log_dir/dockerd.log" 2>&1 &

for _ in $(seq 1 20); do
    if [ -S "$XDG_RUNTIME_DIR/docker.sock" ]; then
        echo "Rootless Docker daemon is ready."
        exit 0
    fi
    sleep 1
done

echo "Rootless Docker daemon did not become ready in time." >&2
exit 1
