#!/usr/bin/env bash
# Run Campus Pulse directly on the machine (no container), using .env for settings.
# Usage: bash scripts/run-local.sh
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ ! -x .venv/bin/python ]]; then
  echo "Creating virtual environment..."
  python3 -m venv .venv
  .venv/bin/pip install -r requirements-dev.txt
fi

if [[ -f .env ]]; then
  # Read KEY=VALUE lines one at a time. This keeps values with spaces intact
  # and uses the same file format as `docker run --env-file`.
  # A variable already set in the shell wins over the file, so
  # `APP_PORT=9000 bash scripts/run-local.sh` works as expected.
  while IFS='=' read -r key value; do
    [[ -z "${key}" || "${key}" == \#* ]] && continue
    if [[ -z "${!key+set}" ]]; then
      export "${key}=${value}"
    fi
  done < .env
  echo "Loaded settings from .env"
else
  echo "No .env file found; using built-in defaults (copy .env.example to .env to customise)."
fi

echo "Starting Campus Pulse on port ${APP_PORT:-8080} (press Ctrl+C to stop)"
exec .venv/bin/python wsgi.py
