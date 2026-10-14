# Chapter 8 — Hands-on IAM Labs

**Reading target:** 3 minutes

This chapter gives one short practical lab that combines least privilege, role credentials, and access-key safety. Other chapters also have their own labs.

## Access keys: users vs roles

An IAM user's access key is a long-lived credential pair:
- **Access key ID:** Identifier; not the secret by itself.
- **Secret access key:** Secret used to sign requests.
- **Session token:** Also required when using temporary STS credentials.

**Prefer this order:**
1. AWS service running in AWS (Lambda, EC2, ECS): use an IAM role.
2. GitHub Actions or supported external workload: use OIDC federation / role assumption.
3. Human access: use IAM Identity Center / SSO.
4. Only if an external integration cannot use a safer option: consider a dedicated IAM user access key with the minimum permissions, rotation, monitoring, and secure storage.

Do not create access keys for a Lambda function or commit keys into a repository. Do not put secrets in command-line history, logs, README files, or screenshots.

## Lab 8 — Inspect the AWS caller identity safely
This lab uses whichever credentials are already configured. It does not create a user or key.

1. Open AWS CloudShell in a sandbox account, or use an approved terminal with AWS CLI already configured.
2. Run:
   ```bash
   aws sts get-caller-identity
   ```
3. Read the `Account`, `Arn`, and `UserId` fields.
4. If the ARN includes `assumed-role/`, you are using a role session. If it includes `user/`, you may be using an IAM user.
5. Do not paste the full output into a public issue if it exposes internal account details.

**Expected result:** You can identify which AWS identity your CLI is using.

## Optional external-service access-key pattern (conceptual only)
If a third-party service absolutely requires a static key:
1. Create a dedicated IAM user only for that integration.
2. Attach a narrow policy for only the required actions and resources.
3. Create one access key using the approved process.
4. Put the key in the service's secret manager (not source code).
5. Restrict who can read the secret; enable monitoring and a rotation plan.
6. Test with the smallest possible action; review CloudTrail.
7. Rotate the key and deactivate/delete it when no longer needed.

```text
External service -> secret manager -> IAM access key -> AWS API
                         |
                 access limited to
                 dedicated IAM user policy
```

This is a fallback pattern, not the preferred design. Where supported, use OIDC, IAM Roles Anywhere, or another federation/role-assumption method instead. Never share keys between applications.

## Interview questions
1. What is safer for Lambda: access keys or execution role? **Answer:** Execution role.
2. Where should a required third-party secret be stored? **Answer:** A dedicated secret manager with access controls, not code.
3. What does `aws sts get-caller-identity` do? **Answer:** Shows the identity for the active credentials.

## Quiz
1. True/False: It is safe to commit access keys to Git if the repo is private.
2. Preferred CI/CD credential pattern: A) OIDC role assumption B) permanent user keys in YAML.

**Answer key:** 1-False. 2-A.
