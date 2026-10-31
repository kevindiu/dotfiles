#!/bin/bash

set -euo pipefail

if [ "$#" -eq 0 ]; then
  exit 0
fi

DOCKER_FLAGS="-i"
if [ -t 0 ] && [ -t 1 ]; then
  DOCKER_FLAGS="-it"
fi

# Run requested command inside dev container as root via Docker CLI.
docker exec $DOCKER_FLAGS -u root "${COMPOSE_PROJECT_NAME:-dotfiles}-dev-environment" "$@"
