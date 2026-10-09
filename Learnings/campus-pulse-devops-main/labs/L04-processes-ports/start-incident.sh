#!/usr/bin/env bash
# Starts the L04 incident: background processes that the student must investigate.
set -euo pipefail

pkill -f "campus-legacy-server" 2> /dev/null || true
pkill -f "report-generator" 2> /dev/null || true

nohup bash -c 'exec -a campus-legacy-server python3 -m http.server 8080 --bind 0.0.0.0 --directory /tmp' \
  > /dev/null 2>&1 &
nohup bash -c 'exec -a report-generator sleep 100000' > /dev/null 2>&1 &

sleep 1
echo "Incident started. Somebody's app is not going to like this..."
