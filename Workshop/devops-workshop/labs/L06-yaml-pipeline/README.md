# L06: Introduction to YAML Pipeline Using GitHub Actions

  -----------------------------------------------------------------------
  Details                             Description
  ----------------------------------- -----------------------------------
  Duration                            25 minutes

  Level                               Beginner

  Prerequisites                       Basic Git commands and a GitHub
                                      account

  Learning objective                  Create a simple GitHub Actions
                                      workflow that runs Build, Test, and
                                      Deploy jobs when a pull request is
                                      created.
  -----------------------------------------------------------------------

## 1. Introduction

In this lab, you will learn how to use a YAML file to create a simple CI
pipeline using GitHub Actions.

You will create a GitHub repository, add a YAML workflow file, create a
feature branch, push your changes, and open a pull request.

GitHub Actions will automatically run three jobs:

1.  Build
2.  Test
3.  Deploy

For this beginner exercise, each job prints a message to demonstrate how
a pipeline works. No actual application or deployment is required.

## 2. Understand the folder structure

GitHub Actions automatically looks for workflow files inside a specific
folder in your repository.

You must create the following folder structure:

``` text
my-first-pipeline/
└── .github/
    └── workflows/
        └── ci.yaml
```

### What does each folder mean?

-   `my-first-pipeline/` --- Your local project folder and Git
    repository.
-   `.github/` --- A special folder used for GitHub-related
    configuration.
-   `workflows/` --- The folder where GitHub Actions workflow files are
    stored.
-   `ci.yaml` --- The YAML file that defines your pipeline.

**Important:** The `.github` folder must be inside your repository's
root folder. The `ci.yaml` file must be inside `.github/workflows/`.

Do not create `ci.yaml` directly in the root folder.


## 3. Clone the repository to your computer

Open your terminal or Git Bash.

Navigate to the folder where you want to keep your lab projects. For
example:

``` bash
cd ~/labs
```

Clone your repository using the URL shown on your GitHub repository
page:

``` bash
git clone https://github.com/YOUR-USERNAME/my-first-pipeline.git
```

Replace `YOUR-USERNAME` with your actual GitHub username.

Move into the repository:

``` bash
cd my-first-pipeline
```

Verify that you are inside the repository:

``` bash
pwd
```

Check the current Git branch:

``` bash
git branch
```

The default branch will usually be `main`.

## 4. Create a feature branch

A feature branch allows you to make changes without working directly on
the `main` branch.

Create a branch named `feature/first-pipeline`:

``` bash
git checkout -b feature/first-pipeline
```

Verify the current branch:

``` bash
git branch
```

Expected output:

``` text
* feature/first-pipeline
```

The asterisk indicates the branch you are currently working on.

**Rule:** Always create a feature branch before making changes. Do not
make your lab changes directly on `main`.

## 5. Create the GitHub Actions workflow folders

You must create two folders: `.github` and `workflows`.

From the repository root, run:

``` bash
mkdir -p .github/workflows
ls -la
ls -la .github/workflows
```

It will initially be empty.

### 6 Create the YAML file

Create a file named `ci.yaml` inside `.github/workflows/`:

``` bash
touch .github/workflows/ci.yaml
```

Your directory structure should now look like this:

``` text
my-first-pipeline/
└── .github/
    └── workflows/
        └── ci.yaml
```


## 7. Add the YAML pipeline code

Open `.github/workflows/ci.yaml` in your editor.

Copy and paste the following code:

``` yaml
name: CI Pipeline

on:
  pull_request:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: echo "Build successful"

  test:
    runs-on: ubuntu-latest
    needs: build
    steps:
      - uses: actions/checkout@v4
      - run: echo "Test successful"

  deploy:
    runs-on: ubuntu-latest
    needs: test
    steps:
      - uses: actions/checkout@v4
      - run: echo "Deploy successful"
```

Save the file.

### Understand the YAML code

**Workflow name**

``` yaml
name: CI Pipeline
```

This gives your workflow the name `CI Pipeline`. You will see this name
in the Actions tab on GitHub.

**Workflow trigger**

``` yaml
on:
  pull_request:
```

This tells GitHub Actions to start the workflow when a pull request
event occurs in the repository.

**Jobs**

``` yaml
jobs:
  build:
```

The `jobs` section contains the tasks that GitHub Actions must execute.
Here, the first job is named `build`.

**Runner**

``` yaml
runs-on: ubuntu-latest
```

