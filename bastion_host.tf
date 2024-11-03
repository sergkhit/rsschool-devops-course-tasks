resource "aws_instance" "rs-task-bastion_host" {
  ami                         = var.ec2_ubuntu_ami
  instance_type               = var.aws_instance_pub
  subnet_id                   = aws_subnet.TFpublic-a.id
  security_groups             = [aws_security_group.rs-task-bastion.id]
  key_name                    = aws_key_pair.rs-task-tf-ssh-key.key_name
  depends_on                  = [aws_instance.rs-task-k3s-master]
  associate_public_ip_address = true

  user_data = <<-EOF

            #  # install_ssh_key
            # mkdir -p ~/.ssh
            # echo '${tls_private_key.rs-task-tf-ssh-key.public_key_openssh}' >> ~/.ssh/authorized_keys
            # chmod 600 ~/.ssh/authorized_keys

            # install_nginx
            echo "install_nginx"
            sudo apt update
            sudo apt install -y nginx
            sudo systemctl start nginx
            sudo systemctl enable nginx
            echo "end install_nginx"
           
            # configure_nginx
            mv /opt/Jenkins/conf/jenkins.conf /etc/nginx/sites-available/jenkins.conf
            JENKINS_IP=$(cat jenkins_ip.txt)
            sudo sed -i 's|<JENKINS_PRIVATE_IP>|$JENKINS_IP|g' /etc/nginx/sites-available/jenkins.conf
            sudo ln -s /etc/nginx/sites-available/jenkins.conf /etc/nginx/sites-enabled/
            sudo nginx -t
            sudo systemctl restart nginx
            EOF

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task-bastion_host"
  }
}

