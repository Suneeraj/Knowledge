#!/usr/bin/env bash
# Poll a health endpoint until it answers HTTP 200, or give up.
# Usage: bash scripts/healthcheck.sh [URL] [ATTEMPTS] [DELAY_SECONDS]
# Example: bash scripts/healthcheck.sh http://localhost:8080/health 10 2
# Exit code: 0 = healthy, 1 = unhealthy.
set -uo pipefail

URL="${1:-http://localhost:8080/health}"
ATTEMPTS="${2:-10}"
DELAY="${3:-2}"

for ((i = 1; i <= ATTEMPTS; i++)); do
  if BODY=$(curl --silent --show-error --fail --max-time 3 "${URL}" 2>&1); then
    echo "HEALTHY (attempt ${i}/${ATTEMPTS}): ${BODY}"
    exit 0
  fi
  echo "Waiting for ${URL} (attempt ${i}/${ATTEMPTS}): ${BODY}"
  sleep "${DELAY}"
done

echo "UNHEALTHY: ${URL} did not return HTTP 200 after ${ATTEMPTS} attempts" >&2
exit 1
