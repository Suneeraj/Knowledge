# Chapter 6 — Identity Providers and Federation

**Reading target:** 3 minutes

## What is federation?
Federation lets an identity from another system access AWS without creating a separate long-term IAM user for every person or workload.

- **Identity Provider (IdP):** System that authenticates an identity, such as Microsoft Entra ID, Okta, or GitHub's OIDC issuer.
- **SAML 2.0:** Commonly used for workforce single sign-on.
- **OIDC:** Commonly used by modern apps and CI/CD workflows.
- **STS:** Issues temporary AWS credentials after an approved role-assumption flow.
- **Federated role:** IAM role configured to trust a federated identity.

```text
GitHub Actions
    |
    | OIDC identity token
    v
AWS IAM OIDC provider + role trust policy
    |
    | STS validates and issues temporary credentials
    v
AWS role permissions -> permitted AWS API calls
```

## Lab 6 — Design a GitHub OIDC trust rule (no deployment required)
1. Write your repository in the format `ORG/REPO`.
2. Write the branch, for example `main`.
3. Review the key trust conditions:
   - audience: `sts.amazonaws.com`
   - subject: `repo:ORG/REPO:ref:refs/heads/main`
4. Explain why a specific repository and branch are safer than trusting every repository.
5. If you implement this in a sandbox, follow the official GitHub and AWS instructions, use a narrowly scoped role, and test with a harmless read-only action such as `sts:GetCallerIdentity`.

**Expected result:** You understand that the trust policy controls which external workload can assume the role.

## Example trust-policy condition (illustrative)
```json
"Condition": {
  "StringEquals": {
    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com",
    "token.actions.githubusercontent.com:sub": "repo:YOUR_ORG/YOUR_REPO:ref:refs/heads/main"
  }
}
```
This fragment is not a complete role trust policy. Replace the placeholders and follow the current official setup instructions.

## Interview questions
1. Why use OIDC for CI/CD? **Answer:** It can replace stored long-lived AWS access keys with short-lived credentials.
2. What does a trust policy control? **Answer:** Who may assume the role.
3. Is an OIDC token the same as AWS access keys? **Answer:** No; it is an identity token used in a federation flow.

## Quiz
1. OIDC is useful for: A) CI/CD federation B) storing passwords in source code.
2. A broad trust condition is usually: A) safer B) riskier.

**Answer key:** 1-A. 2-B.
