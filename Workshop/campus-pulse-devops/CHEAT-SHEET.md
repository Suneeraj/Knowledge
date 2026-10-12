# Campus Pulse Command Cheat Sheet

```bash
# navigate and inspect
pwd; ls -la; cd DIR; find . -name '*.log'; head -n 5 FILE; tail -f FILE

# text and logs
grep 'ERROR' FILE; awk '{print $9}' FILE; sort FILE | uniq -c; wc -l FILE
command > out.txt          # overwrite stdout
command >> out.txt         # append stdout
command 2> errors.txt      # stderr

# permissions and processes
whoami; id; stat FILE; chmod u+x script.sh; chmod 600 secret
ps aux; pgrep -af python; ss -ltnp; kill PID; lsof -i :8080

# network and HTTP
ip addr; dig example.com; curl -i http://localhost:8080/health

# environment and Python
export APP_PORT=8080; env | sort; python3 -m venv .venv
source .venv/bin/activate; pip install -r requirements-dev.txt; pytest -v

# Git and GitHub
git status; git switch -c feature/name; git diff; git add FILE
git commit -m 'type: message'; git push -u origin HEAD
gh pr create --fill; gh pr checks --watch; git pull --ff-only

# Docker
docker build -t campus-pulse:local .
docker run -d --name campus-pulse -p 8080:8080 campus-pulse:local
docker ps -a; docker logs campus-pulse; docker inspect campus-pulse
docker exec -it campus-pulse sh; docker rm -f campus-pulse

# CI, deploy, and observe
yamllint .github/workflows/ci.yml; gh run view --log-failed
bash scripts/healthcheck.sh http://localhost:8080/health
bash scripts/deploy.sh campus-pulse:local; bash scripts/rollback.sh
curl -s http://localhost:8080/metrics
docker logs campus-pulse 2>&1 | bash scripts/log-report.sh
```

Safety habits: run `pwd` before deleting, inspect before killing, quote paths/variables, never use `chmod 777` as a shortcut, never commit `.env` or tokens, and read the first meaningful error.
