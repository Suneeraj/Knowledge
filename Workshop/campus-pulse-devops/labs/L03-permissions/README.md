# L03: Permissions Troubleshooting

| | |
|---|---|
| **Duration** | 22 minutes |
| **Day / time** | Day 1, 11:28–11:50 |
| **Learning objective** | Read `rwx` permissions in `ls -l` output, explain users, groups and "others", and fix permission problems with `chmod` using the **least privilege** needed. |
| **Troubleshooting scenario** | T01: incorrect file permissions |

## Scenario

**Incident ticket #1042:** "The nightly backup job `backup.sh` has not run for a week. Also, security says our database password file is readable by everyone on the server. Please fix both. Do NOT use `sudo` or `chmod 777`."

## Prerequisites

- L01 (navigation) completed.

## Starting files

| File | Purpose |
|---|---|
| `labs/L03-permissions/setup.sh` | Creates `~/labs/L03/deploy-tools` with broken permissions |

## Key ideas

```
-rwxr-x---  1 vscode  vscode  512 Oct  7 10:00 backup.sh
│└┬┘└┬┘└┬┘    └─user─┘ └group┘
│ │  │  └─ others: ---  (no access)
│ │  └──── group:  r-x  (read and execute)
│ └─────── user (owner): rwx  (read, write, execute)
└───────── type: - file, d directory, l link
```

| Permission | On a file | On a directory |
|---|---|---|
| `r` (4) | read the contents | list the names inside |
| `w` (2) | change the contents | create, delete or rename files inside |
| `x` (1) | run it as a program | enter it (`cd`) and reach the files inside |

Number form: add the values for each group, so `rwx`=7, `r-x`=5, `rw-`=6 and `r--`=4. `chmod 640 file` gives `rw-r-----`.

## Steps

### Step 1: Who am I?

```bash
whoami
id
groups
```

Expected output (Codespaces): `vscode`, then `uid=1000(vscode) gid=1000(vscode) groups=...`. These commands show which **user** you are and which **groups** you belong to. Permissions are checked against both.

### Step 2: Create the lab and reproduce the problem

```bash
bash labs/L03-permissions/setup.sh
cd ~/labs/L03/deploy-tools
./backup.sh
```

Expected output:

```
bash: ./backup.sh: Permission denied
```

### Step 3: Investigate

```bash
ls -l
ls -l config reports secrets
ls -ld reports secrets
stat -c '%A %a %U %n' backup.sh config/app.conf reports secrets secrets/db-password.txt
```

| Command | Why |
|---|---|
| `ls -l` | permissions of the files inside a directory |
| `ls -ld DIR` | permissions of the directory **itself** (`-d`) |
| `stat -c '%A %a %U %n'` | permissions as letters **and** numbers, plus the owner |

### Step 4: Fix, re-run, repeat

Fix **one** problem, run `./backup.sh` again, and read the **new** error. There are three problems in the backup path. Each fix reveals the next.

Useful commands:

```bash
chmod u+x FILE        # add execute for the owner (user) only
chmod u+r FILE        # add read for the owner
chmod u+w DIR         # add write for the owner
chmod 600 FILE        # rw------- : only the owner can read and write
chmod 700 DIR         # rwx------ : only the owner can enter and use it
```

When the job works you will see:

```
Reading configuration from config/app.conf
Backing up database on db.campus.internal
Report written to reports/backup-20261007-102233.txt
```

### Step 5: Fix the security finding

```bash
find ~/labs/L03 -perm -o+w
```

This lists everything that **others** (any user on the server) can write to. Make the password file readable and writable by the owner only, and the `secrets` directory usable by the owner only. Then run the `find` again: it should print nothing.

## Student tasks

1. Make `./backup.sh` run successfully, using the smallest permission changes possible.
2. Restrict `secrets/db-password.txt` to `600` and `secrets/` to `700`.
3. In `~/incident-notes.md`, record each error message you saw, the evidence, and the exact `chmod` that fixed it.

## Verification

```bash
cd "$REPO"
bash scripts/checkpoint.sh L03
```

Expected output: `CHECKPOINT L03: PASS`.

## Common mistakes

| Mistake | Why it is wrong |
|---|---|
| `chmod 777 everything` | Everyone on the server could change your backup script, which is a security hole. The checkpoint fails any world-writable file. |
| `sudo ./backup.sh` | Running as root hides the problem; the real nightly job does not run as root. |
| `chmod +x` on `config/app.conf` | Config files are read, never executed. Read permission is what's missing. |
| Fixing `reports/backup-*.txt` instead of `reports/` | The file does not exist yet. You need **write on the directory** to create files in it. |

## Troubleshooting

- **"Operation not permitted" when running chmod**: you do not own the file. Check the owner with `ls -l`. Here you own everything, so check you are in `~/labs/L03`.
- **Still "Permission denied" after `chmod u+x`**: read the full message. Is it the same file, or a different one now?
- **Start over:** `bash labs/L03-permissions/setup.sh`

## Extension challenge

1. Create a group and give it read access to the reports:

   ```bash
   sudo groupadd deployers
   sudo usermod -aG deployers "$USER"
   sudo chgrp -R deployers reports
   chmod 750 reports
   ```

   Then run `newgrp deployers` and `id`. What changed?
2. Run `umask` to print your current mask. Create a file and explain its default permissions using the umask.
3. Why does a directory need `x` to `cd` into it, even if it has `r`? Prove it with `chmod 600` on a test directory.

## Instructor solution

See `solutions/L03-permissions.md` in the instructor repository.
