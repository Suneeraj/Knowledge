# L09: Build and Run the Application Container

| | |
|---|---|
| **Duration** | 25 minutes |
| **Day / time** | Day 1, 16:05–16:30 |
| **Learning objective** | Run a container with port mapping and environment variables, then inspect it with `docker ps`, `logs`, `exec`, `inspect` and `stats`. |

## Scenario

The image is built. Now run it like a production server would: in the background, on port 8080, with a health check. Then prove it is healthy and running as a non-root user.

## Prerequisites

- L08 completed: `docker image ls campus-pulse` shows the `local` tag.
- Nothing else is using port 8080. **Stop** `run-local.sh` if it is still running (`Ctrl+C`).

## Starting files

| File | Purpose |
|---|---|
| `Dockerfile`, `.dockerignore` | From L08 |
| `scripts/healthcheck.sh` | Polls `/health` with retries |

## Key ideas

```
 your Codespace / VM                          container "campus-pulse"
 ┌──────────────────────┐   -p 8080:8080      ┌────────────────────────┐
 │ curl localhost:8080 ─┼────────────────────►│ gunicorn on 0.0.0.0:8080│
 └──────────────────────┘   host:container    └────────────────────────┘
```

- `-p HOST:CONTAINER` connects a port on your machine to a port inside the container.
- A container has its **own** filesystem, processes and network. `localhost` **inside** the container is not your machine.

## Steps

### Step 1: Run it in the background

```bash
cd "$REPO"
docker run -d --name campus-pulse -p 8080:8080 campus-pulse:local
docker ps
```

Expected output:

```
CONTAINER ID   IMAGE                COMMAND                  STATUS                            PORTS                    NAMES
3f2a1b9c8d7e   campus-pulse:local   "sh -c 'exec gunicor…"   Up 3 seconds (health: starting)   0.0.0.0:8080->8080/tcp   campus-pulse
```

| Option | Why |
|---|---|
| `-d` | **d**etached: run in the background and return the prompt |
| `--name campus-pulse` | a fixed name, easier than the random ID |
| `-p 8080:8080` | publish container port 8080 on host port 8080 |

### Step 2: Check health and talk to it

```bash
bash scripts/healthcheck.sh http://localhost:8080/health
curl -s http://localhost:8080/ | jq
sleep 15
docker ps
```

After about 15 seconds the status changes to `Up ... (healthy)`. That is Docker running your `HEALTHCHECK`.

### Step 3: Logs

```bash
docker logs campus-pulse
docker logs --tail 3 campus-pulse
docker logs -f campus-pulse
```

With `-f` (follow), run `curl -s http://localhost:8080/` in a second terminal and watch a new JSON line appear. Press `Ctrl+C` to stop following; the container keeps running.

Notice: gunicorn's own messages (`Listening at: http://0.0.0.0:8080`) **and** the app's JSON lines both go to the container's output. Containers log to **stdout**, not to files.

### Step 4: Look inside

```bash
docker exec campus-pulse whoami
docker exec campus-pulse ls -la /app
docker exec campus-pulse env | grep APP_
docker exec -it campus-pulse bash
```

In the interactive shell, try `ps aux` (only a handful of processes) and `cat /etc/os-release`, then `exit`.

| Command | Why |
|---|---|
| `docker exec NAME CMD` | run a command **inside** a running container |
| `-it` | **i**nteractive with a **t**erminal, needed for a shell |

### Step 5: Inspect and measure

```bash
docker inspect campus-pulse --format '{{.State.Status}} {{.State.Health.Status}}'
docker inspect campus-pulse --format '{{json .Config.Env}}' | jq
docker port campus-pulse
docker stats --no-stream campus-pulse
```

### Step 6: Configuration at run time

Run a **second** container from the **same image** with different settings:

```bash
docker run -d --name campus-pulse-prod -p 8081:8080 \
  -e APP_ENV=production -e SECRET_KEY=demo-only-secret -e APP_NAME="Campus Pulse PROD" \
  campus-pulse:local
curl -s http://localhost:8081/ | jq
docker rm -f campus-pulse-prod
```

Same image, different behaviour, because only the environment changed. This is how one image moves from test to staging to production.

### Step 7: Lifecycle

```bash
docker stop campus-pulse
docker ps -a
docker start campus-pulse
docker ps
```

Leave `campus-pulse` **running** for the checkpoint.

## Student tasks

1. `campus-pulse` running from `campus-pulse:local`, mapped to port 8080, status `healthy`.
2. Prove the app runs as `appuser`, not `root`.
3. Show a JSON request log line for a request **you** made.
4. Run the production variant on port 8081, then remove it.

## Verification

```bash
bash scripts/checkpoint.sh L09
```

Expected output: `CHECKPOINT L09: PASS`.

## Common mistakes

| Mistake | Symptom | Fix |
|---|---|---|
| `run-local.sh` still running | `Bind for 0.0.0.0:8080 failed: port is already allocated` | Stop it (L04 skills: `ss -ltnp`) |
| Running `docker run` twice with the same name | `Conflict. The container name "/campus-pulse" is already in use` | `docker rm -f campus-pulse` first, or `docker start campus-pulse` |
| `-p 8080` only | Docker picks a random host port | Always use `-p HOST:CONTAINER` |
| Option after the image name: `docker run campus-pulse:local -p 8080:8080` | The options are passed to the app, not to Docker | All options go **before** the image name |
| Expecting `curl` inside the container | `curl: not found` | The slim image doesn't include it. Test from the host. |

## Troubleshooting

- **Status `unhealthy`**: run `docker inspect campus-pulse --format '{{json .State.Health}}' | jq` to see the health check's own output.
- **Container exits immediately**: `docker ps -a` shows `Exited (n)`. Run `docker logs campus-pulse`. That's L10's whole topic.
- **Port shows in `docker ps` but `curl` fails**: is the app inside listening on the port you mapped? Check the `Listening at:` line in the logs.

## Extension challenge

1. Limit the container: `--memory 128m --cpus 0.5`. Check it with `docker stats`.
2. Run with `--read-only --tmpfs /tmp`. Does the app still work? Why is a read-only filesystem good for security?
3. Run `docker image inspect campus-pulse:local --format '{{.Config.User}}'`. Where does this value come from?

## Instructor solution

See `solutions/L09-build-run.md` in the instructor repository.
