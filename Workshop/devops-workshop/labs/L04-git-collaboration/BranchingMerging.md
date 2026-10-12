# L07: GitHub Remote Repository, Push, Pull Requests, and Merge

  ----------------------------------- -----------------------------------
  **Duration**                        45--60 minutes
  **Prerequisite**                    Complete L06: Git basics, staging,                                   commits, and `git log
  **Learning objective**              Create a GitHub repository, connect
                                      a local repository, push code,
                                      create a branch, open a pull
                                      request, and merge it safely.
  ----------------------------------- -----------------------------------

## What you will learn

By the end of this lab, you will be able to:

1.  Create a remote repository on GitHub.
2.  Connect your local Git repository to GitHub.
3.  Push your local commits to the remote repository.
4.  Create a feature branch and make a change.
5.  Push the branch and open a pull request (PR).
6.  Review and merge the PR into `main`.
7.  Update your local `main` branch and verify the result.

## Git terms

-   **Local repository:** The Git repository on your computer or
    Codespace.
-   **Remote repository:** A repository hosted on GitHub.
-   **`origin`:** The conventional name Git gives the remote repository
    you connect to.
-   **Branch:** An independent line of work, such as `main` or
    `feature/update-readme`.
-   **Push:** Send local commits to a remote repository.
-   **Pull request (PR):** A request to review and merge changes from
    one branch into another.
-   **Merge:** Combine changes from one branch into another.

> **Important:** A Git commit is saved locally. It does not appear on
> GitHub until you push it.

------------------------------------------------------------------------

## Part 1: Create a remote repository on GitHub

1.  Sign in to [GitHub](https://github.com/).
2.  Click the **+** icon in the top-right corner and choose **New
    repository**.
3.  Enter a repository name, for example: `git-practice-lab`.
4.  Add a short description, such as
    `Practice Git branches and pull requests`.
5.  Choose **Public** or **Private** according to your instructor's
    instructions.
6.  If you already have a local repository with commits from L06, create
    the GitHub repository **without** initializing it with a README,
    `.gitignore`, or license. This avoids an unrelated initial-history
    conflict.
7.  Click **Create repository**.
8.  Keep the repository page open. GitHub will show its URL.

Example remote URLs (use your own repository URL, not these
placeholders):

``` bash
https://github.com/YOUR-USERNAME/git-practice-lab.git
git@github.com:YOUR-USERNAME/git-practice-lab.git
```

## Part 2: Check your local repository

Open a terminal in the project folder you used in L06.

``` bash
pwd
git status
git log --oneline
```

Confirm that you are in the correct repository and can see your previous
commit.

Check the current branch:

``` bash
git branch --show-current
```

If your team or instructor expects the default branch to be `main`, you
can rename the current branch:

``` bash
git branch -M main
```

Only do this if you intend to use `main` as the default branch.

## Part 3: Configure your Git author identity

If you already completed this in L06, you can skip this section.

``` bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Verify:

``` bash
git config --global user.name
git config --global user.email
```

These values identify the author of commits. **They do not authenticate
you to GitHub or grant repository permissions.**

## Part 4: Connect your local repository to GitHub

Copy the repository URL from the GitHub page, then run the matching
command.

### Option A: HTTPS

``` bash
git remote add origin https://github.com/YOUR-USERNAME/git-practice-lab.git
```

When GitHub requires authentication, use an approved sign-in method,
such as Git Credential Manager or a personal access token when prompted.
Your GitHub account password is not accepted for Git HTTPS operations.

### Option B: SSH

``` bash
git remote add origin git@github.com:YOUR-USERNAME/git-practice-lab.git
```

SSH requires a public key registered with the correct GitHub account and
working SSH authentication.

Verify the remote:

``` bash
git remote -v
```

Expected shape of the output:

``` text
origin  https://github.com/YOUR-USERNAME/git-practice-lab.git (fetch)
origin  https://github.com/YOUR-USERNAME/git-practice-lab.git (push)
```

Your URL may use SSH instead of HTTPS.

### If `origin` already exists

If Git reports `error: remote origin already exists`, inspect it:

``` bash
git remote -v
```

If it points to the wrong repository, update it:

``` bash
git remote set-url origin https://github.com/YOUR-USERNAME/git-practice-lab.git
```

Use your actual URL and the URL type you intend to use.

## Part 5: Push your local code to GitHub

Push the current `main` branch:

``` bash
git push -u origin main
```

The `-u` option sets the upstream tracking branch. For later pushes from
`main`, you can usually run:

``` bash
git push
```

Refresh the GitHub repository page. Your files and commit history should
now be visible.

### If you get an error

-   **`Permission denied (publickey)`**: SSH authentication failed.
    Check that your SSH key exists, is loaded, and is added to the
    correct GitHub account. Test with `ssh -T git@github.com`.
-   **`Repository not found`**: Check the URL, spelling, repository
    visibility, and whether your account has access.
-   **`src refspec main does not match any`**: Check
    `git branch --show-current` and `git log --oneline`. You may be on a
    differently named branch or may not have made a commit yet.
-   **`rejected` / `fetch first`**: The remote may already contain
    commits that are not in your local history. Inspect the repository
    and history before integrating changes. Do not force-push as a first
    fix.

If the remote repository was initialized with a README or other file and
now has a separate history, stop and inspect before proceeding:

``` bash
git status
git log --oneline --all --graph
git remote -v
```

For this beginner lab, the simplest path is to create an empty remote
repository before the first push.

------------------------------------------------------------------------

## Part 6: Create a feature branch

Avoid making your practice change directly on `main`. Create a separate
branch:

