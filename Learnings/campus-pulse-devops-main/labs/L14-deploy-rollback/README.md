# L14: Deploy, Health Check, and Rollback

**Duration:** 40 minutes  
**Objective:** Deploy a versioned image, verify service health, and recover automatically from a failed release.

## Scenario and prerequisites

Campus Pulse must be updated without leaving users on a broken version. Complete L09, keep port 8080 free, and build the good image.

## Steps and commands

```bash
docker build --build-arg APP_VERSION=1.0.0 -t campus-pulse:1.0.0 .
bash scripts/deploy.sh campus-pulse:1.0.0
curl -fsS http://localhost:8080/health | jq .

docker build -f labs/L10-broken-container/incident-a/Dockerfile -t campus-pulse:broken .
bash scripts/deploy.sh campus-pulse:broken || echo "failure detected as expected"
curl -fsS http://localhost:8080/health | jq .
cat .deploy/history.log
```

The first deployment prints `Deployment succeeded`. The broken release fails its health check; the script prints logs and restarts the previous container. `history.log` records failure and rollback evidence. `docker ps`, `docker logs campus-pulse`, `docker inspect`, and `bash scripts/healthcheck.sh URL 3 1` are the main investigation tools.

## Student tasks and verification

Deploy the good image, attempt the broken release, prove the good version still answers `/health`, and add an incident note explaining detection and recovery.

```bash
bash scripts/checkpoint.sh L14
```

## Mistakes, troubleshooting, extension, and solution

- Port already allocated: find its owner with `ss -ltnp | grep 8080` and stop only the known lab process.
- Production exits: it needs a secret; use an env file that is ignored by Git.
- No rollback is possible on the first ever deployment because there is no previous container.
- Never “fix” a health failure by removing the health check.

Extension: set `DEPLOY_PORT=8082` for a staging deployment. Instructor solution is the command sequence above; evidence must show SUCCESS, FAILED, and ROLLBACK.
