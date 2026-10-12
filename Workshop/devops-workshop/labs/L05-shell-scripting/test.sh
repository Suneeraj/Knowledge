#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARTIFACT="${ARTIFACT:-$SCRIPT_DIR/build/site/index.html}"

if [[ ! -f "$ARTIFACT" ]]; then
  printf 'Test failed: %s not found. Run build.sh first.\n' "$ARTIFACT" >&2
  exit 1
fi

if ! grep -q '<title>Workshop Demo</title>' "$ARTIFACT"; then
  printf 'Test failed: expected title was not found.\n' >&2
  exit 1
fi

printf 'Test passed: page exists and title is correct.\n'