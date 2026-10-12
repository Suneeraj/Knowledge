# L06: Git Branches and Pull Requests

| | |
|---|---|
| **Duration** | 38 minutes |
| **Day / time** | Day 1, 14:02–14:40 |
| **Learning objective** | Use basic Git commands to inspect a repository, view file changes, stage and commit a change, and review commit history.


## What is Git?

Git keeps a history of changes to your project. You can save a group of changes as a **commit** and later see what changed.

## Before you start

- To work in your team repository, open its clone in a Codespace or terminal.
- To create a new local repository, make and enter a project folder, then initialize Git:

```bash
mkdir my-project
cd my-project
git init
```

- Run the commands below from the repository folder.

## 1. Find and inspect the repository

```bash
pwd
ls
git status
```

| Command | Meaning |
|---|---|
| `pwd` | Show the folder you are in. |
| `ls` | List files in that folder. |
| `git status` | Show the current branch and changed files. In a new repository, no branch exists until the first commit. |

If `git status` says this is not a Git repository, use `cd` to move into your cloned team repository or the folder where you ran `git init`, then try again.

## 2. Set your author name and email

Git records a name and email on each commit. Set these once on your computer. Use your name and the email linked to your GitHub account, or your GitHub noreply email.

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

These settings identify the commit author. They do not sign you in to GitHub or give repository access.

## 3. Create a practice file

Create a file named `practice.txt` and add one line to it. You can use any text editor. From a terminal, this command creates the file with one line:

```bash
echo "I am learning Git." > practice.txt
```

Check the status and look at the change:

```bash
git status
git diff -- practice.txt
```

`git diff` shows edits that have not yet been staged. A newly created file may not appear in `git diff` until it is staged; `git status` will still show it as untracked.

## 4. Save the change in a commit

First stage the file, then commit it:

```bash
git add practice.txt
git status
git commit -m "Add Git practice note"
```

| Command | Meaning |
|---|---|
| `git add practice.txt` | Select this file for the next commit. |
| `git commit -m "..."` | Save the selected changes with a message. |

Check that the working tree is clean and view your latest commit:

```bash
git status
git log --oneline -5
```

## 5. Try editing and committing again

Change the text in `practice.txt`, then run:

```bash
git diff
git add practice.txt
git commit -m "Update Git practice note"
git log --oneline -5
```

You have now made two commits. Each commit is a saved point in the project history.

## Commands to remember

```bash
git status                 # What branch am I on? What changed?
git diff                   # What edits did I make?
git add filename           # Select a file for the next commit
git commit -m "Message"    # Save selected changes
git log --oneline          # View recent commits
```

## Optional: connect Git to GitHub

To see the remote repository address:

```bash
git remote -v
```

In the next lab, you will use branches and pull requests to share changes with your team. Do not push directly to `main` if your team uses a pull request workflow.

## Quick help

- **What should I run when I feel lost?** Run `git status`.
- **Git says “Author identity unknown”?** Set `user.name` and `user.email` as shown above.
- **A file is untracked?** Run `git add filename` to include it in the next commit.
