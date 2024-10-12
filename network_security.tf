
// Security groups

resource "aws_security_group" "rs-task2-sg-default" {
  name        = "rs-task2-default-security-group"
  description = "Default security group for all instances"
  vpc_id      = aws_vpc.TFvpc.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
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
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["10.20.0.0/16"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// access list for public subnets

resource "aws_network_acl" "rs-task2-public_acl" {
  vpc_id = aws_vpc.TFvpc.id 
  ingress {
    protocol   = "-1"
    rule_no    = 100 
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0 
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100 
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0 
  }
}

resource "aws_network_acl_association" "public_acl_assoc_a" {
  subnet_id     = aws_subnet.TFpublic-a.id 
  network_acl_id = aws_network_acl.rs-task2-public_acl.id 
  }

resource "aws_network_acl_association" "public_acl_assoc_b" {
  subnet_id     = aws_subnet.TFpublic-b.id 
  network_acl_id = aws_network_acl.rs-task2-public_acl.id 
  }



// VPC ssh security group

resource "aws_security_group" "rs-task2-ssh_inbound" {
  name        = "ssh-inbound"
  description = "allows ssh access from safe IP-range"
  vpc_id      = aws_vpc.TFvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.user_laptop_ip] # ip your laptop from variables
  }
  tags = {
    Name      = "rs-task2-ssh-inbound-sg"
    Terraform = "true"
    Project   = var.project
    Owner     = var.user_owner

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

# terraform output private_key > rs-task2-key.pem
# chmod 400 rs-task2-key.pem
# ssh -i rs-task2-key.pem ubuntu@ip_address_bastion



# resource "aws_key_pair" "rs-task2-tf-ssh-key" {
#   key_name   = "rs-tf-ssh-key"
#   public_key = var.ssh_key
#   tags = {
#     Terraform = true
#     Project   = var.project
#     Owner     = var.user_owner
#   }
# }