#!/usr/bin/env bash
# Pre-flight check: confirms the lab environment is ready.
# Usage: bash scripts/check-env.sh
# Exit code 0 = every required check passed.

cd "$(dirname "$0")/.."

FAILURES=0

pass() { printf '  [PASS] %s\n' "$1"; }
warn() { printf '  [WARN] %s\n' "$1"; }
fail() { printf '  [FAIL] %s\n' "$1"; FAILURES=$((FAILURES + 1)); }

check_command() {
  if command -v "$1" > /dev/null 2>&1; then
    pass "$1 is installed"
  else
    fail "$1 is missing"
  fi
}

echo "Campus Pulse environment check"
echo "------------------------------"

if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  pass "Operating system: ${PRETTY_NAME}"
fi

for tool in bash git curl jq python3 ss ps; do
  check_command "${tool}"
done

if python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)' 2> /dev/null; then
  pass "Python version $(python3 -c 'import platform; print(platform.python_version())')"
else
  fail "Python 3.10 or newer is required"
fi

if [[ -x .venv/bin/python ]]; then
  pass "Virtual environment .venv exists"
  if .venv/bin/python -c 'import flask, pytest' 2> /dev/null; then
    pass "Flask and pytest are installed in .venv"
  else
    fail "Dependencies missing: run .venv/bin/pip install -r requirements-dev.txt"
  fi
else
  fail "No .venv found: run python3 -m venv .venv && .venv/bin/pip install -r requirements-dev.txt"
fi

if command -v docker > /dev/null 2>&1; then
  if docker info > /dev/null 2>&1; then
    pass "Docker Engine is running ($(docker version --format '{{.Server.Version}}'))"
  else
    fail "docker is installed but the daemon is not reachable (VM: log out and in again after setup)"
  fi
else
  fail "docker is missing"
fi

if [[ -n "$(git config --global user.name)" && -n "$(git config --global user.email)" ]]; then
  pass "Git identity: $(git config --global user.name) <$(git config --global user.email)>"
else
  warn "Git identity not set: git config --global user.name \"Your Name\" and user.email"
fi

if ss -ltn 2> /dev/null | grep -q ':8080 '; then
  warn "Port 8080 is already in use (find it with: ss -ltnp | grep 8080)"
else
  pass "Port 8080 is free"
fi

FREE_MB=$(df -Pm . | awk 'NR==2 {print $4}')
if [[ "${FREE_MB}" -ge 2000 ]]; then
  pass "Free disk space: ${FREE_MB} MB"
else
  warn "Low disk space: ${FREE_MB} MB (2000 MB recommended)"
fi

echo "------------------------------"
if [[ "${FAILURES}" -eq 0 ]]; then
  echo "RESULT: READY"
  exit 0
else
  echo "RESULT: ${FAILURES} check(s) failed. Ask a TA for help."
  exit 1
fi
