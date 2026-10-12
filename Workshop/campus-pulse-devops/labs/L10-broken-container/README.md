# L10: Diagnose a Broken Container

| | |
|---|---|
| **Duration** | 25 minutes |
| **Day / time** | Day 1, 16:30–16:55 |
| **Learning objective** | Diagnose container failures methodically with `docker ps -a`, `docker logs`, `docker inspect` and `docker port`, and fix their root causes. |
| **Troubleshooting scenarios** | T06: incorrect Dockerfile command · T07: missing Docker build-context file · T03 again: app on the wrong port |

## Scenario

**Incident A:** a contractor "tuned" the Dockerfile. Their image is deployed as container `l10-a` on port 8081, and users say `/health` is down.
**Incident B:** a teammate edited `.dockerignore` to keep "text junk" out of the image. Now the image will not even build.

## Prerequisites

- L09 completed. `campus-pulse` may keep running on port 8080; this lab uses **8081**.

## Starting files

| File | Purpose |
|---|---|
| `labs/L10-broken-container/incident-a/Dockerfile` | The contractor's Dockerfile |
| `labs/L10-broken-container/start-incident.sh` | Starts incident A or B |
| `.dockerignore` | Your file from L08 (incident B modifies it) |

## The container troubleshooting checklist

Use this order every time. Write down what each step tells you.

| # | Question | Command |
|---|---|---|
| 1 | Is it running, or did it exit? With what code? | `docker ps -a` |
| 2 | What did it say before it died? | `docker logs NAME` |
| 3 | What command, environment and ports does it really have? | `docker inspect NAME --format '{{json .Config.Cmd}}'` (also `.Config.Env`) |
| 4 | Which ports are mapped? | `docker port NAME` |
| 5 | Is the app listening where we think? | the `Listening at:` line in `docker logs` |
| 6 | Did the image build at all? | read the **last** `ERROR` lines of `docker build` |

## Steps

### Incident A (15 min)

```bash
cd "$REPO"
bash labs/L10-broken-container/start-incident.sh A
curl -v http://localhost:8081/health
```

Work through the checklist. You should find **two** separate problems: the first stops the container from starting at all, and the second only appears once the first is fixed.

To test a fix, edit `labs/L10-broken-container/incident-a/Dockerfile`, then rebuild and re-run **under a new tag**:

```bash
docker rm -f l10-a
docker build -f labs/L10-broken-container/incident-a/Dockerfile -t campus-pulse:fixed-a .
docker run -d --name l10-a -p 8081:8080 campus-pulse:fixed-a
bash scripts/healthcheck.sh http://localhost:8081/health 10 2
```

| Option | Why |
|---|---|
| `-f PATH` | use a Dockerfile that is not at the context root |
| `-t campus-pulse:fixed-a` | a new tag, so the broken image stays available for comparison |

**Rule:** fix the **Dockerfile**, not the `docker run` command. The image must work with the standard `-p 8081:8080` mapping.

### Incident B (8 min)

```bash
bash labs/L10-broken-container/start-incident.sh B
docker build -t campus-pulse:local .
```

Read the error **from the bottom up**. Which file is "not found"? Does it exist on disk (`ls -l`)? So why can Docker not see it? Fix the cause, then rebuild successfully.

```bash
git diff .dockerignore
```

## Student tasks

1. Container `l10-a` runs from `campus-pulse:fixed-a`, reports `healthy`, and answers on `http://localhost:8081/health`.
2. `docker build -t campus-pulse:local .` succeeds again.
3. Incident notes for **all three** root causes (two in A, one in B), each with the exact evidence line from the logs or the build output.

## Verification

```bash
bash scripts/checkpoint.sh L10
```

Expected output: `CHECKPOINT L10: PASS`.

## Common mistakes

| Mistake | Fix |
|---|---|
| Changing `-p 8081:8080` to `-p 8081:5000` | That hides the bug; the image must listen where its documentation (`EXPOSE`) says. Fix the Dockerfile. |
| Rebuilding but running the **old** tag | Run `campus-pulse:fixed-a`, not `incident-a` |
| Forgetting `docker rm -f l10-a` | `Conflict. The container name "/l10-a" is already in use` |
| Deleting `.dockerignore` entirely to fix B | Now `.git` and `.env` go into the build context. Remove only the bad rule. |
| Only reading the first lines of `docker logs` | The real error is usually at the end |

## Troubleshooting

- **`docker logs` is empty**: the process died before printing anything. Check `docker inspect l10-a --format '{{.State.ExitCode}} {{.State.Error}}'`.
- **`curl: (56) Recv failure: Connection reset by peer`**: Docker accepted the connection, but nothing inside the container is listening on the mapped port.
- **Docker says `(healthy)` but `curl` from your machine fails**: the health check runs **inside** the container, so it can pass while the published port mapping points at the wrong container port. "Healthy" is only as good as what the check actually tests.
- **Reset:** `bash scripts/reset-lab.sh L10` (removes `l10-a`, restores the incident Dockerfile, removes the bad `.dockerignore` rule).

## Extension challenge

1. Change `CMD` to the "shell form" without `exec`, rebuild, and time `docker stop` (`time docker stop l10-a`). Why is it 10 seconds slower? (Hint: PID 1 and signals.)
2. Add `--restart on-failure:3` to a container that crashes, and watch the `RestartCount` with `docker inspect`.
3. Use `docker events` in a second terminal while you start and stop containers.

## Instructor solution

See `solutions/L10-broken-container.md` in the instructor repository.
