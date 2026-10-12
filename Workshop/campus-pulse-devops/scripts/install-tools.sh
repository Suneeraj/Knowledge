#!/usr/bin/env bash
# Install the command-line tools used in the course (Ubuntu 24.04).
# Used by both the Codespace (post-create.sh) and the VM (setup-vm.sh).
# Usage: sudo bash scripts/install-tools.sh
set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  echo "Please run with sudo: sudo bash scripts/install-tools.sh" >&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y --no-install-recommends \
  python3 python3-venv python3-pip \
  git curl jq tree nano less \
  iproute2 procps lsof psmisc dnsutils \
  ca-certificates

# GitHub CLI (used to open pull requests and check workflow runs).
# Codespaces already provides it; the Ubuntu VM gets it from the universe repository.
if ! command -v gh > /dev/null 2>&1; then
  apt-get install -y gh
fi

echo "Tools installed."
