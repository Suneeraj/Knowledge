# L05: Environment Variables, Packages and Logs

| | |
|---|---|
| **Duration** | 25 minutes |
| **Day / time** | Day 1, 13:25–13:50 |
| **Learning objective** | Configure an application with environment variables, install software with `apt` and `pip`, and use logs to diagnose configuration failures. |
| **Troubleshooting scenarios** | T02: missing environment variable · T03: application running on the wrong port |

## Scenario

Campus Pulse is moving towards production. The ops team switched the server to production mode, and now the app will not start. After you fix that, a teammate "tidies up" the configuration, and the health check starts failing even though the app says it is running.

## Prerequisites

- L04 completed. **Stop any running copy of the app** (`Ctrl+C` in its terminal).
- No variable named `APP_*` set in your shell: `env | grep APP_` should print nothing. If it prints something, open a new terminal.

## Starting files

| File | Purpose |
|---|---|
| `.env.example` | Template settings, committed to Git |
| `.env` | Your real settings: **ignored by Git** (see `.gitignore`), created from `.env.example` |
| `app/config.py` | Reads and validates the environment variables |
| `labs/L05-env-config/start-incident.sh` | Starts incidents A and B |

## Key ideas

- An **environment variable** is a named value every process inherits from its parent: `NAME=value`.
- "Config in the environment" (from the Twelve-Factor App method) means the **same code** runs in development, CI and production, and only the environment changes.
- Secrets such as `SECRET_KEY` are **never committed** to Git. They go in `.env` (ignored) or a secret store.
- `apt` installs **system** packages for Ubuntu. `pip` installs **Python** packages, ideally inside a virtual environment (`.venv`) so projects do not interfere with each other.

## Steps

### Step 1: Environment variable basics (5 min)

```bash
echo "$HOME"
echo "$USER"
printenv | sort | head -n 15
GREETING="hello"
bash -c 'echo "child sees: [$GREETING]"'
export GREETING="hello"
bash -c 'echo "child sees: [$GREETING]"'
unset GREETING
```

Expected output: the first child prints `child sees: []`, and after `export` the second prints `child sees: [hello]`.

**Why:** only **exported** variables are passed to programs you start. This is exactly how the app receives its configuration.

### Step 2: Run the app with its configuration (5 min)

```bash
cd "$REPO"
cat .env.example
cat .env
grep -n "env.get" app/config.py
bash scripts/run-local.sh
```

In a second terminal:

```bash
curl -s http://localhost:8080/ | jq
```

Expected output:

```json
{
  "app": "Campus Pulse",
  "environment": "development",
  "message": "Welcome to Campus Pulse!",
  "version": "1.0.0"
}
```

Stop the app (`Ctrl+C`), then override one variable for one run only:

```bash
APP_NAME="Team Rocket Pulse" bash scripts/run-local.sh
```

Check `/` again, then stop the app. Variables set in front of a command apply to that command only.

### Step 3: Incident A (5 min)

```bash
bash labs/L05-env-config/start-incident.sh A
bash scripts/run-local.sh
echo "exit code: $?"
```

The app stops immediately. **Investigate:** read the log line carefully, then look at `.env` and `app/config.py`. Which variable is missing, and why is it only required in production?

Fix it the right way: generate a strong random secret and put it in `.env`. Do **not** turn production mode off.

```bash
python3 -c 'import secrets; print(secrets.token_hex(32))'
nano .env          # paste the value after SECRET_KEY=   (save: Ctrl+O, Enter; exit: Ctrl+X)
git status         # .env must NOT appear here
git check-ignore -v .env
```

Start the app again. `/` should now show `"environment": "production"`.

### Step 4: Incident B (5 min)

Stop the app, then:

```bash
bash labs/L05-env-config/start-incident.sh B
bash scripts/run-local.sh
```

In terminal 2:

```bash
curl -v http://localhost:8080/health
```

The app seems to be running, but `curl` fails. Investigate with what you learned in L04 (`ss -ltnp`) and the app's own startup log line. Fix the configuration so the app answers on **8080**, restart it, and leave it running.

### Step 5: Packages (3 min)

```bash
apt list --installed 2> /dev/null | grep -E '^(curl|jq)/'
apt-cache policy jq
sudo apt-get install -y htop
which htop
dpkg -L htop | grep bin
pip list
pip show flask
```

| Command | Why |
|---|---|
| `apt list --installed` | system packages already installed |
| `apt-cache policy PKG` | installed version and the version available from the repository |
| `sudo apt-get install -y PKG` | install a package (needs admin rights, hence `sudo`; `-y` answers "yes") |
| `dpkg -L PKG` | which files a package put on disk |
| `pip list` / `pip show` | Python packages in the active virtual environment |

### Step 6: Services and system logs (2 min)

Codespaces does **not** run `systemd`, so the `systemctl` part is shown by your instructor on a VM:

```bash
ps -p 1 -o comm=                 # Codespaces: not systemd. VM: systemd
tail -n 5 /var/log/apt/history.log
tail -n 20 /var/log/dpkg.log | grep htop
```

The last two commands show the `htop` installation you just did. System logs record what changed and when.

**VM users** can also run:

```bash
systemctl status docker
journalctl -u docker -n 20 --no-pager
sudo systemctl restart docker
```

## Student tasks

1. Fix incident A by adding a generated `SECRET_KEY` to `.env` (production mode stays on).
2. Fix incident B so the app answers on port 8080.
3. Confirm `.env` is ignored by Git.
4. Install `htop` and find its installation record in `/var/log/apt/history.log`.
5. Write incident notes for A and B.

## Verification

With the app running on port 8080, in terminal 2:

```bash
cd "$REPO"
bash scripts/checkpoint.sh L05
```

Expected output: `CHECKPOINT L05: PASS`.

## Common mistakes

| Mistake | Fix |
|---|---|
| `SECRET_KEY = abc` (spaces around `=`) | `.env` lines are `KEY=value` with no spaces |
| Setting `APP_ENV=development` to "fix" incident A | That hides the problem. Production needs a real secret. |
| Committing `.env` | Never. If you did, see the Day 2 secrets activity for why that is serious. |
| `export APP_PORT=5000` earlier in this terminal | Shell variables override `.env`. Run `unset APP_PORT` or open a new terminal. |
| Running `apt-get install` without `sudo` | "Permission denied / are you root?": system packages need admin rights |

## Troubleshooting

- **Which value is the app actually using?** The first log line prints `env` and `port`. Trust the log, not your assumptions.
- **`curl: (7) Failed to connect`**: nothing is listening on that port. `ss -ltnp` shows what is.
- **Reset:** `bash scripts/reset-lab.sh L05` restores `.env` from `.env.example`.

## Extension challenge

1. Set `LOG_LEVEL=LOUD` and start the app. What does the error say, and which line of `app/config.py` produced it?
2. Start the app with `LOG_LEVEL=WARNING`. Which log lines disappear?
3. Run `pip-audit -r requirements.txt` to check the app's dependencies for known vulnerabilities.

## Instructor solution

See `solutions/L05-env-config.md` in the instructor repository.
