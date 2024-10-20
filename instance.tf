resource "aws_instance" "rs-task-public_server-a" {
  ami                         = var.ec2_ubuntu_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.TFpublic-a.id
  security_groups             = [aws_security_group.rs-task-public.id]
  key_name                    = aws_key_pair.rs-task-tf-ssh-key.key_name
  associate_public_ip_address = true

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task-public_server-a"
  }
}

resource "aws_instance" "rs-task-public_server-b" {
  ami                         = var.ec2_ubuntu_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.TFpublic-b.id
  security_groups             = [aws_security_group.rs-task-public.id]
  key_name                    = aws_key_pair.rs-task-tf-ssh-key.key_name
  associate_public_ip_address = true

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task-public_server-b"
  }
}

resource "aws_instance" "rs-task-k3s-master" {
  ami                  = var.ec2_ubuntu_ami
  instance_type        = "t2.micro"
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
              EOF

  user_data_replace_on_change = true

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task-k3s-master"
  }
}

resource "aws_instance" "rs-task-k3s-worker1" {
  ami                  = var.ec2_ubuntu_ami
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.TFprivate-b.id
  security_groups      = [aws_security_group.rs-task-private.id]
  key_name             = aws_key_pair.rs-task-tf-ssh-key.key_name
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  depends_on           = [aws_instance.rs-task-k3s-master]

  user_data = <<-EOF
              #!/bin/bash
              curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.3+k3s1 K3S_URL=https://${aws_instance.rs-task-k3s-master.private_ip}:6443 K3S_TOKEN=${random_password.k3s_token.result} sh -
              chmod 644 /etc/rancher/k3s/k3s.yaml
              EOF


  user_data_replace_on_change = true

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task-k3s-worker"
  }

}

resource "aws_instance" "rs-task-k3s-worker2" {
  ami                  = var.ec2_ubuntu_ami
  instance_type        = "t2.micro"
  subnet_id            = aws_subnet.TFprivate-b.id
  security_groups      = [aws_security_group.rs-task-private.id]
  key_name             = aws_key_pair.rs-task-tf-ssh-key.key_name
  iam_instance_profile = aws_iam_instance_profile.ssm_instance_profile.name
  depends_on           = [aws_instance.rs-task-k3s-master]

  user_data = <<-EOF
              #!/bin/bash
              curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION=v1.21.3+k3s1 K3S_URL=https://${aws_instance.rs-task-k3s-master.private_ip}:6443 K3S_TOKEN=${random_password.k3s_token.result} sh -
              chmod 644 /etc/rancher/k3s/k3s.yaml
              EOF

  user_data_replace_on_change = true

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task-k3s-worker2"
  }
}
