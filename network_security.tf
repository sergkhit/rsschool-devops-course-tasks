resource "aws_security_group" "ssh_inbound" {
  name        = "ssh-inbound"
  description = "allows ssh access from safe IP-range"
  vpc_id      = aws_vpc.TFvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["111.222.222.111/32"]
  }
  tags = {
    Name      = "ssh-inbound-sg"
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
