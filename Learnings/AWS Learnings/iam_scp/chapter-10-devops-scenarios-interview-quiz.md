# Chapter 10 — DevOps Scenarios, Interview Questions and Final Quiz

**Reading target:** 5 minutes

## Scenario 1 — Lambda needs to read one S3 bucket
**Good approach:** Give the Lambda function an execution role. Its trust policy permits Lambda to assume the role; its permissions policy allows only the required S3 actions and resource ARNs. Do not hard-code access keys.

## Scenario 2 — GitHub Actions deploys Terraform
**Good approach:** Configure GitHub OIDC as an IAM identity provider, create a role with a restricted trust policy for the intended repository/branch, and attach narrowly scoped deployment permissions. Use temporary credentials. Protect the branch and workflow.

## Scenario 3 — Employee needs access to three AWS accounts
**Good approach:** Use IAM Identity Center. Assign the employee or group appropriate permission sets to the relevant accounts. Avoid sharing IAM user credentials.

## Scenario 4 — Developers can delete production resources
**Good approach:** Review IAM policies, role trust, resource policies, permissions boundaries, SCPs, and deployment controls. Consider a well-tested preventive guardrail and separate production access. Do not blindly attach an SCP without testing service dependencies.

## Scenario 5 — A vendor needs to call an AWS API
**Good approach:** First check whether the vendor supports federation, OIDC, role assumption, or IAM Roles Anywhere. If static access keys are truly required, use a dedicated IAM user, minimum permissions, secure secret storage, monitoring, and rotation. Never use a personal administrator key.

## Scenario 6 — `AccessDenied`
Check:
1. Which identity is active? `aws sts get-caller-identity`
2. Is the action allowed by the relevant policy?
3. Does the resource ARN match?
4. Is there an explicit Deny?
5. Do SCP, permissions boundary, session policy, resource policy, and conditions affect the request?
6. Is the request using the expected account and region?

## Interview questions with answers
1. **IAM role vs IAM user?** A role is assumed and normally uses temporary credentials; a user is a long-term IAM identity.
2. **Trust policy vs permissions policy?** Trust determines who can assume a role; permissions determine what the role can do.
3. **IAM policy vs SCP?** IAM policies grant/deny identity or resource actions; SCPs set the maximum available permissions in member accounts.
4. **Why avoid long-lived keys?** They can be copied or leaked and remain usable until disabled/rotated; temporary credentials reduce this risk.
5. **What is OIDC used for?** Federation, commonly allowing CI/CD workloads to assume roles without stored AWS keys.
6. **What does Identity Center do?** Centralizes workforce access to AWS accounts and applications.
7. **What is least privilege?** Only the permissions needed for a task.
8. **What is an explicit Deny?** A matching policy statement that blocks the request.
9. **What is an OU?** A group/container for AWS accounts in Organizations.
10. **What is Control Tower?** A service to help establish and govern a multi-account environment.

## Final quiz
1. An SCP is designed to: A) grant permissions B) limit maximum permissions C) store passwords.
2. A Lambda function usually gets AWS API permissions from: A) its execution role B) a key in source code.
3. A role trust policy says: A) who may assume the role B) which objects to delete.
4. `s3:GetObject` usually uses which resource type? A) object ARN B) bucket ARN only.
5. Best first choice for supported GitHub Actions authentication: A) OIDC role assumption B) long-lived IAM user keys.
6. IAM Identity Center uses ______ to define account access permissions.
7. An applicable explicit Deny generally overrides an applicable Allow. True/False?
8. What command shows the active AWS caller identity?
9. What is an OU?
10. If a vendor requires a static key, should you use your personal admin key? Yes/No.

## Answer key
1-B. 2-A. 3-A. 4-A. 5-A. 6-Permission set. 7-True. 8-`aws sts get-caller-identity`. 9-A logical grouping/container for AWS accounts. 10-No; use a dedicated identity with minimum permissions, secure storage, monitoring, and rotation only if no safer option is supported.

## Official documentation
- IAM policies: https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html
- SCPs: https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html
- IAM roles: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html
- IAM Identity Center: https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html
- GitHub Actions OIDC with AWS: https://docs.github.com/en/actions/how-tos/secure-your-work/security-harden-deployments/oidc-in-aws
- AWS STS: https://docs.aws.amazon.com/STS/latest/APIReference/welcome.html
- Control Tower: https://docs.aws.amazon.com/controltower/latest/userguide/what-is-control-tower.html
