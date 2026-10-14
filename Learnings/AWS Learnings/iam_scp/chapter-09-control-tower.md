# Chapter 9 — AWS Control Tower

**Reading target:** 2 minutes

## What is Control Tower?
AWS Control Tower helps set up and govern a multi-account AWS environment using recommended baseline configurations and guardrails.

- **Landing zone:** The foundational multi-account environment.
- **Account Factory:** A controlled way to provision accounts in a governed environment.
- **Guardrail:** A preventive or detective control that helps maintain a policy.
- **Preventive control:** Helps block an action.
- **Detective control:** Detects a configuration or activity that violates a rule.
- **AWS Organizations:** Underlies account organization and SCP use.

```text
AWS Control Tower
       |
   Landing zone
       |
  AWS Organizations
  ├── Log archive account
  ├── Audit/security account
  └── Workload accounts
       |
  Guardrails + monitoring
```

Names and available features can vary by setup and service updates; follow the current console and documentation for your environment.

## Lab 9 — Recognize controls (read-only)
1. If your organization uses Control Tower, open its console with approved read-only access.
2. Locate the landing zone and the list of controls/guardrails.
3. Pick one preventive control and one detective control.
4. Write what each is intended to prevent or detect.
5. If your account does not use Control Tower, compare the concepts in this chapter; do not create a landing zone just for a beginner exercise.

**Expected result:** You can explain how Control Tower relates to Organizations and guardrails.

## Interview questions
1. What problem does Control Tower solve? **Answer:** Helps establish and govern a multi-account environment.
2. How is a preventive control different from a detective control? **Answer:** One blocks/prevents; the other detects/reporting issues.
3. Is Control Tower the same as IAM? **Answer:** No; it helps govern a multi-account environment and uses other AWS services.

## Quiz
1. Account Factory is associated with: A) Control Tower B) IAM access keys.
2. A detective control mainly: A) reports/detects issues B) grants administrator access.

**Answer key:** 1-A. 2-A.
