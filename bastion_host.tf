resource "aws_instance" "rs-task2-bastion_host" {
  ami           = "ami-005fc0f236362e99f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.TFpublic-a.id
  security_groups = [aws_security_group.rs-task2-ssh_inbound.id]

  tags = {
    Terraform = "true"
    Project   = var.project
    Owner     = var.user_owner
    Name = "rs-task2-bastion-host"
    
  }
}