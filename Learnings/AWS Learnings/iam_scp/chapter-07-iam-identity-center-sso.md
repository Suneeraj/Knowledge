# Chapter 7 — IAM Identity Center (SSO)

**Reading target:** 3 minutes

## What is IAM Identity Center?
It is AWS's central workforce access service. It can use its built-in identity source or an external identity provider. Administrators assign people or groups access to AWS accounts through **permission sets**.

- **SSO:** One sign-in can provide access to multiple approved accounts/apps.
- **Permission set:** A named collection of permissions and session settings.
- **Account assignment:** Connects a user/group and permission set to an AWS account.
- **External IdP:** A company identity system, such as Microsoft Entra ID or Okta.
- **Provisioned role:** Identity Center creates/uses roles in target accounts for assigned access.

```text
Employee
   |
Identity Center sign-in (optionally external IdP)
   |
User / group assignment + permission set
   |
AWS account -> role session -> permitted actions
```

## Lab 7 — Plan an SSO assignment
1. Make a table with two groups: `Developers` and `ReadOnlyAuditors`.
2. Assign Developers a narrowly scoped developer permission set in a sandbox account.
3. Assign ReadOnlyAuditors a read-only permission set.
4. Record which account each group can access.
5. If you have admin access, inspect **IAM Identity Center → Multi-account permissions** and review permission sets/assignments. Do not grant broad production access during the exercise.

**Expected result:** You can explain how a group receives access to an AWS account through a permission set.

## Workforce SSO vs workload federation
- **Employee:** Usually Identity Center and a permission set.
- **GitHub Actions:** Often OIDC federation to an IAM role.
- **Lambda:** Usually an execution role.
- **External SaaS integration:** Prefer a supported federation or role-assumption method; use access keys only when necessary.

## Interview questions
1. What is a permission set? **Answer:** A reusable definition of account permissions and session settings.
2. Why use Identity Center? **Answer:** Centralized workforce access across accounts.
3. Does SSO mean every employee is an administrator? **Answer:** No; access is assigned according to least privilege.

## Quiz
1. Permission sets are used by: A) IAM Identity Center B) S3 lifecycle rules.
2. A read-only audit team should normally receive: A) AdministratorAccess B) read-only permissions.

**Answer key:** 1-A. 2-B.
