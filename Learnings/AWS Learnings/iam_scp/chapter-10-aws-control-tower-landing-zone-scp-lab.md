# Lesson: AWS Control Tower, Landing Zones, SCPs, and Account Isolation

> **Goal:** Explore how AWS Control Tower helps organize multiple AWS
> accounts, how Service Control Policies (SCPs) work, and how to keep
> two teams isolated.
>
> **Level:** Beginner\
> **Estimated time:** 30--45 minutes\
> **Mode:** Console exploration and optional hands-on lab\
> **Important:** Use a sandbox AWS account or an organization where you
> are authorized to make changes. Do not attach restrictive SCPs to a
> production organization while learning.

------------------------------------------------------------------------

## 1. What you will learn

By the end of this lesson, you should be able to explain:

-   What an AWS Landing Zone is and what AWS Control Tower does.
-   The difference between the Organization Root, management account,
    OU, and member account.
-   Why organizations use Security, Infrastructure, and Workloads OUs.
-   Where SCPs can be attached and what they do.
-   How IAM permissions, SCPs, resource policies, and network controls
    work together.
-   How to design basic isolation between Team A and Team B.

## 2. Key terms

  -----------------------------------------------------------------------
  Term                                Simple meaning
  ----------------------------------- -----------------------------------
  **Landing Zone**                    A governed AWS environment with an
                                      account structure, security
                                      controls, identity, logging, and
                                      networking standards.

  **AWS Control Tower**               An AWS service that helps set up
                                      and govern a multi-account
                                      environment.

  **AWS Organizations**               The service that centrally groups
                                      and manages AWS accounts.

  **Organization Root**               The top-level container in AWS
                                      Organizations. It is **not** an AWS
                                      account and has no login
                                      credentials.

  **Management account**              The AWS account that owns and
                                      administers the organization. It is
                                      directly under the Organization
                                      Root, not inside an OU.

  **Member account**                  A separate AWS account that belongs
                                      to the organization. Each account
                                      has its own account ID and root
                                      user.

  **OU (Organizational Unit)**        A container for organizing accounts
                                      and attaching policies to groups of
                                      accounts. An OU is not an account.

  **SCP (Service Control Policy)**    An organization policy that sets
                                      the maximum permissions available
                                      to principals in member accounts.
                                      It does not grant permissions.

  **IAM policy / role**               Controls what an identity can do
                                      and can provide an authorized way
                                      to access another account.

  **Cross-account access**            Access from one AWS account to
                                      resources in another, configured
                                      using IAM roles, trust policies,
                                      resource policies, and permissions.
  -----------------------------------------------------------------------


## 2A. Important doubts: Is a Landing Zone a physical AWS resource?

**Short answer: No. A Landing Zone is not one separate resource like an OU or an AWS account.** It is the overall governed setup of your multi-account AWS environment.

Think of it this way:

- **Landing Zone:** the complete governed AWS environment and its standards.
- **AWS Organizations:** the service that holds the account hierarchy.
- **Organization Root:** the top-level container in that hierarchy.
- **OU:** a container for grouping accounts and applying policies.
- **AWS account:** an actual AWS account with its own account ID.
- **AWS Control Tower:** the service that helps set up and govern the Landing Zone.

### Can I physically create a Landing Zone?

You do not create a single resource named “Landing Zone” in the same way you create an OU. Instead, you **configure the environment that makes up the Landing Zone**. Its underlying components are real AWS resources and settings: the organization and accounts, OUs, preventive and detective controls, logging configuration, identity integration, and other governance choices.

Control Tower automates much of this setup, but a Landing Zone is the overall result—not another OU and not just a name for one account.

### Is Control Tower only used to create a Landing Zone?

No. Control Tower helps you:

1. Set up and manage a governed multi-account environment (the Landing Zone).
2. Apply and manage preventive and detective controls.
3. Provision accounts through Account Factory.
4. Integrate with centralized logging and audit/security accounts, depending on the Landing Zone configuration.
5. Detect certain forms of configuration drift and help you manage governance.

AWS Organizations, meanwhile, provides the underlying account and OU hierarchy and supports organization policies such as SCPs. You can use AWS Organizations without Control Tower, but Control Tower provides an opinionated, more automated governance setup.

### Is a Landing Zone the same as an OU?

No.

