#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_ID="${1:-}"
APP_VERSION="${2:-}"

if [[ -z "$APP_ID" || -z "$APP_VERSION" ]]; then
  echo "usage: $0 <app-id> <version>"
  exit 1
fi

echo "[mobile-app-store] app=${APP_ID} version=${APP_VERSION}"
echo "step 1: clone/pull source -> ${BASE_DIR}/sources/${APP_ID}"
echo "step 2: apply patches     -> ${BASE_DIR}/patches/${APP_ID}"
echo "step 3: build artifacts   -> ${BASE_DIR}/build/${APP_ID}"
echo "step 4: sign artifacts    -> ${BASE_DIR}/dist/${APP_ID}/${APP_VERSION}"
echo "step 5: update metadata   -> ${BASE_DIR}/metadata/index.json"
echo "step 6: publish to k3s app-catalog artifact path"

exit 0
