# resource "aws_instance" "rs-task-public_server-a" {
#   ami                         = var.ec2_ubuntu_ami
#   instance_type               = var.aws_instance_pub
#   subnet_id                   = aws_subnet.TFpublic-a.id
#   security_groups             = [aws_security_group.rs-task-public.id]
#   key_name                    = aws_key_pair.rs-task-tf-ssh-key.key_name
#   associate_public_ip_address = true

#   tags = {
#     Terraform = true
#     Project   = var.project
#     Name      = "rs-task-public_server-a"
#   }
# }

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

resource "aws_instance" "rs-task-k3s-master" {
  ami                  = var.ec2_ubuntu_ami
  instance_type        = var.aws_instance_k3s
  subnet_id            = aws_subnet.TFprivate-a.id
  security_groups      = [aws_security_group.rs-task-private.id]
  key_name             = aws_key_pair.rs-task-tf-ssh-key.key_name
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash
              curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.3+k3s1 sh -s - server \
                --token=${random_password.k3s_token.result} \
                --disable traefik
              chmod 644 /etc/rancher/k3s/k3s.yaml
              export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
              # Install Helm
              curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
              # Helm deploying Nginx
              helm repo add bitnami https://charts.bitnami.com/bitnami
              helm install my-nginx bitnami/nginx
              # Check and after uninstall Nginx
              kubectl get pods --namespace default
              helm uninstall my-nginx --namespace default
              # Add repo for Jenkins
              helm repo add jenkins https://charts.jenkins.io
              helm repo update
              # # Clone from git jenkins config
              git clone https://github.com/sergkhit/rsschool-devops-course-Jenkins.git /opt/Jenkins/conf
              # fix Jenkins pod start problem
              sudo mkdir -p /data/jenkins-volume
              sudo chown -R 1000:1000 /data/jenkins-volume
              # cd /opt/Jenkins/conf
              # kubectl apply -f jenkins-volume.yaml
              # kubectl apply -f jenkins-sa.yaml
              # helm install jenkins jenkins/jenkins -f jenkins-values.yaml -n jenkins
              # create namespace jenkins for Jenkins
              kubectl create namespace jenkins 
              # Install Jenkins in namespace jenkins and add LoadBalancer
              helm install jenkins jenkins/jenkins --namespace jenkins --set serviceType=LoadBalancer --set persistence.storageClass=standard --set persistence.size=8Gi
          
              # get_jenkins_ip" 
              kubectl get svc --namespace jenkins -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}' > jenkins_ip.txt
              cat jenkins_ip.txt
              JENKINS_IP=$(cat jenkins_ip.txt)             
              EOF

  user_data_replace_on_change = true

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task-k3s-master"
  }
}

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
