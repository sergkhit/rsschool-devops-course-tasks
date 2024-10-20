Project: rolling-scopes-school. 

Task 3: K8s Cluster Configuration and Creation

https://github.com/rolling-scopes-school/tasks/blob/master/devops/modules/2_cluster-configuration/task_3.md

============================================================

├── backend.tf
├── bastion_host.tf
├── iam.tf
├── instance.tf
├── nacl.tf
├── network_security.tf
├── network.tf
├── outputs.tf
├── README.md
├── root.tf
├── screenshots
└── variables.tf


## Project file Structure:

README.md:    This file.

screenshots/: directory contains resources and works screenshots.

.github/workflows/terrform.yaml: GitHub-specific files,  workflows for GitHub Actions

.gitignore:   file specifies which folders or files should be ignored when tracking changes with Git.

backend.tf:   file contains the S3 resource declarations for terraform backend.

bastion_host.tf: file contains the resource declarations for bastion.

iam.tf:      file contains the IAM resource declarations.

instance.tf: file contains the resource declarations all instances in public and private networks

network_security.tf: file contains the resource declarations security groups and ssh keys

nacl.tf: file contains the resource declarations access lists

network.tf: file contains the resource declarations for VPC, networks, IGW, NAT and route tables

outputs.tf:  file contains the output definitions for the Terraform resources.

root.tf : main configuration file the core infrastructure and providers.

variables.tf: file defines input variables for Terraform configuration.


===========================================================

## How to Use

Clone the repository Clone the repository and navigate to the project directory:

git clone git@github.com:sergkhit/rsschool-devops-course-tasks.git
cd rsschool-devops-course-tasks
git branch task_3

Initialize Terraform:

terraform init

Plan and Apply Changes:

terraform plan

terraform apply

-------------------------------

Set Up AWS Credentials In your GitHub repository settings, add the following secrets:
ACTION_ROLE_ARN: ARN of an AWS IAM role with necessary permissions Follow Creating GitHub OIDC for AWS
Customize Variables Modify variables.tf to set your preferred project name and environment. 

Run CI / CD The plan workflow will run automatically on pull requests to the main branch, and on merged PRs to main.

-------------------------------
Issued AWS addresses of all servers can be seen after "terraform apply"; they are displayed in the outputs.

chmod 400 rs-task-key.pem
cat rs-task-key.pem
ssh -i rs-task-key.pem ubuntu@ip_address_bastion

After accessing the bastion, create a file named rs-task-key.pem and paste the contents of the key into it. 
Then adjust the permissions of rs-task-key.pem with the following command: chmod 400 rs-task-key.pem 
Now you can connect to the servers using the addresses from the outputs.
ssh -i rs-task-key.pem ubuntu@ip_address_server

===========================================================

## Evaluation Criteria (100 points for covering all criteria)

------------------------------

Terraform Code for AWS Resources (10 points) - ok (+10) 

Terraform code is created or extended to manage AWS resources required for the cluster creation.
The code includes the creation of a bastion host.

------------------------------
Cluster Deployment (60 points) - ok (+60) k3s.

A K8s cluster is deployed using either kOps or k3s.
The deployment method is chosen based on the user's preference and understanding of the trade-offs.

------------------------------
Cluster Verification (10 points) - ok (+10)

The cluster is verified by running the kubectl get nodes command from the local computer.
A screenshot of the kubectl get nodes command output is provided.

------------------------------
Workload Deployment (10 points) - ok (+10)

A simple workload is deployed on the cluster using kubectl apply -f https://k8s.io/examples/pods/simple-pod.yaml.
The workload runs successfully on the cluster.

------------------------------
Additional Tasks (10 points)

Document the cluster setup and deployment process in a README file. - ok (+10) 

-----------------------------
Pts calc
 
 10+60+10+10+10 = 100
