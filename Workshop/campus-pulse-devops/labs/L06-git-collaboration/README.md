# L06: Git Branches and Pull Requests

| | |
|---|---|
| **Duration** | 38 minutes |
| **Day / time** | Day 1, 14:02–14:40 |
| **Learning objective** | Use the team Git workflow: branch → commit → push → pull request → review → merge, and resolve a merge conflict. |
| **Team work** | Yes. Every team member does Part B on their own branch. |

## Scenario

Your team shares one repository. Nobody pushes directly to `main`: every change goes through a **pull request (PR)** that a teammate reviews. Today's change is small: each member adds themselves to `TEAM.md`. Because everyone edits the same file at the same time, you will hit a **merge conflict**, which is normal and fixable.

## Prerequisites

- The **team lead** created the team repository from the template, and every member has accepted the collaborator invitation (Settings → Collaborators → Add people).
- Each member has a Codespace (or VM clone) of the **team** repository.
- VM users only: run `gh auth login` once (choose GitHub.com → HTTPS → login with a web browser).

## Starting files

| File | Purpose |
|---|---|
| `TEAM.md` | Team motto and member table: the file everyone edits |

## Key ideas

| Term | Meaning |
|---|---|
| **commit** | a saved snapshot of your changes, with a message explaining **why** |
| **branch** | a movable label for a line of commits; isolates your work from `main` |
| **push** / **pull** | upload your commits to GitHub / download others' commits |
| **pull request** | "please review and merge my branch into `main`"; where review and CI happen |
| **merge conflict** | Git cannot decide automatically because two branches changed the same lines |

```
main     ──●──────────────●──────────●──
             \           /          /
add-asha      ●───●─────┘          /
               \                  /
add-ravi        ●────────────────┘   ← conflict: both added a line in the same place
```

## Steps

### Part A: Set up Git (5 min, everyone)

```bash
cd "$REPO"
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global pull.rebase false
git status
git log --oneline -5
git remote -v
```

Use the email address of your GitHub account (or your GitHub "noreply" address from Settings → Emails).

| Command | Why |
|---|---|
| `git config --global` | your identity, recorded in every commit; `pull.rebase false` makes `git pull` merge (the behaviour this lab expects) |
| `git status` | what changed, and which branch you're on. Run it constantly. |
| `git log --oneline` | compact history |
| `git remote -v` | where `push` and `pull` go (your team repo on GitHub) |

### Part B: Your own branch and PR (15 min, everyone in parallel)

Replace `asha` with **your** first name in lowercase:

```bash
git switch main
git pull
git switch -c add-asha
nano TEAM.md
```

Add **one row** at the end of the members table, for example:

```
| Asha | asha-dev | grep |
```

Then:

```bash
git diff
git add TEAM.md
git status
git commit -m "Add Asha to the team profile"
git push -u origin add-asha
```

Expected output of the push ends with a link such as `https://github.com/<team>/<repo>/pull/new/add-asha`.

Open the pull request, either from that link in the browser or from the terminal:

```bash
gh pr create --base main --head add-asha --title "Add Asha to the team profile" --body "Adds my row to TEAM.md"
```

| Command | Why |
|---|---|
| `git switch -c NAME` | create a branch and switch to it |
| `git diff` | review your change **before** staging it |
| `git add FILE` | stage: choose what goes in the next commit |
| `git commit -m` | save the snapshot with a message (imperative mood: "Add …", "Fix …") |
| `git push -u origin NAME` | upload the branch and remember where it goes (`-u`) |

### Part C: Review and merge (8 min)

1. Each member **reviews a teammate's PR** on GitHub: **Files changed** tab → leave at least one comment → **Review changes → Approve**.
2. The **first** approved PR is merged by its author: **Merge pull request → Confirm**.
3. The **second** PR now shows *"This branch has conflicts that must be resolved"*. Why? Both branches added a line at the same place in `TEAM.md`.

### Part D: Resolve the conflict locally (10 min, author of the conflicting PR)

```bash
git switch add-ravi
git pull origin main
```

Expected output:

```
CONFLICT (content): Merge conflict in TEAM.md
Automatic merge failed; fix conflicts and then commit the result.
```

```bash
git status
cat TEAM.md
```

You will see:

```
<<<<<<< HEAD
| Ravi | ravi-k | ls -la |
=======
| Asha | asha-dev | grep |
>>>>>>> <commit id>
```

Edit `TEAM.md`: **keep both rows** and delete the three marker lines (`<<<<<<<`, `=======`, `>>>>>>>`). Then:

```bash
grep -n '^<<<<<<<\|^=======\|^>>>>>>>' TEAM.md     # must print nothing
git add TEAM.md
git commit -m "Merge main and keep both team members"
git push
```

The PR on GitHub now says *"This branch has no conflicts"*. Get it approved and merge it. Third team member: repeat Part D if your PR conflicts too.

### Part E: Everyone syncs (2 min)

```bash
git switch main
git pull
git log --oneline --graph -10
git branch -d add-asha
```

## Student tasks

1. Every member has one commit on `main` that adds their row to `TEAM.md` (merged through a PR).
2. Every PR has at least one review comment or approval from a teammate.
3. At least one merge conflict was resolved and pushed.
4. **Team task:** change the "Team motto" line through one more PR, reviewed and merged.

## Verification

```bash
git switch main && git pull
bash scripts/checkpoint.sh L06
```

Expected output: `CHECKPOINT L06: PASS`. The TA also checks your PR list on GitHub.

## Common mistakes

| Mistake | Fix |
|---|---|
| Committing on `main` instead of your branch | `git switch -c add-asha` **carries the uncommitted change with you**; commit there instead |
| Leaving `<<<<<<<` markers in the file | The checkpoint fails. Search with `grep -n '<<<<<<<' TEAM.md`. |
| Deleting your teammate's row while resolving | Keep **both** rows: you are combining work, not choosing a winner |
| `git push` rejected: "fetch first" | Someone pushed before you. `git pull`, then push again. |
| Stuck in a strange editor after `git pull` | It's asking for a merge message. In `nano`: `Ctrl+O`, `Enter`, `Ctrl+X`. In `vim`: type `:wq` and press `Enter`. |

## Troubleshooting

- **"Permission denied" on push**: the team lead must add you as a collaborator, and you must **accept** the invitation (check your email or github.com/notifications).
- **Lost?** `git status` always tells you which branch you are on and what to do next.
- **Want to undo a local commit that you have not pushed yet?** `git reset --soft HEAD~1` keeps your changes but removes the commit.

## Extension challenge

1. Protect `main`: Settings → Branches → Add rule → "Require a pull request before merging". Try `git push` directly to `main`. What happens?
2. Use `git log --author="Asha" --oneline` and `git blame TEAM.md`. What does each tell you?
3. Make a mistake commit on a branch, then undo it with `git revert HEAD`. How is that different from `git reset`?

## Instructor solution

See `solutions/L06-git-collaboration.md` in the instructor repository.
