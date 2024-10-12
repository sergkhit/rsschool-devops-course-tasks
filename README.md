Project: rolling-scopes-school. 

Task 2: Basic Infrastructure Configuration

https://github.com/rolling-scopes-school/tasks/blob/master/devops/modules/1_basic-configuration/task_2.md

============================================================


Project file Structure.

README.md:    This file.

screenshots/: directory contains resources and works screenshots.

.github/workflows/terrform.yaml: GitHub-specific files,  workflows for GitHub Actions

.gitignore:   file specifies which folders or files should be ignored when tracking changes with Git.

backend.tf:   file contains the S3 resource declarations for terraform backend.

bastion_host.tf: file contains the resource declarations for bastion.

iam.tf:      file contains the IAM resource declarations.

instance.tf: file contains the resource declarations all instances in public and private networks

network_security.tf: file contains the resource declarations security groups and ssh keys

network.tf: file contains the resource declarations for VPC, networks, IGW, NAT and route tables

outputs.tf:  file contains the output definitions for the Terraform resources.

root.tf : main configuration file the core infrastructure and providers.

variables.tf: file defines input variables for Terraform configuration.


===========================================================

## Use Instructions

Set Up AWS Credentials In your GitHub repository settings, add the following secrets:
ACTION_ROLE_ARN: ARN of an AWS IAM role with necessary permissions Follow Creating GitHub OIDC for AWS
Customize Variables Modify variables.tf to set your preferred project name and environment. 

Run CI / CD The plan workflow will run automatically on pull requests to the main branch, and on merged PRs to main.


===========================================================

Evaluation Criteria (100 points for covering all criteria)

------------------------------

Terraform Code Implementation (50 points)

Terraform code is created to configure the following:

    VPC
    2 public subnets in different AZs
    2 private subnets in different AZs
    Internet Gateway
    Routing configuration:
        Instances in all subnets can reach each other
        Instances in public subnets can reach addresses outside VPC and vice-versa

------------------------------

Code Organization (10 points)

Variables are defined in a separate variables file.
Resources are separated into different files for better organization.

------------------------------

Verification (10 points)

Terraform plan is executed successfully.
A resource map screenshot is provided (VPC -> Your VPCs -> your_VPC_name -> Resource map).

------------------------------

Additional Tasks (30 points)

Security Groups and Network ACLs (5 points)
    Implement security groups and network ACLs for the VPC and subnets.

Bastion Host (5 points)
    Create a bastion host for secure access to the private subnets.

NAT is implemented for private subnets (10 points)
    Orgainize NAT for private subnets with simpler or cheaper way
    Instances in private subnets should be able to reach addresses outside VPC

Documentation (5 points)
    Document the infrastructure setup and usage in a README file.

Submission (5 points)
    A GitHub Actions (GHA) pipeline is set up for the Terraform code.

-----------------------------
Pts calc
 

