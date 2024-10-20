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

resource "aws_instance" "rs-task-k3s_master" {
  ami             = var.ec2_ubuntu_ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.TFprivate-a.id
  security_groups = [aws_security_group.rs-task-private.id]
  key_name        = aws_key_pair.rs-task-tf-ssh-key.key_name

  user_data                   = <<-EOL
                    #!/bin/bash
                    curl -sfL https://get.k3s.io | sh -
                    EOL
  user_data_replace_on_change = true

  # user_data = <<-EOF
  #             #!/bin/bash
  #             curl -sfL https://get.k3s.io | sh -
  #             echo $(cat /var/lib/rancher/k3s/server/node-token) > /tmp/k3s_token
  #             EOF

  # provisioner "local-exec" {
  #   command = "scp -i rs-task2-key.pem ubuntu@${self.public_ip}:/tmp/k3s_token ./k3s_token"
  # }

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task-k3s_master"
  }
}

resource "aws_instance" "rs-task-k3s_worker" {
  ami             = var.ec2_ubuntu_ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.TFprivate-b.id
  security_groups = [aws_security_group.rs-task-private.id]
  key_name        = aws_key_pair.rs-task-tf-ssh-key.key_name

  user_data                   = <<-EOL
                  #!/bin/bash
                  K3S_TOKEN=$(curl -sfL http://169.254.169.254/latest/meta-data/instance-id)
                  K3S_URL=https://${aws_instance.rs-task-k3s_master.public_ip}:6443
                  curl -sfL https://get.k3s.io | K3S_TOKEN=$K3S_TOKEN K3S_URL=$K3S_URL sh -
                  EOL
  user_data_replace_on_change = true

  # user_data = <<-EOF
  #             #!/bin/bash
  #             K3S_URL=https://${aws_instance.rs-task2-private_server-a.private_ip}:6443
  #             K3S_TOKEN=$(cat /tmp/k3s_token)
  #             curl -sfL https://get.k3s.io | K3S_URL=$K3S_URL K3S_TOKEN=$K3S_TOKEN sh -
  #             EOF

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task-k3s_worker"
  }
}
