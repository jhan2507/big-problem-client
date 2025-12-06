#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../../"
docker build -t local/learning-platform:ci -f apps/learning-platform/Dockerfile .