| Question | Landing Zone | OU |
|---|---|---|
| What is it? | The overall governed multi-account environment | A container in AWS Organizations |
| Is it one AWS account? | No | No |
| Does it have its own account ID? | No | No |
| Can it contain multiple OUs and accounts? | Yes; the environment includes them | It groups accounts and can contain child OUs |
| Can an SCP attach directly to it as a “Landing Zone” object? | No; SCPs attach to the organization root, OUs, or member accounts | Yes |
| How is it created? | Set up/configure the environment; Control Tower can automate much of it | Create an OU in AWS Organizations or through supported Control Tower workflows |

### Analogy

Imagine a company campus:

- The **Landing Zone** is the entire campus plus its security rules and operating standards.
- **AWS Organizations** is the company-wide structure used to organize its AWS accounts.
- An **OU** is like a department or building group.
- An **AWS account** is like a separate workspace.
- **Control Tower** is the setup and governance service that helps establish and maintain the campus rules.

This analogy is not exact, but it helps explain why a Landing Zone is broader than an OU.

### What you will see in the lab

You will create or configure actual AWS components—an organization, OUs, member accounts, and an SCP. If you use Control Tower, it will help set up and govern the Landing Zone. You will **not** create a separate OU called “Landing Zone” or an individual resource with that name.

> **Cost and safety:** Setting up Control Tower and its supporting resources can incur charges. Use a sandbox and review current AWS pricing before starting. Do not alter Control Tower-managed policies or controls for this learning exercise.

---

## 3. Example architecture

Imagine a company has two teams. Each team needs Dev, Test, Stage, and
Prod accounts.

``` text
AWS Organization
└── Organization Root (container, not an account)
    ├── Management account
    │   └── Administers AWS Organizations and Control Tower
    ├── Security OU
    │   ├── Log Archive account
    │   └── Audit / Security account
    ├── Infrastructure OU
    │   ├── Network account
    │   └── Shared Services account
    └── Workloads OU
        ├── Team A OU
        │   ├── Team-A-Dev account
        │   ├── Team-A-Test account
        │   ├── Team-A-Stage account
        │   └── Team-A-Prod account
        └── Team B OU
            ├── Team-B-Dev account
            ├── Team-B-Test account
            ├── Team-B-Stage account
            └── Team-B-Prod account
```

The account names above are examples. Account IDs are not shown because
real account IDs must come from your AWS environment.

### Why these OUs?

-   **Security OU:** Holds dedicated accounts for audit, centralized
    logs, and security operations. Control Tower commonly sets up Log
    Archive and Audit accounts as part of its landing-zone setup.
-   **Infrastructure OU:** Holds accounts for shared services, such as
    central networking or internal tools, if the organization needs
    them.
-   **Workloads OU:** Holds application accounts used by teams.
-   **Team A and Team B OUs:** Keep team account groupings separate so
    team-specific governance can be applied.
-   **Prod controls:** Production-specific SCPs can be attached to a
    dedicated Prod OU, or directly to production accounts. Choose a
    hierarchy that fits your governance needs.

An empty OU is allowed, but it does not itself provide security or
visibility. A security or infrastructure OU only has a purpose when the
organization configures the relevant accounts, services, policies, and
permissions.

### Account count example

-   1 management account
-   2 security accounts
-   2 infrastructure accounts
-   8 workload accounts
-   **Total: 13 AWS accounts**

The Organization Root and OUs are containers, so they are not included
in the account count. A simpler learning setup can use just a management
account and a few sandbox member accounts.

## 4. What visibility means

Visibility is not the same as permission to access or change resources.

  -----------------------------------------------------------------------
  Identity / account                  Typical visibility or access
  ----------------------------------- -----------------------------------
  Management account                  Can view organization account
                                      inventory and administer
                                      organization-level settings. It
                                      does not automatically have
                                      unrestricted access to every
                                      workload resource.

  Security account                    Can receive centralized findings
                                      and logs when services and
                                      permissions are configured. It may
                                      use authorized roles for
                                      investigation.

  Infrastructure account              Can manage shared services to which
                                      it has been granted access. It does
                                      not automatically see every
                                      application resource.

  Team A developer                    Should receive access only to
                                      approved Team A accounts and
                                      resources.

  Team B developer                    Should receive access only to
                                      approved Team B accounts and
                                      resources.
  -----------------------------------------------------------------------

For example, the management account may see that a Team-A-Prod account
exists. That does not automatically let it read every S3 object or
modify every Lambda function in that account.

Useful services may include AWS CloudTrail, AWS Config, AWS Security
Hub, and Amazon GuardDuty. They need appropriate setup, delegated
administration, and permissions.

