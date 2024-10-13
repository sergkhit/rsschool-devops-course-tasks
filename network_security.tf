
// Security groups


// VPC ssh security group

resource "aws_security_group" "rs-task2-bastion" {
  name        = "ssh-inbound"
  description = "allows ssh access from safe IP-range"
  vpc_id      = aws_vpc.TFvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
    tags = {
    Name      = "rs-task2-ssh-inbound-sg"
    Terraform = "true"
    Project   = var.project
    Owner     = var.user_owner

  }
}



# resource "aws_security_group" "rs-task2-sg-default" {
#   name        = "rs-task2-default-security-group"
#   description = "Default security group for all instances"
#   vpc_id      = aws_vpc.TFvpc.id

#   ingress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port = 0
#     to_port   = 0
#     protocol  = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


resource "aws_security_group" "rs-task2-nat" {
  name        = "rs-task2-nat-sg"
  description = "Security group for NAT instance"
  vpc_id      = aws_vpc.TFvpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.20.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   
    tags = {
    Name      = "rs-task2-nat-sg"
    Terraform = "true"
    Project   = var.project
    Owner     = var.user_owner

  }
}


resource "aws_security_group" "rs-task2-public" {
  name        = "rs-task2-public-security-group"
  description = "Security group for instances in public subnets"
  vpc_id      = aws_vpc.TFvpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    
  # Allowing SSH access from the bastion host 
  ingress {
    from_port   = 22 
    to_port     = 22 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rs-task2-private" {
  name        = "rs-task2-private-security-group"
  description = "Security group for instances in private subnets"
  vpc_id      = aws_vpc.TFvpc.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.rs-task2-bastion.id]
    description     = "Allow SSH from bastion-host."
  }

  ingress {
    from_port       = 8
    to_port         = 0
    protocol        = "icmp"
    security_groups = [aws_security_group.rs-task2-bastion.id]
    description     = "Allow ICMP echo from bastion-host."
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
resource "tls_private_key" "rs-task2-tf-ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Create EC2 key pair from the generated private key
resource "aws_key_pair" "rs-task2-tf-ssh-key" {
  key_name   = "rs-task2-key"
  public_key = tls_private_key.rs-task2-tf-ssh-key.public_key_openssh
  tags = {
    Terraform = true
    Project   = var.project
    Owner     = var.user_owner
  }
}
provider "local" {}
resource "local_file" "key" {
  content  = tls_private_key.rs-task2-tf-ssh-key.private_key_pem
  filename = "rs-task2-key.pem"
}

output "private_key" {
  value     = tls_private_key.rs-task2-tf-ssh-key.private_key_pem
  sensitive = true
}
