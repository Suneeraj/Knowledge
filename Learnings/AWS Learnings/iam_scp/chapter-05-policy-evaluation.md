# Chapter 5 — IAM Policy Evaluation

**Reading target:** 3 minutes

## Simple evaluation checklist
AWS authorization can involve several policy types. The exact evaluation depends on the principal and resource, but these rules are a useful beginner checklist:

1. Is the request authenticated?
2. Is there an applicable explicit Deny? If yes, deny.
3. Is there an applicable Allow?
4. Do applicable boundaries, SCPs, session policies, resource policies, and conditions permit the request?
5. If a required permission is missing, the request is commonly denied by default.

```text
Request
  |
Explicit Deny? -- yes --> DENY
  |
  no
Applicable Allow and required controls satisfied?
  | yes                    | no
 ALLOW                    DENY
```

**Important nuance:** Resource-based policies and role-session permissions have special evaluation rules. For interviews, explain the general principle and mention that the exact result depends on the principal, resource, and policy types.

## Key terms
- **Implicit deny:** No applicable Allow grants the requested action.
- **Explicit deny:** A matching `Effect: "Deny"` statement.
- **Condition:** Extra requirement such as source IP, MFA, region, or principal tag.
- **Resource ARN:** Unique identifier for an AWS resource.

## Lab 5 — Find the missing permission
1. Read this statement:
   ```json
   {
     "Effect": "Allow",
     "Action": "s3:GetObject",
     "Resource": "arn:aws:s3:::training-bucket/*"
   }
   ```
2. Ask: does this allow listing bucket contents? **No**; `s3:ListBucket` is a separate action on the bucket ARN.
3. Ask: does it allow reading objects in a different bucket? **No**.
4. Add this second statement to your notes only if listing is needed:
   ```json
   {
     "Effect": "Allow",
     "Action": "s3:ListBucket",
     "Resource": "arn:aws:s3:::training-bucket"
   }
   ```
5. Do not attach broad policies just to make an error disappear.

**Expected result:** You can diagnose a common `AccessDenied` caused by a missing action or incorrect resource ARN.

## Interview questions
1. What is implicit deny? **Answer:** No applicable Allow grants the action.
2. What does explicit Deny do? **Answer:** It blocks a matching request.
3. Are `s3:GetObject` and `s3:ListBucket` the same? **Answer:** No; they use different actions and resource ARN forms.

## Quiz
1. `s3:GetObject` normally targets: A) bucket ARN B) object ARN.
2. A matching explicit Deny exists. What is the result?

**Answer key:** 1-B. 2-Denied.
