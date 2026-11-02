#!/bin/bash

set -euo pipefail

if [ "$#" -eq 0 ]; then
  exit 0
fi

# Run requested command inside dev container as root via Docker CLI.
# Target container can be overridden via DEV_CONTAINER_NAME or defaults to compose project dev environment.
TARGET_CONTAINER="${DEV_CONTAINER_NAME:-${COMPOSE_PROJECT_NAME:-dotfiles}-dev-environment}"

# Only allow execution if the target container matches the current dev container
docker exec -i -u root "$TARGET_CONTAINER" "$@"
