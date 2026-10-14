# Chapter 3 — AWS Organizations and OUs

**Reading target:** 2 minutes

## What is AWS Organizations?
It helps a company manage multiple AWS accounts and apply policies centrally.

- **Management account:** Owns and manages the organization; SCPs do not restrict this account.
- **Member account:** An account inside the organization.
- **Root:** The top of the organization hierarchy; not the same thing as the account's root user.
- **OU (organizational unit):** A container for accounts or other OUs.
- **Policy inheritance:** SCPs attached higher in the hierarchy can affect child OUs/accounts.

```text
Organization
├── Management account
└── Root
    ├── Production OU [SCP: restrict risky actions]
    │   ├── Prod account A
    │   └── Prod account B
    └── Development OU [SCP: approved regions]
        └── Dev account C
```

## Lab 3 — Draw a small organization
1. In a notebook, draw one organization root.
2. Add `Production` and `Development` OUs.
3. Put two fictional production accounts in Production and one dev account in Development.
4. Add a note: “Production OU: tighter guardrails.”
5. If you have an authorized sandbox organization, view **AWS Organizations → AWS accounts** and compare it with your drawing. Do not move accounts or change policies.

**Expected result:** You can explain why teams separate production and development accounts.

## Interview questions
1. Why use multiple AWS accounts? **Answer:** Isolation, security boundaries, billing separation, and different environments.
2. What is an OU? **Answer:** A logical grouping of accounts.
3. Do SCPs grant permissions? **Answer:** No.

## Quiz
1. Which is an account grouping? A) OU B) Access key C) Lambda.
2. Are SCPs applied to the management account? **Answer:** No.

**Answer key:** 1-A. 2-No.
