# Capstone: Hello World CI Pipeline

## Student project

Create a simple shell script that prints `Hello, world!`, then create a GitHub Actions workflow in YAML. The workflow should run when a pull request is opened and contain three basic jobs: Build, Test, and Deploy. Each job can print a short message. Make Test wait for Build and Deploy wait for Test.

This is a learning pipeline. The jobs demonstrate their order; they do not build or publish a real application.

## Rough steps

1. Create an empty GitHub repository named `my-first-pipeline`.
2. Clone it to your computer and create a feature branch.
3. Add a `hello.sh` script that prints `Hello, world!`.
4. Create `.github/workflows/ci.yaml`.
5. In the YAML file, give the workflow a name and set `pull_request` as its trigger.
6. Add `build`, `test`, and `deploy` jobs. Each job needs a runner and a step that prints a message.
7. Use `needs` to make the jobs run in order: Build, then Test, then Deploy.
8. Commit and push your branch, then open a pull request into `main`.
9. Look at the pull request's Checks or the repository's Actions tab to see the workflow run.

## Expected project structure

```text
my-first-pipeline/
├── README.md
├── hello.sh
└── .github/
    └── workflows/
        └── ci.yaml
```

## Push your work

Create the empty GitHub repository first. From your local project folder, connect it and push your branch (replace the placeholders):

```bash
git remote add origin https://github.com/YOUR-USERNAME/my-first-pipeline.git
git push -u origin feature/first-pipeline
```

Pushing sends your local branch to the GitHub repository; it does not create the remote repository. Create the pull request on GitHub after the push.

## Check your work

- `hello.sh` prints `Hello, world!`.
- The workflow is saved at `.github/workflows/ci.yaml`.
- The workflow starts for a pull request.
- The Build, Test, and Deploy jobs run in order.
- The pull request shows the workflow check.