``` bash
git switch -c feature/add-lab-notes
```

Confirm the current branch:

``` bash
git branch --show-current
git status
```

Expected branch name:

``` text
feature/add-lab-notes
```

A branch lets you work on a change without immediately changing `main`.

## Part 7: Make and commit a change

Open `practice.txt` and add a new line, for example:

``` text
I can push a branch and open a pull request.
```

Review the change:

``` bash
git status
git diff
```

Stage and commit it:

``` bash
git add practice.txt
git status
git commit -m "Add pull request practice note"
git log --oneline -5
```

The commit is currently on your local feature branch.

## Part 8: Push the feature branch

``` bash
git push -u origin feature/add-lab-notes
```

Open GitHub and refresh the repository page. GitHub may show a prompt to
compare the new branch and create a pull request.

If you do not see the prompt, use the repository's **Pull requests** tab
and click **New pull request**.

## Part 9: Open a pull request

On GitHub, set:

-   **Base:** `main` --- the branch you want to merge into.
-   **Compare:** `feature/add-lab-notes` --- the branch containing your
    change.

Check that the changed file and diff are correct.

Use a clear title, such as:

``` text
Add pull request practice note
```

Example description:

``` markdown
## Summary
- Added a note about pushing a branch and opening a pull request.

## Testing
- Checked the change with `git diff`.
- Committed the change on `feature/add-lab-notes`.
```

Click **Create pull request**.

A pull request is a review request; creating it does not merge the code
automatically.

## Part 10: Review and merge the pull request

1.  Open the pull request and inspect the **Files changed** tab.
2.  Confirm that the intended change is present and no unrelated files
    were changed.
3.  If working with a teammate, ask them to review it. In a solo
    practice repository, review your own diff.
4.  If GitHub reports required checks or approvals, satisfy those
    requirements before merging.
5.  Click **Merge pull request** and confirm the merge. Choose the merge
    method permitted by the repository or your instructor.
6.  After the merge succeeds, the PR should show that it was merged into
    `main`.

In a real team repository, follow its branch protection rules and review
policy. Do not bypass required approvals or push directly to `main` when
the team requires pull requests.

## Part 11: Update your local `main` branch

After the PR has been merged on GitHub, switch to `main`:

``` bash
git switch main
git pull origin main
```

Verify the latest commits and repository status:

``` bash
git log --oneline --graph --decorate -10
git status
```

The working tree should be clean, and the merged change should be
present in `main`.

Optionally, remove your local feature branch after confirming the merge:

``` bash
git branch -d feature/add-lab-notes
```

Optionally, remove the remote feature branch if it was not automatically
deleted and you no longer need it:

``` bash
git push origin --delete feature/add-lab-notes
```

Do not delete a branch that still contains work you need.

------------------------------------------------------------------------

## Complete command flow

Replace the URL and username placeholders with your own details.

``` bash
# Inspect your repository
git status
git log --oneline
git branch --show-current

# Connect to GitHub (run once; use your own URL)
git remote add origin https://github.com/YOUR-USERNAME/git-practice-lab.git
git remote -v

# Push the initial main branch
git branch -M main
git push -u origin main

# Create a feature branch
git switch -c feature/add-lab-notes

# Edit practice.txt, then stage and commit
git diff
git add practice.txt
git commit -m "Add pull request practice note"

# Push the feature branch
git push -u origin feature/add-lab-notes

# Then create, review, and merge the PR on GitHub.

# After merging, update local main
git switch main
git pull origin main
git log --oneline --graph --decorate -10
git status
```

**Note:** Run `git branch -M main` before the first push if your current
branch needs to be renamed. If `origin` already exists, inspect it
instead of repeating `git remote add origin`.

------------------------------------------------------------------------

## Troubleshooting quick reference

  ---------------------------------------------------------------------------
  Problem                                 What to check
  --------------------------------------- -----------------------------------
  `Permission denied (publickey)`         SSH key setup and GitHub account
                                          access

  `Repository not found`                  Remote URL, repository existence,
                                          and permissions

  `remote origin already exists`          Inspect with `git remote -v`; use
                                          `git remote set-url` if needed

  `src refspec main does not match any`   Branch name and whether a commit
                                          exists

  Pull request has no changes             Confirm the correct base and
                                          compare branches; ensure the
                                          feature commit was pushed

  Merge is blocked                        Review required approvals, status
                                          checks, and branch protection rules

  `git push` is rejected                  Fetch/inspect the remote history
                                          and integrate safely; avoid
                                          force-pushing
  ---------------------------------------------------------------------------

## Quick knowledge check

1.  What is the difference between a local and remote repository?
2.  What does `git push -u origin main` do?
3.  Why should you use a feature branch instead of working directly on
    `main`?
4.  What do the **base** and **compare** branches mean in a pull
    request?
5.  Does creating a pull request automatically merge it?
6.  Why should you run `git pull origin main` after the PR is merged?
7.  What is the difference between `git config user.email` and GitHub
    authentication?

## Lab completion checklist

-   [ ] Created a GitHub repository.
-   [ ] Connected the local repository to GitHub.
-   [ ] Pushed the initial `main` branch.
-   [ ] Created `feature/add-lab-notes`.
-   [ ] Made and committed a change.
-   [ ] Pushed the feature branch.
-   [ ] Opened a pull request targeting `main`.
-   [ ] Reviewed and merged the pull request.
-   [ ] Pulled the merged changes into local `main`.
-   [ ] Verified the commit history and clean working tree.

## Key takeaway

The standard collaboration workflow is:

**Create a branch → make a change → commit → push → open a pull request
→ review → merge → update local `main`.**
