# L08: Write a Dockerfile

| | |
|---|---|
| **Duration** | 30 minutes |
| **Day / time** | Day 1, 15:35–16:05 |
| **Learning objective** | Write a Dockerfile and `.dockerignore` for a Python web app, and explain what every instruction does and why its order matters. |

## Scenario

"It works on my machine" is not good enough: the CI server and the production server need to run **exactly** the same thing. Your job is to package Campus Pulse as a container image recipe, a **Dockerfile**, that follows good practice: small base image, cached dependencies, a non-root user and a health check.

## Prerequisites

- L07 completed. Tests pass.
- Docker Engine works: `docker run --rm hello-world` prints "Hello from Docker!".

## Starting files

| File | Purpose |
|---|---|
| `labs/L08-dockerfile/Dockerfile.skeleton` | Starter Dockerfile with numbered comments |
| `labs/L08-dockerfile/dockerignore.skeleton` | Starter `.dockerignore` |
| `requirements.txt`, `app/`, `wsgi.py` | What goes inside the image |

## Key ideas

- An **image** is a read-only package: an operating system layer plus your app plus its dependencies. A **container** is a running instance of an image.
- Each Dockerfile instruction creates a **layer**. Docker **caches** layers and rebuilds only from the first changed one, so put rarely-changing steps (installing dependencies) **before** often-changing steps (copying your code).
- The **build context** is the folder you send to Docker (the `.` in `docker build .`). `COPY` can only see files in the context, minus anything listed in `.dockerignore`.

## Instruction reference

| Instruction | Example | What it does |
|---|---|---|
| `FROM` | `FROM python:3.12-slim` | start from a base image |
| `ARG` | `ARG APP_VERSION=1.0.0` | a value you can pass at **build** time with `--build-arg` |
| `ENV` | `ENV KEY=value OTHER=value` | an environment variable baked into the image |
| `WORKDIR` | `WORKDIR /app` | `cd` for every later instruction (created if missing) |
| `RUN` | `RUN useradd --create-home --uid 10001 appuser` | run a command **while building** |
| `COPY` | `COPY requirements.txt .` | copy files from the build context into the image |
| `USER` | `USER appuser` | run later instructions **and the container** as this user |
| `EXPOSE` | `EXPOSE 8080` | document which port the app listens on |
| `HEALTHCHECK` | see below | how Docker checks the app is healthy |
| `CMD` | see below | the command that runs when the container starts |

You can use `ENV` with several variables on one instruction by ending each line with `\`.

Install the requirements with:

```dockerfile
RUN pip install --no-cache-dir -r requirements.txt
```

Copy the health check **exactly**. It uses Python, because the slim image has no `curl`:

```dockerfile
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import os, urllib.request; urllib.request.urlopen('http://127.0.0.1:' + os.environ.get('APP_PORT', '8080') + '/health', timeout=2)"
```

Copy the start command **exactly**:

```dockerfile
CMD ["sh", "-c", "exec gunicorn --bind 0.0.0.0:${APP_PORT} --workers 1 --threads 4 wsgi:app"]
```

**Why** this form: `gunicorn` is a production web server (Flask's built-in server is for development only). `sh -c` lets `${APP_PORT}` expand. `exec` makes gunicorn process 1 (PID 1), so it receives the stop signal from `docker stop`. `wsgi:app` means "the `app` object in `wsgi.py`".

## Steps

### Step 1: Copy the starters to the repository root

```bash
cd "$REPO"
git switch main && git pull
git switch -c add-dockerfile
cp labs/L08-dockerfile/Dockerfile.skeleton Dockerfile
cp labs/L08-dockerfile/dockerignore.skeleton .dockerignore
```

### Step 2: Write the Dockerfile

Open `Dockerfile` and add one instruction under each numbered comment, using the reference table above. Keep the comments; they help reviewers.

### Step 3: Write `.dockerignore`

Open `.dockerignore` and add one pattern per line so that **only** `requirements.txt`, `app/` and `wsgi.py` are needed. At minimum, exclude `.git`, `.venv`, `.env`, `__pycache__`, `*.pyc`, `.pytest_cache`, `tests`, `labs` and `scripts`.

**Why:** a smaller context means faster builds, and it keeps secrets like `.env` out of the image.

### Step 4: Build it

```bash
docker build -t campus-pulse:local .
```

Expected output (BuildKit, shortened):

```
[+] Building 25.3s (11/11) FINISHED
 => [1/6] FROM docker.io/library/python:3.12-slim
 => [2/6] WORKDIR /app
 => [3/6] RUN useradd --create-home --uid 10001 appuser
 => [4/6] COPY requirements.txt .
 => [5/6] RUN pip install --no-cache-dir -r requirements.txt
 => [6/6] COPY app/ app/
 ...
 => => naming to docker.io/library/campus-pulse:local
```

### Step 5: See the layer cache at work

```bash
docker build -t campus-pulse:local .
echo "# cache test" >> app/routes.py
docker build -t campus-pulse:local .
git checkout -- app/routes.py
docker history campus-pulse:local
```

The second build takes about a second (`CACHED` on every step). After changing `app/routes.py`, only the steps from `COPY app/` onward re-run, and `pip install` stays cached. That is why requirements are copied **first**.

### Step 6: Commit and open a PR

```bash
git add Dockerfile .dockerignore
git commit -m "Add Dockerfile and .dockerignore"
git push -u origin add-dockerfile
gh pr create --fill --base main
```

Have a teammate review it and merge.

## Student tasks

1. `Dockerfile` at the repository root, with all 11 numbered items.
2. `.dockerignore` excluding at least the nine patterns in Step 3.
3. The image builds as `campus-pulse:local`.
4. Explain to your TA why `COPY requirements.txt` comes before `COPY app/`.
5. Changes merged to `main` through a PR.

## Verification

```bash
bash scripts/checkpoint.sh L08
```

Expected output: `CHECKPOINT L08: PASS`.

## Common mistakes

| Mistake | Symptom | Fix |
|---|---|---|
| File named `dockerfile` or `Dockerfile.txt` | `failed to read dockerfile: open Dockerfile: no such file` | Exact name `Dockerfile`, at the repo root |
| Forgetting the `.` at the end of `docker build` | `docker build requires 1 argument` | The `.` is the build context |
| `COPY . .` before `pip install` | Every code change reinstalls all packages | Copy `requirements.txt` first |
| `USER appuser` before `RUN useradd` | `unable to find user appuser` | Create the user first |
| `RUN gunicorn ...` instead of `CMD` | Build hangs forever, because `RUN` happens at **build** time | Use `CMD` to start the app |
| `requirements.txt` listed in `.dockerignore` | `"/requirements.txt": not found` | Never ignore files you `COPY` |

## Troubleshooting

- **`permission denied while trying to connect to the Docker daemon socket`** (VM): log out and in again after `setup-vm.sh` (docker group membership).
- **`toomanyrequests: You have reached your pull rate limit`**: Docker Hub is limiting your network. Tell your TA; VM images have `python:3.12-slim` pre-pulled.
- **Read build errors from the bottom up**: the last `ERROR:` line names the failing step number.

## Extension challenge

1. Run `docker image ls campus-pulse` to see the image size. Try `FROM python:3.12` (not slim) and compare. Why prefer slim?
2. Add `LABEL org.opencontainers.image.title="Campus Pulse"` and find it with `docker inspect`.
3. Research **multi-stage builds**. Where would one help in a bigger project?

## Instructor solution

See `solutions/L08-dockerfile.md` and `reference/Dockerfile` in the instructor repository.
