# L01: Linux Navigation and File Management Challenge

| | |
|---|---|
| **Duration** | 35 minutes |
| **Day / time** | Day 1, 09:50–10:25 |
| **Learning objective** | Move around the Linux filesystem and create, find, copy, move, rename and delete files and directories, without a graphical file manager. |

## Scenario

The previous administrator of the campus web server left in a hurry. The server is a mess: old logs everywhere, temporary files, a file name with a space in it. Somewhere there is a hidden note that leads to a secret word. Find the secret word, then tidy the server up.

## Prerequisites

- A terminal open in your Codespace or VM.
- No Linux knowledge needed. This is the first lab.

## Starting files

| File | Purpose |
|---|---|
| `labs/L01-linux-navigation/setup.sh` | Creates the practice area at `~/labs/L01/campus-server` |

The practice area lives in your home directory (`~`), **outside** the Git repository, so nothing you do here gets committed.

## Key ideas (read in 2 minutes)

- Linux has **one tree** of directories starting at `/` (the root). There are no `C:` or `D:` drives.
- `~` is shorthand for your home directory, for example `/home/vscode`.
- An **absolute path** starts with `/` and works from anywhere. A **relative path** starts from where you are now.
- `.` means "this directory" and `..` means "the parent directory".
- Files whose names start with `.` are **hidden**. `ls` does not show them unless you add `-a`.

## Steps

### Step 1: Create the practice area

```bash
bash labs/L01-linux-navigation/setup.sh
```

Expected output:

```
L01 ready: /home/vscode/labs/L01/campus-server
```

(Your home directory may differ on a VM, for example `/home/student`.)

### Step 2: Look around

```bash
cd ~/labs/L01/campus-server
pwd
ls
ls -l
ls -la
tree -a
```

Expected output (`ls`):

```
README.txt  departments  logs  tmp  uploads
```

`ls -la` and `tree -a` also show `.hidden`.

| Command | Why |
|---|---|
| `cd DIR` | **c**hange **d**irectory: move into `DIR` |
| `pwd` | **p**rint **w**orking **d**irectory: "where am I?" |
| `ls` | list the directory contents |
| `ls -l` | long format: permissions, owner, size and date |
| `ls -a` | include hidden files (names starting with `.`) |
| `tree -a` | draw the whole directory tree, hidden files included |

### Step 3: Read files

```bash
cat README.txt
cat departments/cse/notices/exam-schedule.txt
head -n 3 logs/app-2026-10-01.log
tail -n 2 logs/app-2026-10-02.log
less logs/app-2026-10-03.log
```

In `less`, press `Space` for the next page, `/ERROR` then `Enter` to search, and `q` to quit.

| Command | Why |
|---|---|
| `cat FILE` | print a whole (short) file |
| `head -n N FILE` | first N lines |
| `tail -n N FILE` | last N lines, handy for the newest log entries |
| `less FILE` | scroll through a long file without flooding the screen |

### Step 4: Find things

```bash
find . -name "*.log"
find . -name "*.tmp"
find . -name ".*" -type f
ls -lhS uploads
du -ah uploads | sort -h
```

| Command | Why |
|---|---|
| `find . -name "PATTERN"` | search this directory and everything below it; quote the pattern |
| `-type f` | only files (not directories) |
| `ls -lhS` | **h**uman-readable sizes, **S**orted by size, largest first |
| `du -ah DIR \| sort -h` | disk usage of every file, smallest to largest |

### Step 5: Hunt for the secret word

Use the commands from Steps 2–4 to find the hidden file, read it, and follow its clue.
**Do not open the big file with `cat`**: it has 40,000 lines. Think about which command shows only the last line.

### Step 6: Tidy the server

Still inside `~/labs/L01/campus-server`:

```bash
mkdir -p archive/2026-10
mv logs/*.log archive/2026-10/
rmdir logs
mkdir notices-public
cp departments/cse/notices/exam-schedule.txt notices-public/
mv "uploads/report final.pdf" uploads/report-final.pdf
rm tmp/*.tmp
rmdir tmp
```

| Command | Why |
|---|---|
| `mkdir -p a/b` | make a directory, creating parent directories as needed |
| `mv SRC DEST` | move, or rename when the destination is a new name in the same place |
| `*.log` | a **glob**: the shell expands it to every matching file name |
| `cp SRC DEST` | copy (the original stays) |
| `"report final.pdf"` | quotes keep a name containing a space as a single argument |
| `rm FILE` | delete a file. **There is no recycle bin.** |
| `rmdir DIR` | delete an **empty** directory (safer than `rm -r`) |

## Student tasks

Complete these in `~/labs/L01/campus-server`:

1. Find the secret word and save it: `echo "THE-WORD" > answer.txt`. Use the real word, in capitals, exactly as written.
2. Count the lines containing `ERROR` (uppercase) across all three log files, and save just the number in `error-count.txt`.
3. Do every tidy-up action from Step 6.
4. There is one more `.tmp` file hiding somewhere else. Find it and delete it too.

## Verification

```bash
cd "$REPO"          # REPO always points to your repository (set up by the course scripts)
bash scripts/checkpoint.sh L01
```

Expected output ends with:

```
CHECKPOINT L01: PASS
```

## Common mistakes

| Mistake | What happens | Fix |
|---|---|---|
| `mv uploads/report final.pdf ...` without quotes | `mv` sees two files, `report` and `final.pdf` | Quote the name or escape the space: `report\ final.pdf` |
| `cat uploads/big-dataset.csv` | 40,000 lines flood the terminal | Press `Ctrl+C`, then use `tail -n 1` |
| `grep -ci error` | Counts "errors" and "error rate" too, so the number is too high | Uppercase `ERROR`, case-sensitive |
| `rm -r` on the wrong directory | Data gone forever | Run `pwd` before every delete |
| Running the tidy commands from `~` | "No such file or directory" | `cd ~/labs/L01/campus-server` first |

## Troubleshooting

- **"No such file or directory"**: check where you are with `pwd` and what is there with `ls`. Use `Tab` to auto-complete names; if Tab does nothing, the path is wrong.
- **"rmdir: failed to remove 'logs': Directory not empty"**: something is still inside. Run `ls -la logs` (hidden files count).
- **Messed everything up?** Run `bash labs/L01-linux-navigation/setup.sh` again to start fresh.

## Extension challenge

1. Use **one** `grep` command to count ERROR lines per file (hint: `grep -c`).
2. Find every file larger than 100 KB with `find`, using `-size`.
3. Which log file has the most `ERROR` lines about the database? Use `grep` with a longer pattern.

## Instructor solution

See `solutions/L01-linux-navigation.md` in the instructor repository.
