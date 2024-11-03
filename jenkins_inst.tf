resource "null_resource" "install_jenkins" {
  depends_on = [aws_instance.rs-task-k3s-master]

  provisioner "remote-exec" {
    inline = [

      # Install Helm
      "curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash",

      # Helm deploying Nginx
      "helm repo add bitnami https://charts.bitnami.com/bitnami",
      "helm install my-nginx bitnami/nginx",

      # Check and after uninstall Nginx
      "kubectl get pods --namespace default",
      "helm uninstall my-nginx --namespace default",


      # Add repo for Jenkins
      "helm repo add jenkins https://charts.jenkins.io",
      "helm repo update",
      "helm install jenkins jenkins/jenkins --namespace jenkins --create-namespace --set persistence.existingClaim=jenkins-pvc"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("rs-task-key.pem")
      host        = aws_instance.rs-task-k3s-master.private_ip
    }
  }
}

resource "null_resource" "get_jenkins_ip" {
  depends_on = [null_resource.install_jenkins]

  provisioner "remote-exec" {
    inline = [
      "kubectl get svc --namespace jenkins -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}' > jenkins_ip.txt",
      "cat jenkins_ip.txt"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("rs-task-key.pem")
      host        = aws_instance.rs-task-k3s-master.private_ip
    }
  }
}

resource "null_resource" "update_nginx_config" {
  depends_on = [null_resource.get_jenkins_ip]

  provisioner "remote-exec" {
    inline = [
      "JENKINS_IP=$(cat jenkins_ip.txt)",
      "sudo sed -i 's|<JENKINS_PRIVATE_IP>|$JENKINS_IP|g' /etc/nginx/sites-available/jenkins.conf",
      "sudo nginx -t",
      "sudo systemctl restart nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("rs-task-key.pem")
      host        = aws_instance.rs-task-bastion_host.public_ip
    }
  }
}

