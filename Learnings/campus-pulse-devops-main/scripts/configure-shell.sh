#!/usr/bin/env bash
# Adds two conveniences to ~/.bashrc (once):
#   - REPO: the repository path, so `cd "$REPO"` always returns to it
#   - automatic activation of the .venv Python virtual environment
set -euo pipefail

REPO_PATH="$(cd "$(dirname "$0")/.." && pwd)"

if ! grep -q "campus-pulse settings" "${HOME}/.bashrc"; then
  {
    echo ""
    echo "# campus-pulse settings"
    echo "export REPO=\"${REPO_PATH}\""
    echo "if [ -f \"\${REPO}/.venv/bin/activate\" ]; then source \"\${REPO}/.venv/bin/activate\"; fi"
  } >> "${HOME}/.bashrc"
fi

echo "Shell configured: REPO=${REPO_PATH} (open a new terminal to use it)"
