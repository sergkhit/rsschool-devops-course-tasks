resource "aws_security_group_rs_task2" "ssh_inbound" {
  name        = "ssh-inbound"
  description = "allows ssh access from safe IP-range"
  vpc_id      = aws_vpc.TFvpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["111.222.333.111/32"]
  }
  tags = {
    Name      = "ssh-inbound-sg"
    Terraform = "true"
    Project   = var.project
    Owner     = var.user_owner

  }
}
