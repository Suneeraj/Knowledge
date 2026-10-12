# A2: Secrets and “Spot the Leak”

**Duration:** 15 minutes. **Objective:** Distinguish configuration from secrets and respond safely to exposure.

## Scenario and activity

Review these proposed changes with a partner: a password committed to `.env`; `${{ secrets.APP_SECRET_KEY }}` used only by a smoke-test step; a token printed with `echo`; a secret passed as a Docker build argument; and `.env.example` containing an empty `SECRET_KEY`. Mark each SAFE, UNSAFE, or DEPENDS, and explain why.

## Verification and solution

Safe: scoped GitHub secret and empty example. Unsafe: committed password, printed token, and secret build argument (it can leak into history/metadata). If exposed: revoke or rotate first, remove it from the current tree and history as coordinated by the instructor, audit usage, then add prevention. Merely deleting the newest commit does not revoke a copied secret.

Common mistake: treating encoding as encryption. Extension: identify the minimum Actions permissions in CI and explain why least privilege matters.
