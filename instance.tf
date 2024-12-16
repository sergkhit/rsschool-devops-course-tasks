resource "aws_instance" "rs-task-public_server-a" {
  ami                         = var.ec2_ubuntu_ami
  instance_type               = var.aws_instance_k3s
  subnet_id                   = aws_subnet.TFpublic-a.id
  security_groups             = [aws_security_group.rs-task-public.id]
  key_name                    = aws_key_pair.rs-task-tf-ssh-key.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              set -e # Exit on error
              hostnamectl set-hostname "master-k3s"
              # install k3s
              curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.31.2+k3s1 sh -s - server --token=${random_password.k3s_token.result}
              sleep 60  # wait K3s start

              # Setup kubeconfig
              mkdir -p ~/.kube
              sudo chmod 644 /etc/rancher/k3s/k3s.yaml
              sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
              sudo chown $(id -u):$(id -g) ~/.kube/config
              export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
              # Set KUBECONFIG variable
              sudo su -c 'echo "export KUBECONFIG=/etc/rancher/k3s/k3s.yaml" >> /root/.bashrc'
              source ~/.bashrc
              # kubeconfig for ubuntu user
              mkdir -p /home/ubuntu/.kube
              cp /etc/rancher/k3s/k3s.yaml /home/ubuntu/.kube/config
              chown ubuntu:ubuntu /home/ubuntu/.kube/config

              # install Helm and add bitnami
              curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
              helm repo add bitnami https://charts.bitnami.com/bitnami
              sleep 10 
              helm repo update

              # Install Prometheus using Helm
              mkdir -p /home/ubuntu/prometheus
              helm upgrade --install prometheus bitnami/kube-prometheus \
                --namespace monitoring \
                --create-namespace \
                --set prometheus.service.type=LoadBalancer \
                --set prometheus.service.port=9090 \
                --set prometheus.resources.limits.cpu=200m \
                --set prometheus.resources.limits.memory=256Mi \
                --set prometheus.resources.requests.cpu=100m \
                --set prometheus.resources.requests.memory=128Mi \
                --set prometheus.retention=7d \
                --set prometheus.replicas=1 \
                --set alertmanager.enabled=false \
                --set nodeExporter.resources.limits.cpu=50m \
                --set nodeExporter.resources.limits.memory=64Mi \
                --set nodeExporter.resources.requests.cpu=25m \
                --set nodeExporter.resources.requests.memory=32Mi \
                --set kubeStateMetrics.resources.limits.cpu=100m \
                --set kubeStateMetrics.resources.limits.memory=128Mi \
                --set kubeStateMetrics.resources.requests.cpu=50m \
                --set kubeStateMetrics.resources.requests.memory=64Mi \
                --set prometheusOperator.enabled=true \
                --set prometheusOperator.replicas=1
              # sleep 300

              # Waiting for Prometheus pods to start
              echo "Waiting for Prometheus to be deployed..."
              kubectl wait --for=condition=available --timeout=600s deployment/prometheus-kube-prometheus-operator -n monitoring || echo "Prometheus deployment not found!"

              # Install Grafana
      
              PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

              DASHBOARD_PATH="/opt/grafana/dashboards/system_metrics.json"
              mkdir -p /opt/grafana/dashboards/
              sudo curl -o /opt/grafana/dashboards/system_metrics.json https://raw.githubusercontent.com/sergkhit/rsschool-devops-course-tasks/task8/grafana/system_metrics.json
              sleep 60
              sudo chmod 644 /opt/grafana/dashboards/system_metrics.json

              # ConfigMap for dashboard
                kubectl create configmap task8-dashboard --from-file=/opt/grafana/dashboards/system_metrics.json --namespace monitoring

              helm upgrade --install grafana oci://registry-1.docker.io/bitnamicharts/grafana \
                --namespace monitoring \
                --create-namespace \
                --set service.type=NodePort \
                --set service.nodePorts.grafana=30030 \
                --set admin.password=${var.grafana-password} \
                --set dashboardsProvider.enabled=true \
                --set dashboardsConfigMaps[0].configMapName=task8-dashboard \
                --set dashboardsConfigMaps[0].fileName=system_metrics.json \
                --set datasources.secretDefinition.apiVersion=1 \
                --set datasources.secretDefinition.datasources[0].name=Prometheus \
                --set datasources.secretDefinition.datasources[0].type=prometheus \
                --set datasources.secretDefinition.datasources[0].url=http://$PUBLIC_IP:9090 \
                --set datasources.secretDefinition.datasources[0].access=proxy \
                --set datasources.secretDefinition.datasources[0].isDefault=true

              kubectl patch svc prometheus-kube-prometheus-prometheus -n monitoring -p '{"spec": {"type": "LoadBalancer"}}'
              # kubectl patch svc grafana -n monitoring -p '{"spec": {"type": "LoadBalancer"}}'

              kubectl get pods -A
              kubectl get svc -A
              helm list -n monitoring
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
