#!/usr/bin/env bash
# Copies the web server access log into ~/labs/L02 for analysis.
set -euo pipefail

LAB_DIR="${HOME}/labs/L02"
SOURCE="$(cd "$(dirname "$0")" && pwd)/data/access.log"

rm -rf "${LAB_DIR}"
mkdir -p "${LAB_DIR}"
cp "${SOURCE}" "${LAB_DIR}/access.log"

echo "L02 ready: ${LAB_DIR}/access.log"
