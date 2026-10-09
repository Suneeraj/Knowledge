#!/usr/bin/env bash
# Runs once when a GitHub Codespace is created (see .devcontainer/devcontainer.json).
set -euo pipefail

cd "$(dirname "$0")/.."

sudo bash scripts/install-tools.sh

python3 -m venv .venv
.venv/bin/pip install --upgrade pip
.venv/bin/pip install -r requirements-dev.txt

if [[ ! -f .env ]]; then
  cp .env.example .env
fi

chmod +x scripts/*.sh

bash scripts/configure-shell.sh

echo "Codespace ready. Open a new terminal and run: bash scripts/check-env.sh"
