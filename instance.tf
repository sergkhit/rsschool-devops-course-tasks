resource "aws_instance" "rs-task-public_server-a" {
  ami                         = var.ec2_ubuntu_ami
  instance_type               = var.aws_instance_k3s
  subnet_id                   = aws_subnet.TFpublic-a.id
  security_groups             = [aws_security_group.rs-task-public.id]
  key_name                    = aws_key_pair.rs-task-tf-ssh-key.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              hostnamectl set-hostname "master-k3s"

              #clone files for jenkins-pipeline and nodejs
              pwd
              git clone https://github.com/sergkhit/rsschool-devops-course-tasks-nodejs.git /home/ubuntu/nodejs-app
              ls -lha /home/ubuntu/
              # install Docker
              apt-get update -y
              # Install the required packages
              apt-get install -y apt-transport-https ca-certificates curl software-properties-common
              # Adding a GPG key for Docker
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
              # Adding a Docker repository
              add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
              # Install Docker
              apt-get update -y
              apt-get install -y docker-ce
              # Add a user to a Docker group
              # usermod -aG docker $USER
              sudo usermod -aG docker $USER
              # Running Docker
              systemctl start docker
              systemctl enable docker
              # Using newgrp to apply changes
              newgrp docker
              # install k3s
              curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.3+k3s1 sh -s - server --token=${random_password.k3s_token.result}
              sleep 30  # wait K3s start
              # Setup kubeconfig
              mkdir -p ~/.kube
              sudo chmod 644 /etc/rancher/k3s/k3s.yaml
              sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
              sudo chown $(id -u):$(id -g) ~/.kube/config
              export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
              # Set KUBECONFIG variable
              sudo su -c 'echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /root/.bashrc'
              source ~/.bashrc
              # install Helm
              curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
              echo "install bitnami"
              helm repo add bitnami https://charts.bitnami.com/bitnami
              kubectl get pods --namespace default
              # # install Sonarqube 
              # kubectl create namespace sonarqube
              # helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
              # helm repo update
              # wget https://raw.githubusercontent.com/sergkhit/rsschool-devops-course-tasks/refs/heads/task6/sonarqube/sonarqube-values.yaml 
              # # wget https://raw.githubusercontent.com/sergkhit/rsschool-devops-course-tasks/refs/heads/task6/sonarqube/sonarqube-service.yaml 
              # # kubectl apply -f sonarqube-service.yaml 
              # helm install rs-sonarqube sonarqube/sonarqube --namespace sonarqube --set persistence.enabled=true --set persistence.storageClass=local-path --set service.type=LoadBalancer
              # wget https://raw.githubusercontent.com/sergkhit/rsschool-devops-course-tasks/refs/heads/task6/sonarqube/sonarqube-service.yaml
              # sleep 120
              # kubectl apply -f sonarqube-service.yaml
              # install Jenkins
              kubectl create namespace jenkins
              sudo mkdir /data/jenkins -p
              sudo chown -R 1000:1000 /data/jenkins
              wget https://raw.githubusercontent.com/sergkhit/rsschool-devops-course-tasks/refs/heads/task6/jenkins/jenkins-volume.yaml 
              kubectl apply -f jenkins-volume.yaml
              sudo mkdir -p /data/jenkins-volume/
              sudo chown -R 1000:1000 /data/jenkins-volume/
              kubectl get pv
              kubectl get storageclass
              wget https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml
              kubectl apply -f jenkins-sa.yaml
              wget https://raw.githubusercontent.com/sergkhit/rsschool-devops-course-tasks/refs/heads/task6/jenkins/jenkins-values.yaml
              helm repo add jenkinsci https://charts.jenkins.io
              helm repo update
              helm search repo jenkinsci
              chart=jenkinsci/jenkins
              helm install jenkins -n jenkins -f jenkins-values.yaml $chart
              sleep 30
              mkdir -p /root/conf
              sudo ln -s /opt/Jenkins/conf /root/conf


              sleep 60
              # add sonarqube in jenkins
              kubectl exec -n jenkins svc/jenkins -c jenkins -- /bin/bash -c "jenkins-plugin-cli --plugins sonar"
              kubectl rollout restart statefulset jenkins -n jenkins
              sleep 120
              #wget https://raw.githubusercontent.com/sergkhit/rsschool-devops-course-tasks/refs/heads/task6/Jenkinsfile

              # Download Dockerfile
              #wget https://raw.githubusercontent.com/sergkhit/rsschool-devops-course-tasks/refs/heads/task6/Dockerfile

              # Retrieve the Jenkins admin password and save to a file
              jsonpath="{.data.jenkins-admin-password}"
              secret=$(kubectl get secret -n jenkins jenkins -o jsonpath="$jsonpath")
              
              sudo cat /root/conf/jenkins.txt
              JENKINS_URL="http://localhost:32000"
              JENKINS_USER="admin"
              JENKINS_PASS=$(cat /root/conf/jenkins.txt)
              echo cat /root/conf/jenkins.txt

              # find the public address
              PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
              echo "Public IP: $PUBLIC_IP"
              echo "$PUBLIC_IP" > /home/ubuntu/public_ip.txt
              kubectl patch svc jenkins -n jenkins -p '{"spec": {"type": "LoadBalancer"}}'
              # kubectl patch svc sonarqube -n sonarqube -p '{"spec": {"type": "LoadBalancer"}}'
              EOF

  user_data_replace_on_change = true

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task-public_server-a"
  }
}

