# AWS IAM, SCPs, Organizations and Federation — 10-Chapter Beginner Workshop

**Audience:** Beginners learning AWS security for DevOps, Terraform, Lambda and CI/CD.  
**Format:** 10 short chapters, one small lab per chapter, interview questions, and quizzes with answer keys.  
**Target reading time:** About 30 minutes for the summaries and labs. The full notes are for later practice.

## 30-minute workshop route

| Time | Chapters | Focus |
|---|---|---|
| 0–5 min | 1–3 | SCP, IAM policies, Organizations and OUs |
| 5–10 min | 4–5 | Users, groups, roles, trust and permission evaluation |
| 10–15 min | 6–7 | External identity, federation and SSO |
| 15–25 min | 8 | Small, safe hands-on IAM labs |
| 25–28 min | 9 | Control Tower |
| 28–30 min | 10 | DevOps scenarios and recap |

You can read the chapter summaries in 30 minutes. Completing every console lab may take longer, depending on account access and permissions.

## Chapters

1. `chapter-01-scp-basics.md`
2. `chapter-02-iam-policy-vs-scp.md`
3. `chapter-03-organizations-and-ous.md`
4. `chapter-04-users-groups-roles-trust.md`
5. `chapter-05-policy-evaluation.md`
6. `chapter-06-identity-providers-and-federation.md`
7. `chapter-07-iam-identity-center-sso.md`
8. `chapter-08-hands-on-labs.md`
9. `chapter-09-control-tower.md`
10. `chapter-10-devops-scenarios-interview-quiz.md`

## One-page mental model

```text
Employee -> IAM Identity Center / SSO -> permission set -> role in AWS account
GitHub Actions -> OIDC token -> STS -> temporary role credentials -> AWS API
AWS Lambda -> execution role -> permissions policy -> AWS API
External service -> ideally federation/role assumption -> temporary credentials
                  -> access keys only if the service cannot use a safer method
SCP -> organization guardrail; limits maximum permissions in member accounts
```

## Essential terms

- **Principal:** The identity making a request: user, role, federated identity, or AWS service.
- **Authentication:** Proving who you are.
- **Authorization:** Checking what you are allowed to do.
- **IAM user:** An IAM identity that can have console credentials and/or access keys. Avoid creating one for every human when SSO is available.
- **IAM group:** A way to assign common permissions to IAM users. Groups cannot be assumed as roles.
- **IAM role:** An identity that is assumed and provides temporary credentials.
- **Trust policy:** A role policy that identifies who may assume the role.
- **Permissions policy:** A policy that defines allowed or denied actions.
- **SCP:** An AWS Organizations guardrail. It does not grant permissions.
- **STS:** AWS Security Token Service; issues temporary credentials.
- **Access key ID + secret access key:** A long-lived IAM user credential pair for programmatic access. The secret must not be shared.
- **OIDC:** A protocol commonly used by CI/CD tools to obtain temporary AWS credentials without storing AWS access keys.
- **SAML:** A federation standard often used for employee single sign-on.
- **IAM Identity Center:** AWS's central workforce access service for multiple AWS accounts and applications.
- **Permission set:** A collection of permissions and session settings used to provide access through IAM Identity Center.
- **Least privilege:** Grant only the permissions needed for the task.
- **Explicit deny:** A policy statement that blocks an action and takes precedence over an applicable allow.
- **MFA:** Multi-factor authentication; adds another proof of identity.

## Safety before labs

- Use a sandbox or approved non-production account.
- Never paste secrets into Git, README files, screenshots, or chat.
- Prefer temporary role credentials over long-lived access keys.
- Do not test SCPs in production or on the organization management account.
- Check the AWS account ID and region before creating resources.
- Delete test resources when finished, if created.
