# Chapter 4 — IAM Users, Groups, Roles and Trust Policies

**Reading target:** 3 minutes

## The four concepts
- **User:** A long-term IAM identity. It can have console access and/or access keys.
- **Group:** Collects IAM users so common permissions can be assigned together. Groups cannot be assumed.
- **Role:** An identity assumed by a user, AWS service, or federated workload. It supplies temporary credentials.
- **Trust policy:** Defines who may assume a role.
- **Permissions policy:** Defines what the role can do after it is assumed.

```text
Who may use the role?             What may the role do?
Trust policy                      Permissions policy
      |                                  |
User / Lambda / GitHub  --->  IAM role  ---> S3 / EC2 / DynamoDB
                                  |
                         temporary credentials
```

## Example: Lambda
A Lambda function needs to read an S3 object. Attach an execution role to the function. The trust policy allows the Lambda service (`lambda.amazonaws.com`) to assume the role. A permissions policy allows the required S3 read action.

## Lab 4 — Create a role on paper
1. Open a text editor.
2. Copy the trust-policy idea below. It is a teaching example, not a complete deployment file:
   ```json
   {
     "Version": "2012-10-17",
     "Statement": [{
       "Effect": "Allow",
       "Principal": {"Service": "lambda.amazonaws.com"},
       "Action": "sts:AssumeRole"
     }]
   }
   ```
3. Explain it in plain English: “The Lambda service may assume this role.”
4. Write a separate permissions policy that grants only the S3 read operation needed for one specific bucket/object.
5. Keep the trust policy and permissions policy in separate sections.

**Expected result:** You can explain why trust and permissions are two different questions.

## Interview questions
1. What is the difference between trust and permissions policy? **Answer:** Trust says who can assume the role; permissions say what the role can do.
2. Can a group be assumed? **Answer:** No.
3. Why use a role for Lambda? **Answer:** The function gets temporary credentials without storing access keys in code.

## Quiz
1. A role trust policy answers: A) Who can assume? B) Which S3 objects can be read?
2. A Lambda function should usually use: A) hard-coded keys B) execution role.

**Answer key:** 1-A. 2-B.