This tells GitHub to run the job on a GitHub-hosted Ubuntu virtual
machine.

**Steps**

``` yaml
steps:
  - uses: actions/checkout@v4
  - run: echo "Build successful"
```

-   `actions/checkout@v4` checks out the repository's code on the
    runner.
-   `run` executes a shell command.
-   `echo` prints a message in the job logs.

**Job dependency**

``` yaml
needs: build
```

This means the `test` job must wait for the `build` job to succeed.

Similarly:

``` yaml
needs: test
```

This means the `deploy` job must wait for the `test` job to succeed.

The pipeline therefore runs in this order:

``` text
Build → Test → Deploy
```

If a required job fails, its dependent jobs are skipped by default.

**Note:** Each job runs on its own runner. This example does not pass
files between jobs because it only prints messages.

## 8. Commit your changes


``` bash
git status
git add .github/workflows/ci.yaml
git commit -m "Add beginner CI pipeline"
git status
```

Your commit is now saved locally on the feature branch.

## 9. Push the feature branch to GitHub

Run:

``` bash
git push -u origin feature/first-pipeline
```

This uploads your feature branch and its commit to GitHub.

Open your repository in the browser and refresh the page. You should be
able to see the `feature/first-pipeline` branch.

## 10. Create a pull request

1.  Open your GitHub repository.
2.  Click **Pull requests**.
3.  Click **New pull request**.
4.  Select `main` as the **base** branch.
5.  Select `feature/first-pipeline` as the **compare** branch.
6.  Click **Create pull request**.
7.  Enter a title such as `Add beginner CI pipeline`.
8.  Click **Create pull request** again.

Your pull request compares the changes on the feature branch with the
`main` branch.

Because the workflow listens for `pull_request` events, GitHub Actions
will start running the pipeline.

## 11. View the pipeline execution

After opening the pull request:

1.  Open the repository's **Actions** tab.
2.  Select **CI Pipeline**.
3.  Click the latest workflow run.
4.  Inspect the `build`, `test`, and `deploy` jobs.

You should see the jobs run in sequence:

``` text
build   ✓
  ↓
test    ✓
  ↓
deploy  ✓
```

Open each job to view its logs.

For example, the Build job should display:

``` text
Build successful
```

The Test job should display:

``` text
Test successful
```

The Deploy job should display:

``` text
Deploy successful
```

You can also return to the pull request and inspect the **Checks**
section to see whether the workflow succeeded.

## 12. Experiment with a failure (optional)

Let's see what happens when a job fails.

Open `.github/workflows/ci.yaml` and change this line:

``` yaml
- run: echo "Test successful"
```

to:

``` yaml
- run: exit 1
```

The command `exit 1` terminates the step with a failure status.

Commit and push the change:

``` bash
git add .github/workflows/ci.yaml
git commit -m "Test pipeline failure"
git push
```

Because you pushed another commit to the feature branch while the pull
request is open, GitHub Actions will run again.

Expected behavior:

-   `build` succeeds.
-   `test` fails.
-   `deploy` is skipped because it depends on `test`.

After observing the result, restore the original Test command:

``` yaml
- run: echo "Test successful"
```

Commit and push the correction.

## 13. Complete the lab

Check each item after completing it.

-   [ ] I created a GitHub repository.
-   [ ] I cloned the repository to my computer.
-   [ ] I created and switched to a feature branch.
-   [ ] I created `.github/workflows/ci.yaml` in the correct location.
-   [ ] I added the YAML pipeline code.
-   [ ] I committed and pushed the feature branch.
-   [ ] I opened a pull request from the feature branch into `main`.
-   [ ] I observed the Build, Test, and Deploy jobs in GitHub Actions.
-   [ ] I understand how `needs` controls the job order.
-   [ ] I understand that a failed Test job prevents the Deploy job from
    running.

## 14. Key takeaways

1.  GitHub Actions uses YAML files to define workflows.
2.  Workflow files must be placed inside `.github/workflows/`.
3.  The `on` section defines the events that trigger a workflow.
4.  The `jobs` section defines the work to perform.
5.  The `run` keyword executes shell commands.
6.  The `needs` keyword defines dependencies between jobs.
7.  Feature branches and pull requests allow changes to be reviewed
    before merging into `main`.

**Important distinction:** This is a learning pipeline. Its Build, Test,
and Deploy jobs print messages rather than compiling, testing, or
deploying a real application. In later labs, these commands can be
replaced with actual scripts or application build and test commands.
