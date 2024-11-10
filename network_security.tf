
// Security groups


// VPC ssh security group

resource "aws_security_group" "rs-task-bastion" {
  name        = "ssh-inbound"
  description = "allows ssh access from safe IP-range"
  vpc_id      = aws_vpc.TFvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   from_port   = 6443
  #   to_port     = 6443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   from_port   = 8080
  #   to_port     = 8080
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "rs-task-ssh-inbound-sg"
    Terraform = "true"
    Project   = var.project
    Owner     = var.user_owner

  }
}

resource "aws_security_group" "rs-task-public" {
  name        = "rs-task-public-security-group"
  description = "Security group for instances in public subnets"
  vpc_id      = aws_vpc.TFvpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
    description = "Allow HTTPS SSL/TSL"
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
    description = "Allow access to K3s API from bastion host."
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
    description = "Allow access to Kubelet API"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
    description = "Allow inbound HTTP"
  }

  ingress {
    from_port   = 32000
    to_port     = 32000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow inbound for Jenkins"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
    description = "Allow inbound HTTPS"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH access from the bastion host "
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rs-task-private" {
  name        = "rs-task-private-security-group"
  description = "Security group for instances in private subnets"
  vpc_id      = aws_vpc.TFvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
    description = "Allow SSH from bastion-host."
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
    description = "Allow HTTPS SSL/TSL"
  }

  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
    description = "Allow access to K3s API from bastion host."
  }

  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
    description = "Allow access to Kubelet API"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
    description = "Allow inbound HTTP"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
    description = "Allow inbound HTTPS"
  }

  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["10.20.0.0/16"]
    description = "Allow ICMP echo from local netw."
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Anywhere."
  }
}

# Create new SSH Key Pair

provider "tls" {}
resource "tls_private_key" "rs-task-tf-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create EC2 key pair from the generated private key
resource "aws_key_pair" "rs-task-tf-ssh-key" {
  key_name   = "rs-task-key"
  public_key = tls_private_key.rs-task-tf-ssh-key.public_key_openssh
  tags = {
    Terraform = true
    Project   = var.project
    Owner     = var.user_owner
  }
}
provider "local" {}
resource "local_file" "key" {
  content  = tls_private_key.rs-task-tf-ssh-key.private_key_pem
  filename = "rs-task-key.pem"
}

output "private_key" {
  value     = tls_private_key.rs-task-tf-ssh-key.private_key_pem
  sensitive = true
}
