Project: rolling-scopes-school. 

Task1 - AWS Account Configuration.

https://github.com/rolling-scopes-school/tasks/blob/master/devops/modules/1_basic-configuration/task_1.md

============================================================


Project file Structure.

Screenshots/: directory contains resources and works screenshots.

README.md:    This file.

.gitignore:   file specifies which folders or files should be ignored when tracking changes with Git.

main.tf:      main configuration file the core infrastructure and providers.

backend.tf:   file contains the S3 resource declarations for terraform backend.

variables.tf: file defines input variables for Terraform configuration.

outputs.tf:  file contains the output definitions for the Terraform resources.

iam.tf:      file contains the IAM resource declarations.

terraform.tfvars.example: file contains the variables example for resourses

.github/workflows/terrform.yaml: GitHub-specific files,  workflows for GitHub Actions.

===========================================================

## Use Instructions

Set Up AWS Credentials In your GitHub repository settings, add the following secrets:
ACTION_ROLE_ARN: ARN of an AWS IAM role with necessary permissions Follow Creating GitHub OIDC for AWS
Customize Variables Modify variables.tf to set your preferred project name and environment. 

If you are not willing to share variables in VCS, declare them in terraform.tfvars 
(`cp terraform.tfvars.example terraform.tfvars` and edit `terraform.tfvars` with your information)/

Run CI / CD The plan workflow will run automatically on pull requests to the main branch, and on merged PRs to main.


===========================================================

Evaluation Criteria (100 points for covering all criteria)

MFA User configured (10 points) - (ok) (+10)
Provide a screenshot of the non-root account secured by MFA (ensure sensitive information is not shared).

Bucket and GithubActionsRole IAM role configured (30 points)  - (ok) (+30)
Terraform code is created and includes:
A bucket for Terraform states - (ok)
IAM role with correct Identity-based and Trust policies - (ok)

Github Actions workflow is created (30 points) - - (ok) (+30)
Workflow includes all jobs

Code Organization (10 points) - (ok) (+10)
Variables are defined in a separate variables file. - (ok)
Resources are separated into different files for better organization. - (ok)

Verification (10 points) - (ok) (+10)
Terraform plan is executed successfully for GithubActionsRole - (ok)
Terraform plan is executed successfully for a terraform state bucket - (ok)

Additional Tasks (10 points) - (ok) (+10)
Documentation (5 points) - (ok)  
Document the infrastructure setup and usage in a README file. - (ok)

Submission (5 points) - (ok)
A GitHub Actions (GHA) pipeline is passing - (ok)

Pts calc
10 + 30 + 30 + 10 + 10 + 10 => 100 
