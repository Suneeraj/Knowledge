#!/usr/bin/env bash
# Starts an L10 incident.
# Usage: bash labs/L10-broken-container/start-incident.sh A|B
set -euo pipefail

cd "$(dirname "$0")/../.."

case "${1:-}" in
  A)
    docker rm -f l10-a > /dev/null 2>&1 || true
    docker build -q -f labs/L10-broken-container/incident-a/Dockerfile -t campus-pulse:incident-a . > /dev/null
    docker run -d --name l10-a -p 8081:8080 campus-pulse:incident-a > /dev/null
    echo "Incident A started: the contractor's image is deployed as container l10-a on port 8081."
    echo "Users report http://localhost:8081/health does not work."
    ;;
  B)
    if [[ ! -f .dockerignore ]]; then
      echo "No .dockerignore found. Complete L08 first." >&2
      exit 1
    fi
    if ! grep -qx '\*\.txt' .dockerignore; then
      printf '%s\n' '*.txt' >> .dockerignore
    fi
    echo "Incident B started: a teammate added a rule to keep 'text junk' out of the image."
    echo "Now run: docker build -t campus-pulse:local ."
    ;;
  *)
    echo "Usage: bash labs/L10-broken-container/start-incident.sh A|B" >&2
    exit 2
    ;;
esac
