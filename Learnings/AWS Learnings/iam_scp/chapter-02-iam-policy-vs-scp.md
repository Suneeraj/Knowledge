# Chapter 2 — IAM Policy vs SCP

**Reading target:** 2 minutes

## The difference
- **IAM policy:** Says what an identity or resource may do.
- **SCP:** Sets the maximum permissions available to identities in affected member accounts.
- **Neither an SCP Allow nor an IAM Allow automatically overrides an applicable explicit Deny.**

```text
IAM policy says:   "This role may call s3:ListBucket"
SCP says:          "S3 listing is not denied by organization guardrails"
Other checks:      resource policy, boundary, session policy, conditions
Result:            allowed only if the applicable authorization checks pass
```

## Key terms
- **Identity-based policy:** Attached to a user, group, or role.
- **Resource-based policy:** Attached to a resource, such as an S3 bucket.
- **Permissions boundary:** Sets the maximum permissions an identity-based policy can grant to a user or role.
- **Session policy:** Further limits permissions for a role session.

## Lab 2 — Compare policy statements
1. Open a local text editor; no AWS changes are needed.
2. Read the sample IAM policy:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [{
       "Effect": "Allow",
       "Action": "s3:ListBucket",
       "Resource": "arn:aws:s3:::example-bucket"
     }]
   }
   ```
3. Explain: this IAM policy allows listing the named bucket, but it does not grant access to every bucket.
4. Now imagine an applicable SCP explicitly denies `s3:ListBucket`. The request is denied.
5. Change `Action` in your notes to `s3:GetObject`. What is different? `GetObject` applies to object ARNs, not the bucket ARN.

**Expected result:** You can describe the job of IAM and SCP separately.

## Interview questions
1. What grants permissions to an IAM role? **Answer:** Its applicable permissions policies, subject to other authorization controls.
2. Can an SCP grant S3 access? **Answer:** No.
3. What does least privilege mean? **Answer:** Give only the permissions needed.

## Quiz
1. IAM policy is mainly about: A) identity/resource permissions B) account billing only.
2. An SCP explicitly denies an action while IAM allows it. What happens?

**Answer key:** 1-A. 2-The action is denied in an affected member account.
