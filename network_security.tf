
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

// Create a Key Pair

provider "tls" {}
resource "tls_private_key" "t" {
  algorithm = "RSA"
}
resource "aws_key_pair" "test" {
  key_name   = "rs-task2-key"
  public_key = tls_private_key.t.public_key_openssh
}
provider "local" {}
resource "local_file" "key" {
  content  = tls_private_key.t.private_key_pem
  filename = "rs-task2.pem"
}
