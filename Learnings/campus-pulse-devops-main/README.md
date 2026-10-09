# Campus Pulse: DevOps from Zero

A small Python Flask web app used in a two-day, hands-on DevOps workshop:
**Linux → Git → Testing → Containers → CI/CD → Deployment → Logs and Monitoring**.

## Endpoints

| Path       | Purpose                                              |
|------------|------------------------------------------------------|
| `/`        | Welcome message, app name, environment and version   |
| `/health`  | Health check: `{"status": "ok", "version": ...}`     |
| `/metrics` | Request counters in Prometheus text format           |

## Configuration (environment variables)

| Variable      | Default        | Notes                                      |
|---------------|----------------|--------------------------------------------|
| `APP_NAME`    | `Campus Pulse` | Shown on `/`                               |
| `APP_ENV`     | `development`  | `development`, `testing` or `production`   |
| `APP_PORT`    | `8080`         | Port the app listens on                    |
| `LOG_LEVEL`   | `INFO`         | `DEBUG`, `INFO`, `WARNING`, `ERROR`        |
| `APP_VERSION` | `1.0.0`        | Shown on `/health`; CI sets it per build   |
| `SECRET_KEY`  | (none)         | **Required** when `APP_ENV=production`     |

## Quick start: GitHub Codespaces (recommended)

1. Click **Use this template → Create a new repository** (team lead only), then add teammates as collaborators.
2. Click **Code → Codespaces → Create codespace on main**. Setup takes about 3 minutes.
3. In the terminal:

```bash
bash scripts/check-env.sh        # every check should PASS
pytest -v                        # run the automated tests
bash scripts/run-local.sh        # start the app; open port 8080 when prompted
```

## Quick start: Ubuntu 24.04 VM

```bash
git clone https://github.com/YOUR-TEAM/campus-pulse-devops.git
cd campus-pulse-devops
bash scripts/setup-vm.sh          # then log out and back in
source .venv/bin/activate
bash scripts/check-env.sh
```

## Workshop labs

All lab instructions are in [`labs/README.md`](labs/README.md). The capstone is in [`capstone/README.md`](capstone/README.md).
The completed instructor reference includes `Dockerfile`, `.dockerignore`, and `.github/workflows/ci.yml`;
students can temporarily move these aside when completing the write-it-yourself labs.

Course planning is in [`course/COURSE-DESIGN.md`](course/COURSE-DESIGN.md), instructor materials are in
[`instructor/`](instructor/), assessments are in [`assessments/`](assessments/), and the printable command
reference is [`CHEAT-SHEET.md`](CHEAT-SHEET.md).

## Run in a container

```bash
docker build -t campus-pulse:local .
docker run -d --name campus-pulse -p 8080:8080 campus-pulse:local
bash scripts/healthcheck.sh http://localhost:8080/health
docker logs campus-pulse
```

## Deploy with health check and automatic rollback

```bash
bash scripts/deploy.sh campus-pulse:local
bash scripts/deploy.sh ghcr.io/OWNER/REPO:latest   # image pushed by CI (lowercase owner/repo)
bash scripts/rollback.sh                            # go back to the previous release
cat .deploy/history.log
```

## Scripts

| Script                      | Purpose                                                    |
|-----------------------------|------------------------------------------------------------|
| `scripts/install-tools.sh`  | Install course tools with apt (used by the two below)      |
| `scripts/post-create.sh`    | Codespace first-time setup                                 |
| `scripts/setup-vm.sh`       | Ubuntu VM setup, including Docker Engine                   |
| `scripts/check-env.sh`      | Pre-flight PASS/FAIL report                                |
| `scripts/run-local.sh`      | Run the app without a container, using `.env`              |
| `scripts/healthcheck.sh`    | Poll `/health` with retries; exit code 0 or 1              |
| `scripts/deploy.sh`         | Deploy an image, verify health, roll back on failure       |
| `scripts/rollback.sh`       | Redeploy the previous release                              |
| `scripts/log-report.sh`     | Summarise JSON logs with `jq`                              |
| `scripts/checkpoint.sh`     | Check a lab's result: `bash scripts/checkpoint.sh L03`     |
| `scripts/reset-lab.sh`      | Restore a lab's starting state: `bash scripts/reset-lab.sh L03` |

## CI pipeline

The workflow you build in L12 (`.github/workflows/ci.yml`) runs on every push and pull request to `main`:

1. **Lint and test:** `flake8`, `yamllint`, `pytest`
2. **Build and smoke-test image:** `docker build`, start the container in production mode, check `/health`
3. **Push to GitHub Container Registry:** only on pushes to `main`

The optional repository secret `APP_SECRET_KEY` is used as `SECRET_KEY` in the smoke test.
