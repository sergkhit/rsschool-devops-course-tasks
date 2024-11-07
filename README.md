Project: rolling-scopes-school. 

Task 4: Jenkins Installation and Configuration

In this task, you will install Jenkins CI server on your Kubernetes (K8s) cluster using Helm and configure it to be accessible via internet. IMPORTANT! You better choose to use t3/t2.small VMs, since micro have not sufficient amount of RAM for running Jenkins. Be aware that small instances are not included in the free tier, so you'll be charged 0.05$/hour for them. Best choise for saving - create 1 small instalnce in public network. Setup init script to install k3s and deploy all of the necessary HELM charts to startup jenkins. Destroy environment whenever you are not working with it. Have a look at this JCasC article to store jenkins configuration and jobs as s code.

https://github.com/rolling-scopes-school/tasks/blob/master/devops/modules/3_ci-configuration/task_4.md

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


===========================================================

## How to Use

Clone the repository Clone the repository and navigate to the project directory:

git clone git@github.com:sergkhit/rsschool-devops-course-tasks.git
cd rsschool-devops-course-tasks
git branch task_4

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
on local mashine put this info in config "vi ~/.kube/config"

after create tunnel for kubectl:

```bash
ssh -i rs-task-key.pem -fNL 6443:ip_k3s_master:6443 ubuntu@ip_bastion
```

**Verify the Cluster and Jenkins:**

```bash
kubectl get nodes
kubectl get pods -n jenkins
```
**Access Jenkins:**
   we should be able to access Jenkins via the public IP of our master node - you may see it in output.

Open a web browser and navigate to http://<master_node_public_ip>:32000. You should see the Jenkins setup wizard.

**Unlock Jenkins:**
    You’ll need the initial admin password to unlock Jenkins. Retrieve it by running:

```bash
kubectl exec --namespace jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo
```

Copy the password and paste it into the Jenkins setup wizard to unlock Jenkins.

**Create a Freestyle Project:**
  Create a new Freestyle project:
- Name it something like "Hello World".
- In the build section, add an "Execute shell" build step with the following command:

```bash
echo "Hello world"
```
- Save the project and run it.

**Verify the Freestyle Project Build Output:**
    After running the job, check the console output to ensure it shows "Hello world".

**Check Persistent Volume Configuration:**
    Ensure that the persistent volume (PV) and persistent volume claim (PVC) were created successfully:

```bash
kubectl get pv
kubectl get pvc -n jenkins
```
 **Verify your Helm installation by deploying and removing the Nginx chart from Bitnami:**
First, install the Nginx chart using Helm. You can run the following command to deploy the Nginx server:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-nginx bitnami/nginx
```

Verify the Deployment:

```bash
kubectl get pods --namespace default
```

Remove the Nginx Chart:

```bash
helm uninstall my-nginx --namespace default
```

Check that the Nginx resources have been removed:

```bash
kubectl get pods --namespace default
kubectl get svc
```

===========================================================

## Evaluation Criteria (100 points for covering all criteria)

------------------------------
Helm Installation and Verification (10 points) - ok (10) 

Helm is installed and verified by deploying the Nginx chart.
------------------------------
Cluster Requirements (10 points) - ok (10) 

The cluster has a solution for managing persistent volumes (PV) and persistent volume claims (PVC).
------------------------------
Jenkins Installation (50 points) - ok (10) 

Jenkins is installed using Helm in a separate namespace.
Jenkins is available from the internet.
------------------------------
Jenkins Configuration (10 points) - ok (10) 

Jenkins configuration is stored on a persistent volume and is not lost when Jenkins' pod is terminated.
------------------------------
Verification (10 points) - ok (10) 

A simple Jenkins freestyle project is created and runs successfully, writing "Hello world" into the log.
------------------------------
Additional Tasks (10 points) - ok (10) 

GitHub Actions (GHA) Pipeline (5 points) 
A GHA pipeline is set up to deploy Jenkins.

Authentication and Security (5 points) 
Authentication and security settings are configured for Jenkins.

-----------------------------
Pts calc
 
 10+60+10+10+10 = 100
