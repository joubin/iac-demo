# How to work with this

## About

This project comes with everything you need in one place. It utilizes [terraform-compliance](https://github.com/terraform-compliance) and [cloudgoat](https://github.com/RhinoSecurityLabs/cloudgoat). It does contain some modifications to make it work. 

In order to emulate AWS, we use [localstack](https://localstack.cloud). 

## Running This

First you need to get the services up. Simply run:

`docker compose up --build -d`

This will take some time, but once completed, you will have your own working AWS system and a `development box` that you can use to do your work. 

To start interacting, run `docker exec -it iac-demo_dev_1 bash`. 

> if you renamed the folder, your base path may be different from `iac-demo`. 

Once in the `dev` container, we need to do a few things. 

`cd /app/scenarios/s3`

This directory holds a simplified version of one of CloudGoats frameworks. 

Once there, initialize your terraform

`terraform init`

To create your plan file, simply run

`terraform plan -out plan.json`

Now at this point, you *can* run: 

`terraform apply plan.json `

But we want to know if this is a safe thing to do.

`terraform-compliance -f git:https://github.com/terraform-compliance/user-friendly-features.git -S -p plan.json`

Which will provide this output:

```
root@613798c07389:/app/scenarios/s3# terraform-compliance -f git:https://github.com/terraform-compliance/user-friendly-features.git -S -p plan.json
terraform-compliance v1.3.22 initiated

Using remote git repository: https://github.com/terraform-compliance/user-friendly-features.git
. Converting terraform plan file.
🚩 Features     : /tmp/tmp7_x4ak58/ (https://github.com/terraform-compliance/user-friendly-features.git)
🚩 Plan File    : /app/scenarios/s3/plan.json.json
🚩 Suppressing output enabled.
Feature: S3 related general feature  # /tmp/tmp7_x4ak58/aws/S3.feature
    Implemented
    - Data must be encrypted at rest (what if it's suppose to be public?, maybe check if it's suppose to be public before? What if it's mistakenly set as public?)
    - Data stored in S3 has versioning enabled
    Questionable checks (only checks if one pass)
    - S3 must have access logging enabled

    Scenario: Data must be encrypted at rest
        Given I have aws_s3_bucket defined
        Then it must have server_side_encryption_configuration
          Failure: aws_s3_bucket.cg-cardholder-data-bucket (aws_s3_bucket) does not have server_side_encryption_configuration property.

    @noskip_at_line_20
    Scenario: S3 must have access logging enabled
        Given I have aws_s3_bucket defined
        When it has logging
          Failure: Can not find any logging property for aws_s3_bucket resource in terraform plan.

    Scenario: Data stored in S3 has versioning enabled
        Given I have aws_s3_bucket defined
        Then it must have versioning
        Then it must have enabled
        And its value must be true
          Failure: enabled property in aws_s3_bucket.cg-cardholder-data-bucket resource does not match with ^true$ case insensitive regex. It is set to False.

25 features (0 passed, 1 failed, 24 skipped)
62 scenarios (0 passed, 3 failed, 59 skipped)
222 steps (5 passed, 3 failed, 59 skipped)
Run 1626929278 finished within a moment
```