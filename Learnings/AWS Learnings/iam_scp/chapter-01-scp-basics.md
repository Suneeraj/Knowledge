# Chapter 1 — SCP Basics

**Reading target:** 2 minutes

## What is an SCP?
A **Service Control Policy (SCP)** is an AWS Organizations guardrail. It limits the maximum permissions available to IAM identities in affected member accounts. An SCP **does not grant permission** by itself.

```text
Organization / OU
      |
     SCP  <- maximum permission boundary for member accounts
      |
  Member account
      |
 IAM policy + resource policy + other checks
      |
   AWS action
```

## Key terms
- **AWS Organizations:** Manages multiple AWS accounts centrally.
- **Guardrail:** A rule that prevents actions outside an approved boundary.
- **Allow-list approach:** Allow only selected services/actions, rather than allowing everything.
- **Explicit Deny:** A direct block. It overrides an applicable Allow.

## Simple example
A company wants member accounts to use AWS only in `eu-west-2` (London). An SCP can deny actions outside that region, with carefully considered exceptions for global services. Region restrictions require testing because some AWS services are global or use supporting calls in other regions.

## Lab 1 — Inspect SCPs (read-only)
1. Sign in to the AWS Organizations **management account** with an authorized admin identity.
2. Open **AWS Organizations → Policies → Service control policies**.
3. Select an SCP and read its JSON. Do not attach or detach anything for this beginner lab.
4. Identify `Effect`, `Action`, and `Resource` in one statement.
5. Write one sentence describing what the policy blocks or permits.

**Expected result:** You can locate an SCP and explain its purpose. If you do not have an organization, read the JSON example below instead.

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Deny",
    "Action": "s3:DeleteBucket",
    "Resource": "*"
  }]
}
```

This example denies bucket deletion in accounts to which the SCP applies, even if an IAM policy allows it. Do not use this as a production-ready policy without checking the organization's requirements.

## Interview questions
1. Does an SCP grant access? **Answer:** No; it sets the maximum available permissions.
2. What usually wins: an applicable explicit Deny or Allow? **Answer:** Explicit Deny.
3. Does an SCP restrict the AWS Organizations management account? **Answer:** SCPs do not restrict the management account.

## Quiz
1. SCP is mainly a: A) credential B) guardrail C) database
2. True/False: An SCP Allow alone lets a user delete an S3 bucket.

**Answer key:** 1-B. 2-False; an applicable IAM/resource permission must also allow the action.
