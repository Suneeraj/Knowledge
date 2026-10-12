#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARTIFACT="${ARTIFACT:-$SCRIPT_DIR/build/site/index.html}"
DESTINATION="${DESTINATION:-$SCRIPT_DIR/deployed}"

if [[ ! -f "$ARTIFACT" ]]; then
  printf 'Deploy failed: %s not found. Run build.sh first.\n' "$ARTIFACT" >&2
  exit 1
fi

bash "$SCRIPT_DIR/test.sh"

mkdir -p "$DESTINATION"
cp "$ARTIFACT" "$DESTINATION/index.html"
printf 'Local deployment complete: %s/index.html\n' "$DESTINATION"