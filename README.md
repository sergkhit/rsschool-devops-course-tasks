
Please do not evaluate the tasks until Saturday (December 7th). 
I need a little more time. Thank you for your understanding."
discord: @sergkhit



===========================================================

Project: rolling-scopes-school. 

Task 7: Prometheus Deployment on K8s

In this task, you will install Prometheus on your Kubernetes (K8s) cluster using a Helm chart and configure it to collect essential cluster-specific metrics.

https://github.com/rolling-scopes-school/tasks/blob/master/devops/modules/4_monitoring-configuration/task_7.md

===========================================================

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


Additionally, for installing WordPress, https://github.com/sergkhit/rsschool-devops-course-tasks-WordPress
repository has been created, where wordpres can be configured for installation via helm.

===========================================================

For this task I am using my Wordpress cluster created in task 5. 

I updated my script with install Prometheus.

## How to Use

Clone the repository Clone the repository and navigate to the project directory:

```bash
git clone git@github.com:sergkhit/rsschool-devops-course-tasks.git
cd rsschool-devops-course-tasks
git branch task_5
```

Initialize Terraform:

```bash
terraform init
```

Plan and Apply Changes:

```bash
terraform plan
terraform apply
```

-------------------------------

Set Up AWS Credentials In your GitHub repository settings, add the following secrets:
ACTION_ROLE_ARN: ARN of an AWS IAM role with necessary permissions Follow Creating GitHub OIDC for AWS
Customize Variables Modify variables.tf to set your preferred project name and environment. 

Run CI / CD The plan workflow will run automatically on pull requests to the main branch, and on merged PRs to main.

-------------------------------
Issued AWS addresses of all servers can be seen after "terraform apply"; they are displayed in the outputs.

```bash
chmod 400 rs-task-key.pem
cat rs-task-key.pem
ssh -i rs-task-key.pem ubuntu@ip_address_bastion
```

After accessing the bastion, create a file named rs-task-key.pem and paste the contents of the key into it. 
Then adjust the permissions of rs-task-key.pem with the following command: 

```bash
chmod 400 rs-task-key.pem 
```

Now you can connect to the servers using the addresses from the outputs.

```bash
ssh -i rs-task-key.pem ubuntu@ip_address_server
```

**For manage cluster from local laptop:**

Copy the k3s.yaml File to your local machine:
connect to k3s master and get info from file:

```bash
cat /etc/rancher/k3s/k3s.yaml
```
on local mashine put this info in config 

```bash
vi ~/.kube/config
```

after create tunnel for kubectl:

```bash
ssh -i rs-task-key.pem -fNL 6443:ip_k3s_master:6443 ubuntu@ip_bastion
```

** Upgrading WordPress Chart **

To upgrade the wordpress Helm chart with new values or chart updates, use:

```bash
helm upgrade wordpress /home/ubuntu/helm --namespace default
```
** Uninstalling WordPress Chart **

To uninstall the wordpress Helm chart and remove all associated resources, use:

```bash
helm uninstall wordpress --namespace default
```

**Verify info in the cluster:**

```bash
kubectl get nodes
kubectl get pods -n default
kubectl get pv
kubectl get pvc 
kubectl get svc
kubectl get deployment wordpress -n default
kubectl logs <wordpress-pod> -n default
```

===========================================================

## Evaluation Criteria (100 points for covering all criteria)

------------------------------
Helm Chart Creation (40 points) - ok (40) 

A Helm chart for the WordPress application is created.
------------------------------
Application Deployment (30 points) - ok (30) 

The application is deployed using the Helm chart.
The application is accessible from the internet.
------------------------------
Repository Submission (5 points) - ok (5) 

A new repository is created with the WordPress and Helm chart.
------------------------------
Verification (5 points) - ok (5) 

The application is verified to be running and accessible.
------------------------------
Additional Tasks (20 points) - ok (20) 

CI/CD Pipeline (10 points)
A CI/CD pipeline is set up to automate the deployment of the application.

Documentation (10 points)
The application setup and deployment process are documented in a README file.
------------------------------
------------------------------
Pts calc: 40+30+5+5+20 = 100
