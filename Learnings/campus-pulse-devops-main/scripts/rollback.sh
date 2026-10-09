#!/usr/bin/env bash
# Manually roll back to the release that was running before the last successful deploy.
# Usage: bash scripts/rollback.sh [ENV_FILE]
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ ! -s .deploy/previous_image ]]; then
  echo "No previous release recorded in .deploy/previous_image." >&2
  exit 1
fi

PREVIOUS_IMAGE=$(cat .deploy/previous_image)
echo "[rollback] Redeploying ${PREVIOUS_IMAGE}"
exec bash scripts/deploy.sh "${PREVIOUS_IMAGE}" "$@"
