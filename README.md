Project: rolling-scopes-school. Task1 - AWS Account Configuration.
https://github.com/rolling-scopes-school/tasks/blob/master/devops/modules/1_basic-configuration/task_1.md



Project file Structure.

README.md:    This file.

.gitignore:   file specifies which folders or files should be ignored when tracking changes with Git.

Screenshots/: directory contains resources screenshots.

main.tf:      main configuration file the core infrastructure.

backend.tf:   file contains the S3 resource declarations.

variables.tf: file defines input variables for Terraform configuration.

providers.tf: file specifies the providers needed for Terraform configuration

#outputs.tf:  file contains the output definitions for the Terraform resources.

#iam.tf:      file contains the IAM resource declarations.

#.github/workflows/: directory is where GitHub-specific files are stored,  workflows for GitHub Actions.

===========================================================

## Setup Instructions

1. **Clone the Repository**

`git clone https://github.com/sergkhit/rsschool-devops-course-tasks.git`

2. **Prepare the Variables File**

`cp terraform.tfvars.example terraform.tfvars`

Edit `terraform.tfvars` with your data

3. **Initialize Terraform**

`terraform init`

4. **Run the Terraform Plan**

`terraform plan`

5. **Run the Terraform Apply**

`terraform apply`


===========================================================

Evaluation Criteria (100 points for covering all criteria)

MFA User configured (10 points) - (ok) (+10)
Provide a screenshot of the non-root account secured by MFA (ensure sensitive information is not shared).

Bucket and GithubActionsRole IAM role configured (30 points)
Terraform code is created and includes:
A bucket for Terraform states - (ok)
IAM role with correct Identity-based and Trust policies

Github Actions workflow is created (30 points)
Workflow includes all jobs

Code Organization (10 points) - (ok) (+10)
Variables are defined in a separate variables file. - (ok)
Resources are separated into different files for better organization. - (ok)

Verification (10 points)
Terraform plan is executed successfully for GithubActionsRole
Terraform plan is executed successfully for a terraform state bucket - (ok)

Additional Tasks (10 points) - (ok) (+10)
Documentation (5 points) - (ok) 
Document the infrastructure setup and usage in a README file. - (ok)

Submission (5 points)
A GitHub Actions (GHA) pipeline is passing

Pts calc
10 + 10 + 10 => 30