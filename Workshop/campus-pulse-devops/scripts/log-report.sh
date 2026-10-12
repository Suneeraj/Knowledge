#!/usr/bin/env bash
# Summarise Campus Pulse JSON logs.
# Usage:
#   docker logs campus-pulse 2>&1 | bash scripts/log-report.sh
#   bash scripts/log-report.sh app.log
# Non-JSON lines (for example gunicorn's own messages) are skipped.
set -euo pipefail

INPUT="${1:-/dev/stdin}"

# Keep only lines that parse as JSON, then collect them into one array.
ENTRIES=$(jq -R -c 'fromjson? // empty' < "${INPUT}" | jq -s '.')

echo "== Log levels =="
echo "${ENTRIES}" | jq -r 'group_by(.level)[] | "\(.[0].level)\t\(length)"'

echo
echo "== Requests by path and status =="
echo "${ENTRIES}" | jq -r '
  map(select(.event == "http_request"))
  | group_by([.path, .status])[]
  | "\(.[0].status)\t\(length)\t\(.[0].path)"'

echo
echo "== Average response time (ms) =="
echo "${ENTRIES}" | jq -r '
  map(select(.event == "http_request") | .duration_ms)
  | if length == 0 then "no requests" else (add / length * 100 | round / 100 | tostring) end'

echo
echo "== Slowest 3 requests =="
echo "${ENTRIES}" | jq -r '
  map(select(.event == "http_request"))
  | sort_by(-.duration_ms)[:3][]
  | "\(.duration_ms) ms\t\(.method) \(.path)\trequest_id=\(.request_id)"'

echo
echo "== Errors (status >= 500 or level ERROR/CRITICAL) =="
echo "${ENTRIES}" | jq -r '
  map(select((.status // 0) >= 500 or .level == "ERROR" or .level == "CRITICAL"))
  | if length == 0 then "none" else .[] | "\(.timestamp) \(.level) \(.message)" end'
