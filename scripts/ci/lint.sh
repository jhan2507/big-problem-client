#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../../"
npx nx run learning-platform:lint --no-cache
