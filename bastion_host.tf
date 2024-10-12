resource "aws_instance" "rs-task2-bastion_host" {
  ami           = var.ec2_ubuntu_ami
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.TFpublic-a.id
  security_groups = [aws_security_group.rs-task2-ssh_inbound.id]
  key_name      = aws_key_pair.rs-task2-tf-ssh-key.key_name
  associate_public_ip_address = true 

  tags = {
    Terraform = "true"
    Project   = var.project
    Owner     = var.user_owner
    Name = "rs-task2-bastion-host"
    
  }
}