
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

**Upgrading WordPress Chart**

To upgrade the wordpress Helm chart with new values or chart updates, use:

```bash
helm upgrade wordpress /home/ubuntu/helm --namespace default
```
** Uninstalling WordPress Chart **

To uninstall the wordpress Helm chart and remove all associated resources, use:

```bash
helm uninstall wordpress --namespace default
```

**Info about Prometheus**

A separate namespace called monitoring is created to isolate all monitoring components.

The following components are installed:

Prometheus — the main server for monitoring and storing metrics.
External access: port 30003.
Internal (for metrics servicing): port 9090.

Alertmanager — for managing event notifications.
External access: port 30004.
Internal (for metrics servicing): port 9093.

Node Exporter — for collecting metrics about physical nodes.
TargetPort (internal): by default 9100.

Kube State Metrics — for collecting metrics about the state of Kubernetes objects.
TargetPort (internal): by default 8080.

After the installation using Terraform, the parameter public_server_a_public_ip = "ip_address" is outputted. 
This will be the public address where the services are accessible.

Prometheus:   ip_address:30003
Alertmanager: ip_address:30004


**Prometheus Metrics for Monitoring:**

**Node Exporter Metrics (Infrastructure Metrics)**

1. **CPU Metrics:**

`node_cpu_seconds_total{mode="user"}` — total CPU time spent in user mode.
`node_cpu_seconds_total{mode="system"}` — total CPU time spent in system mode.
`node_cpu_seconds_total{mode="idle"}` — total CPU time spent in idle mode.
`node_cpu_seconds_total{mode="iowait"}` — total CPU time spent waiting for I/O operations.

2. **Memory Metrics:**

`node_memory_MemTotal_bytes` — total amount of available memory.
`node_memory_MemAvailable_bytes` — amount of available memory.
`node_memory_Active_bytes` — amount of active memory.
`node_memory_MemFree_bytes` — amount of free memory.
`node_memory_Cached_bytes` — amount of cached memory.
`node_memory_Buffers_bytes` — amount of memory occupied by buffers.

3. **Disk Metrics:**

`node_disk_io_time_seconds_total` — total time spent on disk I/O operations.
`node_disk_read_bytes_total` — total number of bytes read from the disk.
`node_disk_written_bytes_total` — total number of bytes written to the disk.
`node_filesystem_avail_bytes` — available space on the filesystem.
`node_filesystem_free_bytes` — free space on the filesystem.
`node_disk_reads_completed_total` — total number of completed read operations.
`node_disk_writes_completed_total` — total number of completed write operations.

4. **Network Metrics:**

`node_network_receive_bytes_total` — total number of bytes received over the network.
`node_network_transmit_bytes_total` — total number of bytes transmitted over the network.
`node_network_receive_packets_total` — total number of received packets.
`node_network_transmit_packets_total` — total number of transmitted packets.
`node_network_receive_errs_total` — total number of receive errors.
`node_network_transmit_errs_total` — total number of transmit errors.

5. **Kube-State-Metrics (Kubernetes Metrics)**

`kube_pod_status_phase` — status of pods (Running, Pending, Failed, etc.).
`kube_deployment_status_replicas` — number of replicas in deployments.
`kube_deployment_status_updated_replicas` — number of updated replicas in deployments.
`kube_node_status_condition` — status of nodes (Ready, NotReady, etc.).
`kube_pod_container_status_ready` — readiness of containers in pods.
`kube_pod_container_status_restarts_total` — total number of container restarts.
`kube_namespace_created` — for tracking namespaces in the cluster.

6. **Prometheus Metrics (Monitoring System Metrics)**

`prometheus_engine_query_duration_seconds` — duration of Prometheus queries.
`ALERTS` — active alerts and their states.
`prometheus_http_request_duration_seconds` — duration of HTTP requests to Prometheus.

Since there is no such requirement specified in the assignment, an exporter for WordPress has not been set up. 
To obtain WordPress metrics, it is necessary to install wordpress_exporter or similar solutions."

**Verify info in the cluster:**

```bash
kubectl get nodes
kubectl get pods -A
kubectl get pv
kubectl get pvc -A
kubectl get svc -A
kubectl get deployment wordpress -n wordpress
kubectl logs <wordpress-pod> -n wordpress
```

===========================================================

## Evaluation Criteria (100 points for covering all criteria) - ok (100)
------------------------------
Prometheus Installation (20 points) - ok (20) 
Prometheus is installed and running on the K8s cluster.
------------------------------
Deployment Automation (30 points) - ok (30) 
Automation of deployment with IaC or CI/CD pipeline is created.
------------------------------
Web interface is available (10 points) - ok (10) 
Metrics can be checked via Prometheus web interface.
------------------------------
Metrics Collection (35 points) - ok (35) 
Prometheus is collecting essential cluster-specific metrics, such as nodes' memory usage.
------------------------------
Documentation is created (5 points) - ok (5) 
A README file is created or updated documenting the Prometheus deployment and configuration.
------------------------------
------------------------------
Pts calc: 20+30+10+35+5 = 100
