#!/usr/bin/env bash
# Starts an L05 incident by changing the app's .env file.
# Usage: bash labs/L05-env-config/start-incident.sh A|B
set -euo pipefail

cd "$(dirname "$0")/../.."

if [[ ! -f .env ]]; then
  cp .env.example .env
fi

case "${1:-}" in
  A)
    sed -i 's/^APP_ENV=.*/APP_ENV=production/; s/^SECRET_KEY=.*/SECRET_KEY=/' .env
    echo "Incident A started: the ops team switched this server to production mode."
    ;;
  B)
    sed -i 's/^APP_PORT=.*/APP_PORT=5000/' .env
    echo "Incident B started: a teammate 'tidied up' the configuration."
    ;;
  *)
    echo "Usage: bash labs/L05-env-config/start-incident.sh A|B" >&2
    exit 2
    ;;
esac