## 5. Where SCPs attach

SCPs are managed through AWS Organizations. They can be attached to:

-   The **Organization Root** --- common guardrails for member accounts
    across the organization.
-   An **OU** --- guardrails for accounts in that OU and its child OUs.
-   An individual **member account** --- guardrails for that account.

Example policy placement:

``` text
Organization Root
└── Common SCP: approved Regions / common restrictions
    ├── Security OU
    ├── Infrastructure OU
    └── Workloads OU
        ├── Team A OU
        │   └── Team A-specific SCP
        └── Team B OU
            └── Team B-specific SCP

Prod-specific SCP:
Attach to a Prod OU, or directly to the relevant Prod accounts.
```

**Important SCP rules:**

1.  An SCP does not grant permissions. IAM must also allow the action.
2.  An explicit SCP `Deny` blocks the action for affected member-account
    principals, even if IAM allows it.
3.  SCPs do not restrict principals in the management account.
4.  SCPs can restrict member-account root users.
5.  A policy's effective result depends on all applicable SCPs in the
    hierarchy and the relevant IAM/resource policies.
6.  Be careful with allow-list SCPs and broad denies. They can lock out
    required services or administrators.

## 6. SCP example A: Prevent member accounts from leaving the organization

**Purpose:** Demonstrate an organization-level guardrail.

Attach this example SCP to the Organization Root in a suitable sandbox
organization:

``` json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PreventMemberAccountsLeavingOrganization",
      "Effect": "Deny",
      "Action": "organizations:LeaveOrganization",
      "Resource": "*"
    }
  ]
}
```

**Expected result:** A principal in a member account cannot use this
action to leave the organization. SCPs do not restrict the management
account.

This example is for learning. Verify the policy and its impact against
current AWS documentation before using it in a real organization.

## 7. SCP example B: Block EC2 termination in production

**Purpose:** Show how a production guardrail can block a destructive
action.

Attach this to a dedicated Prod OU or to the production member accounts
in a sandbox:

``` json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BlockEc2TerminationForTraining",
      "Effect": "Deny",
      "Action": "ec2:TerminateInstances",
      "Resource": "*"
    }
  ]
}
```

**Expected result:** The SCP blocks EC2 instance termination in affected
member accounts, even when an IAM policy allows it.

**Caution:** This blocks legitimate termination too. Do not use it in
production without an approved operational design and testing. An SCP is
not a replacement for backups, change management, or least-privilege
IAM.

## 8. How to isolate Team A and Team B

Use multiple layers. Do not rely on OU names or SCPs alone.

### Layer 1 --- Separate accounts

Team A has its own four accounts. Team B has its own four accounts.
Separate accounts provide strong administrative and resource boundaries.

### Layer 2 --- Identity and access

Use IAM Identity Center permission sets or another approved identity
system to assign:

-   Team A developers to Team A Dev/Test, and only other Team A accounts
    when needed.
-   Team B developers to Team B Dev/Test, and only other Team B accounts
    when needed.
-   Production access only to authorized release or operations roles.
-   Security staff access based on their investigation duties.

### Layer 3 --- Cross-account IAM roles

Do not create trust relationships from Team A identities into Team B
accounts unless specifically approved. A cross-account role should have
a narrow trust policy and least-privilege permissions.

### Layer 4 --- Resource policies

Review S3 bucket policies, KMS key policies, SQS/SNS policies, and other
resource policies. Do not grant the other team access unless required.

### Layer 5 --- SCP guardrails

Use SCPs to prevent prohibited actions, such as disabling required
controls or using unapproved Regions. Remember that SCPs set permission
boundaries; they do not grant access.

### Layer 6 --- Network separation

Use VPCs, route tables, security groups, network ACLs, and appropriate
network architecture to control connectivity. Separate AWS accounts do
not automatically mean that no network path exists if the organization
has configured shared connectivity.

## 9. Lab: Explore Control Tower and SCPs

### Safety and cost checklist

-   Use a sandbox or an organization where you are authorized to
    experiment.
-   **Do not enable Control Tower or create accounts in a work
    organization without approval.**
-   AWS Control Tower setup and related resources can incur charges,
    depending on the services used and resources deployed.
-   Creating accounts may require unique email addresses and may affect
    billing.
-   Do not test destructive actions on production resources.
-   Before changing or detaching an SCP, understand the existing
    policies and access paths.

