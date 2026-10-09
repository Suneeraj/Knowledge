#!/usr/bin/env bash
set -euo pipefail
LAB="${1:-}"
case "$LAB" in
  L01|L02|L03) bash "labs/${LAB}-"*/setup.sh ;;
  L04|L05|L07|L10) git restore app tests Dockerfile .dockerignore 2>/dev/null || true; docker rm -f l10-a campus-pulse port-blocker >/dev/null 2>&1 || true ;;
  L11) git restore labs/L11-shell-scripting/my-healthcheck.sh 2>/dev/null || true ;;
  L12|L13) git restore .github/workflows/ci.yml 2>/dev/null || true ;;
  L14) docker rm -f campus-pulse campus-pulse-previous >/dev/null 2>&1 || true ;;
  *) echo 'Usage: bash scripts/reset-lab.sh L01..L14' >&2; exit 2 ;;
esac
echo "$LAB reset."
