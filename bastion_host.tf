resource "aws_instance" "rs-task2-bastion_host" {
  ami           = "ami-03883344111111111"
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