### Lab A --- Explore the organization (read-only)

1.  Sign in to the authorized AWS management account.
2.  Open the [AWS Organizations
    console](https://console.aws.amazon.com/organizations/).
3.  Find **AWS accounts** and inspect the Organization Root, OUs, and
    member accounts.
4.  Identify which account is the management account.
5.  Note which accounts are under each OU.
6.  Open the [AWS Control Tower
    console](https://console.aws.amazon.com/controltower/) and review
    the landing-zone and OU/account information available to your role.
7.  Do not change settings during this read-only step.

**Record your findings:**

-   How many member accounts are present?
-   Which OUs exist?
-   Which accounts are used for security, infrastructure, and workloads?
-   Which controls are enabled?

### Lab B --- Inspect an SCP (read-only)

1.  Open AWS Organizations.
2.  Navigate to **Policies** and **Service control policies**.
3.  Review existing policies and where they are attached.
4.  Read the statements and identify `Effect`, `Action`, and `Resource`.
5.  Check which accounts or OUs inherit each policy.
6.  Do not edit or attach policies unless you are in an approved sandbox
    and understand the impact.

### Lab C --- Optional controlled SCP test

Only perform this in a dedicated sandbox organization with a test member
account and administrator access.

1.  Create a test OU or use an existing sandbox OU.
2.  Place a disposable test member account in that OU.
3.  Record the current SCP attachments and ensure you have a recovery
    plan.
4.  Attach a narrowly scoped training SCP that denies one
    harmless-to-test API action you can safely verify, or use the EC2
    termination example only after confirming there are no important
    instances and that the test is authorized.
5.  Test the action using a test role whose IAM policy allows it.
6.  Observe that the SCP deny blocks the action.
7.  Remove the test SCP and verify the expected permissions are
    restored.
8.  Check CloudTrail or the relevant service response for evidence of
    the denied request.

Do not use a production account for this lab. Avoid changing the
Organization Root policy during initial experiments.

## 10. Troubleshooting questions

**IAM allows an action, but AWS denies it. Why?**

An SCP may deny the action, another IAM/resource policy may restrict it,
or the caller may lack a required permission. Check the exact error and
effective policies.

**Does an SCP grant Team A access to Team A Dev?**

No. Access must be granted through IAM Identity Center permission sets,
IAM policies/roles, and any relevant resource policies.

**Can the management account see all application data automatically?**

No. Organization inventory is not unrestricted resource access. Resource
access requires appropriate permissions.

**Does creating a Security OU automatically enable security
monitoring?**

No. You must configure the accounts, security services, delegated
administration, logging, and permissions.

**Can Team A access Team B just because both are in the same
organization?**

Not automatically. Access depends on identity permissions, cross-account
trust, resource policies, and network configuration.

## 11. Quick quiz

1.  Is the Organization Root an AWS account?
2.  Does an OU have its own AWS account ID?
3.  Where can an SCP be attached?
4.  Does an SCP grant permissions?
5.  What happens when an applicable SCP explicitly denies an action that
    IAM allows?
6.  Does the management account automatically have permission to read
    every S3 object in member accounts?
7.  Name two controls, other than SCPs, that help isolate Team A and
    Team B.
8.  Why should production SCPs be tested carefully?

### Answer key

1.  No. It is the top-level organizational container.
2.  No. An OU is a container, not an account.
3.  The Organization Root, an OU, or a member account.
4.  No. It defines the maximum available permissions for principals in
    member accounts.
5.  The action is denied.
6.  No. Appropriate resource permissions or an authorized access path
    are still required.
7.  Examples: IAM Identity Center permission sets, IAM role trust
    policies, S3/KMS resource policies, and network controls.
8.  A restrictive SCP can block legitimate operations or interrupt
    production workflows.

## 12. Official documentation

-   [AWS Control Tower User
    Guide](https://docs.aws.amazon.com/controltower/latest/userguide/)
-   [AWS Organizations User
    Guide](https://docs.aws.amazon.com/organizations/latest/userguide/)
-   [Service control policies
    (SCPs)](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_policies_scps.html)
-   [AWS Control Tower controls
    reference](https://docs.aws.amazon.com/controltower/latest/controlreference/)

------------------------------------------------------------------------

**Lesson summary:** Control Tower helps establish and govern a
multi-account landing zone. OUs organize accounts. SCPs set permission
boundaries for member accounts. IAM, resource policies, and network
controls provide the actual access rules needed to isolate teams.