# resource "aws_instance" "rs-task-public_server-b" {
#   ami                         = var.ec2_ubuntu_ami
#   instance_type               = var.aws_instance_pub
#   subnet_id                   = aws_subnet.TFpublic-b.id
#   security_groups             = [aws_security_group.rs-task-public.id]
#   key_name                    = aws_key_pair.rs-task-tf-ssh-key.key_name
#   associate_public_ip_address = true

#   tags = {
#     Terraform = true
#     Project   = var.project
#     Name      = "rs-task-public_server-b"
#   }
# }

# resource "aws_instance" "rs-task-k3s-master" {
#   ami                  = var.ec2_ubuntu_ami
#   instance_type        = var.aws_instance_k3s
#   subnet_id            = aws_subnet.TFprivate-a.id
#   security_groups      = [aws_security_group.rs-task-private.id]
#   key_name             = aws_key_pair.rs-task-tf-ssh-key.key_name
#   iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

#   user_data = <<-EOF
#               #!/bin/bash
#               curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.3+k3s1 sh -s - server \
#                 --token=${random_password.k3s_token.result} \
#                 --disable traefik
#               chmod 644 /etc/rancher/k3s/k3s.yaml
#               export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
#               EOF

#   user_data_replace_on_change = true

#   tags = {
#     Terraform = true
#     Project   = var.project
#     Name      = "rs-task-k3s-master"
#   }
# }

# resource "aws_instance" "rs-task-k3s-worker1" {
#   ami                  = var.ec2_ubuntu_ami
#   instance_type        = var.aws_instance_k3s
#   subnet_id            = aws_subnet.TFprivate-b.id
#   security_groups      = [aws_security_group.rs-task-private.id]
#   key_name             = aws_key_pair.rs-task-tf-ssh-key.key_name
#   iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
#   depends_on           = [aws_instance.rs-task-k3s-master]

#   user_data = <<-EOF
#               #!/bin/bash
#               curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.3+k3s1 K3S_URL=https://${aws_instance.rs-task-k3s-master.private_ip}:6443 K3S_TOKEN=${random_password.k3s_token.result} sh -
#               chmod 644 /etc/rancher/k3s/k3s.yaml
#               export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
#               EOF

#   user_data_replace_on_change = true

#   tags = {
#     Terraform = true
#     Project   = var.project
#     Name      = "rs-task-k3s-worker"
#   }

# }

# resource "aws_instance" "rs-task-k3s-worker2" {
#   ami                  = var.ec2_ubuntu_ami
#   instance_type        = var.aws_instance_k3s
#   subnet_id            = aws_subnet.TFprivate-b.id
#   security_groups      = [aws_security_group.rs-task-private.id]
#   key_name             = aws_key_pair.rs-task-tf-ssh-key.key_name
#   iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
#   depends_on           = [aws_instance.rs-task-k3s-master]

#   user_data = <<-EOF
#               #!/bin/bash
#               curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.3+k3s1 K3S_URL=https://${aws_instance.rs-task-k3s-master.private_ip}:6443 K3S_TOKEN=${random_password.k3s_token.result} sh -
#               chmod 644 /etc/rancher/k3s/k3s.yaml
#               EOF

#   user_data_replace_on_change = true

#   tags = {
#     Terraform = true
#     Project   = var.project
#     Name      = "rs-task-k3s-worker2"
#   }
# }
