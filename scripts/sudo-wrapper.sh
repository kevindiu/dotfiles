#!/bin/bash

set -euo pipefail

if [ "$#" -eq 0 ]; then
  exit 0
fi

# Run requested command inside dev container as root via Docker CLI.
docker exec -u root dev-environment "$@"
