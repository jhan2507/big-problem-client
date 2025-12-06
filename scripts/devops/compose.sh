#!/usr/bin/env bash
set -euo pipefail
CMD=${1:-""}
ROOT_DIR="$(cd "$(dirname "$0")/../../" && pwd)"

case "$CMD" in
  up)
    export NEXT_PUBLIC_API_BASE_URL="${NEXT_PUBLIC_API_BASE_URL:-http://localhost:8080}"
    docker compose -f "$ROOT_DIR/docker-compose.yml" up -d --build
    ;;
  down)
    docker compose -f "$ROOT_DIR/docker-compose.yml" down
    ;;
  rebuild)
    docker compose -f "$ROOT_DIR/docker-compose.yml" build --no-cache
    ;;
  *)
    echo "Usage: $0 {up|down|rebuild}"
    exit 1
    ;;
esac
