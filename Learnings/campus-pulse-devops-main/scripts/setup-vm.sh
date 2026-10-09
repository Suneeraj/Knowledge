#!/usr/bin/env bash
# Prepare a fresh Ubuntu 24.04 LTS VM for the course (alternative to Codespaces).
# Run from the repository root as a normal user with sudo rights:
#   bash scripts/setup-vm.sh
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ "${EUID}" -eq 0 ]]; then
  echo "Run this as your normal user (not root); it uses sudo where needed." >&2
  exit 1
fi

echo "==> Installing course tools"
sudo bash scripts/install-tools.sh

echo "==> Installing Docker Engine from Ubuntu packages (no Docker Desktop)"
sudo apt-get install -y docker.io
sudo systemctl enable --now docker

echo "==> Allowing ${USER} to use docker without sudo"
sudo usermod -aG docker "${USER}"

echo "==> Pre-pulling the base image (avoids Docker Hub rate limits on shared campus networks)"
sudo docker pull python:3.12-slim

echo "==> Creating the Python virtual environment"
python3 -m venv .venv
.venv/bin/pip install --upgrade pip
.venv/bin/pip install -r requirements-dev.txt

if [[ ! -f .env ]]; then
  cp .env.example .env
fi
chmod +x scripts/*.sh
bash scripts/configure-shell.sh

echo ""
echo "Setup complete."
echo "IMPORTANT: log out and log back in (or reboot) so the docker group takes effect."
echo "Then run:  source .venv/bin/activate && bash scripts/check-env.sh"
