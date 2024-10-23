resource "aws_instance" "rs-task-bastion_host" {
  ami                         = var.ec2_ubuntu_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.TFpublic-a.id
  security_groups             = [aws_security_group.rs-task-bastion.id]
  key_name                    = aws_key_pair.rs-task-tf-ssh-key.key_name
  associate_public_ip_address = true

  tags = {
    Terraform = "true"
    Project   = var.project
    Owner     = var.user_owner
    Name      = "rs-task-bastion-host"
  }
}