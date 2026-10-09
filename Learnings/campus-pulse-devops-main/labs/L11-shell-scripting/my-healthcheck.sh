#!/usr/bin/env bash
# My health-check script (starter version).
# It checks the health endpoint once and always "succeeds", even when the app is down.
# Improve it by following labs/L11-shell-scripting/README.md.

curl http://localhost:8080/health
echo
echo "Health check finished"
