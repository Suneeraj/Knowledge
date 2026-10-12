# L04: Process and Port Investigation

| | |
|---|---|
| **Duration** | 30 minutes |
| **Day / time** | Day 1, 12:00–12:30 |
| **Learning objective** | List and inspect processes, send signals to stop them, find which process owns a network port, and test HTTP endpoints with `curl`. |
| **Troubleshooting scenario** | T04: another process is already using the required port |

## Scenario

You try to start Campus Pulse for the first time, and it refuses: something is already using port 8080. Nobody on your team admits to starting anything. Find out **what** is using the port, **who** started it, and stop it safely.

## Prerequisites

- L01–L03 completed.
- The Python virtual environment exists (`bash scripts/check-env.sh` shows PASS for `.venv`).

## Starting files

| File | Purpose |
|---|---|
| `labs/L04-processes-ports/start-incident.sh` | Starts the mystery processes (do not read it yet) |
| `scripts/run-local.sh` | Starts Campus Pulse on port 8080 |

## Key ideas

- A **process** is a running program. Every process has a **PID** (process ID) and a parent (PPID).
- A **port** is a numbered "door" on a machine. Only **one** process can listen on a given port at a time.
- A **signal** is a message to a process. `SIGTERM` (15) means "please stop cleanly", `SIGKILL` (9) means "stop now, no clean-up", and `SIGSTOP`/`SIGCONT` pause and resume.
- **DNS** turns names like `github.com` into IP addresses. **HTTP** is the request/response protocol web apps speak, and status codes like `200`, `404` and `503` tell you how it went.

## Steps

### Part A: Processes and signals (10 min)

```bash
ps
ps aux | head -n 5
sleep 300 &
jobs
ps -f
kill %1
jobs
```

| Command | Why |
|---|---|
| `ps` | processes in **this** terminal |
| `ps aux` | **every** process on the machine, with CPU and memory use |
| `cmd &` | run a command in the **background** and get the prompt back |
| `jobs` / `kill %1` | list this shell's background jobs and stop job 1 (sends SIGTERM) |
| `ps -f` | full format: shows the PPID (parent) and the full command line |

Pause and resume a process:

```bash
sleep 300 &
PID=$!
ps -o pid,stat,cmd -p "$PID"
kill -STOP "$PID"
ps -o pid,stat,cmd -p "$PID"
kill -CONT "$PID"
kill "$PID"
```

`STAT` changes from `S` (sleeping) to `T` (stopped) and back. `$!` holds the PID of the last background command.

Watch everything live with `top` (press `q` to quit).

### Part B: The port incident (15 min)

```bash
bash labs/L04-processes-ports/start-incident.sh
cd "$REPO"
bash scripts/run-local.sh
```

Expected output (the failure):

```
Address already in use
Port 8080 is in use by another program. Either identify and stop that program, or start the server with a different port.
```

**Investigate before you fix.** Use these tools and write down what each one tells you:

```bash
ss -ltnp
ss -ltnp | grep 8080
ps -fp <PID>
lsof -i :8080
curl -v http://localhost:8080/
pgrep -af report-generator
```

| Command | Why |
|---|---|
| `ss -ltnp` | **s**ocket **s**tatistics: **l**istening, **T**CP, **n**umeric ports, with **p**rocess names and PIDs |
| `ps -fp PID` | details of one process: owner, parent and full command |
| `lsof -i :8080` | "**l**ist **o**pen **f**iles" for a network port (another view of the same answer) |
| `curl -v URL` | make an HTTP request and show **v**erbose headers. The `Server:` header is a big clue. |
| `pgrep -af NAME` | find processes whose command line matches NAME |

Then:

1. Stop the process using port 8080 with a polite `SIGTERM` (`kill <PID>`). Only use `kill -9` if it ignores SIGTERM.
2. Confirm the port is free: `ss -ltnp | grep 8080` prints nothing.
3. Start the app: `bash scripts/run-local.sh`. Leave it running.
4. In a **second terminal** (`+` in the terminal panel), test it:

```bash
curl -v http://localhost:8080/health
curl -s http://localhost:8080/ | jq
```

Expected output:

```
< HTTP/1.1 200 OK
...
{"status":"ok","uptime_seconds":4.2,"version":"1.0.0"}
```

5. There is a second suspicious process, `report-generator`. Find it and stop it as well.

### Part C: Networking basics (5 min)

```bash
ip -brief address
cat /etc/hosts
getent hosts github.com
dig +short github.com
curl -sI https://github.com | head -n 1
curl -s -o /dev/null -w "%{http_code}\n" http://localhost:8080/nope
```

| Command | Why |
|---|---|
| `ip -brief address` | this machine's network interfaces and IP addresses |
| `/etc/hosts` | local name-to-IP overrides, checked before DNS |
| `getent hosts NAME` | resolve a name the same way applications do |
| `dig +short NAME` | ask DNS directly |
| `curl -sI` | fetch only the response **headers** (`-I`) |
| `-w "%{http_code}"` | print just the HTTP status code (here `404`) |

## Student tasks

1. Identify the PID, process name, full command line and owner of whatever was on port 8080.
2. Stop it and the `report-generator` process with SIGTERM.
3. Start Campus Pulse and get `200 OK` from `/health`.
4. Write the incident note: symptom, evidence (paste the `ss` line), root cause and fix.

## Verification

With Campus Pulse still running in terminal 1, in terminal 2:

```bash
cd "$REPO"
bash scripts/checkpoint.sh L04
```

Expected output: `CHECKPOINT L04: PASS`.

## Common mistakes

| Mistake | Fix |
|---|---|
| `ss -ltn` (no `p`) shows the port but no process | Add `p` |
| Killing the wrong PID, for example your own shell | Always check with `ps -fp PID` before `kill` |
| Running `kill -9` first | Try SIGTERM first; SIGKILL gives the program no chance to clean up |
| Pressing `Ctrl+C` in the terminal running the app, then running the checkpoint | The checkpoint needs the app running. Restart it. |
| Opening `http://localhost:8080` in your laptop's browser | In Codespaces use the **Ports** tab → globe icon, or just use `curl` |

## Troubleshooting

- **`ss` shows no PID**: the process belongs to another user. Run `sudo ss -ltnp`.
- **`kill: (1234) - No such process`**: it already stopped. Check `ss` again.
- **App starts but `curl` hangs**: are you curling the right port? Read the app's startup log line: `configured (env=..., port=...)`.
- **Reset:** `bash scripts/reset-lab.sh L04`

## Extension challenge

1. Run the app on port 9090 without editing any file: `APP_PORT=9090 bash scripts/run-local.sh`. Prove it with `ss`.
2. Use `pstree -p` to show the parent chain of the app process.
3. Explain the difference between `0.0.0.0:8080` and `127.0.0.1:8080` in the `ss` output.

## Instructor solution

See `solutions/L04-processes-ports.md` in the instructor repository.
