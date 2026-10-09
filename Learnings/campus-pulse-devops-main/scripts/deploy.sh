#!/usr/bin/env bash
# Deploy a Campus Pulse image to this machine ("staging"), verify it, and roll back on failure.
#
# Usage: bash scripts/deploy.sh IMAGE [ENV_FILE]
#   IMAGE     e.g. campus-pulse:local or ghcr.io/<owner>/<repo>:latest
#   ENV_FILE  optional file of KEY=VALUE settings passed to the container
#
# What it does:
#   1. Pulls IMAGE if it is not already on this machine.
#   2. Stops the running "campus-pulse" container and keeps it as "campus-pulse-previous".
#   3. Starts the new container and runs the health check.
#   4. Healthy   -> removes the previous container.
#      Unhealthy -> prints the new container's logs, removes it, restarts the previous one.
set -euo pipefail

cd "$(dirname "$0")/.."

if [[ $# -lt 1 ]]; then
  echo "Usage: bash scripts/deploy.sh IMAGE [ENV_FILE]" >&2
  exit 2
fi

IMAGE="$1"
ENV_FILE="${2:-}"
NAME="campus-pulse"
PREVIOUS="${NAME}-previous"
PORT="${DEPLOY_PORT:-8080}"
STATE_DIR=".deploy"
HISTORY="${STATE_DIR}/history.log"

mkdir -p "${STATE_DIR}"

log() { echo "[deploy] $*"; }
record() { echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) $1 ${IMAGE}" >> "${HISTORY}"; }

container_exists() { docker container inspect "$1" > /dev/null 2>&1; }

if ! docker image inspect "${IMAGE}" > /dev/null 2>&1; then
  log "Pulling ${IMAGE}"
  docker pull "${IMAGE}"
fi

RUN_ARGS=(--detach --name "${NAME}" --publish "${PORT}:8080" --restart unless-stopped)
if [[ -n "${ENV_FILE}" ]]; then
  if [[ ! -f "${ENV_FILE}" ]]; then
    echo "Env file not found: ${ENV_FILE}" >&2
    exit 2
  fi
  RUN_ARGS+=(--env-file "${ENV_FILE}")
fi

container_exists "${PREVIOUS}" && docker rm -f "${PREVIOUS}" > /dev/null

if container_exists "${NAME}"; then
  OLD_IMAGE=$(docker container inspect --format '{{.Config.Image}}' "${NAME}")
  log "Stopping current release (${OLD_IMAGE})"
  docker stop "${NAME}" > /dev/null
  docker rename "${NAME}" "${PREVIOUS}"
  echo "${OLD_IMAGE}" > "${STATE_DIR}/previous_image"
fi

log "Starting ${IMAGE} on port ${PORT}"
docker run "${RUN_ARGS[@]}" "${IMAGE}" > /dev/null

if bash scripts/healthcheck.sh "http://localhost:${PORT}/health" 10 2; then
  container_exists "${PREVIOUS}" && docker rm "${PREVIOUS}" > /dev/null
  echo "${IMAGE}" > "${STATE_DIR}/current_image"
  record "SUCCESS"
  log "Deployment succeeded: ${IMAGE}"
  exit 0
fi

log "Health check FAILED. Logs from the new container:"
docker logs --tail 30 "${NAME}" 2>&1 || true
docker rm -f "${NAME}" > /dev/null
record "FAILED"

if container_exists "${PREVIOUS}"; then
  log "Rolling back to $(cat "${STATE_DIR}/previous_image")"
  docker rename "${PREVIOUS}" "${NAME}"
  docker start "${NAME}" > /dev/null
  if bash scripts/healthcheck.sh "http://localhost:${PORT}/health" 10 2; then
    echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) ROLLBACK $(cat "${STATE_DIR}/previous_image")" >> "${HISTORY}"
    log "Rollback succeeded. The previous release is serving traffic."
  else
    log "Rollback FAILED. The previous release is also unhealthy. Investigate with: docker logs ${NAME}"
  fi
else
  log "No previous release to roll back to."
fi
exit 1
