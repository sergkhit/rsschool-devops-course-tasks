resource "aws_instance" "rs-task2-public_server-a" {
  ami                         = var.ec2_ubuntu_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.TFpublic-a.id
  security_groups             = [aws_security_group.rs-task2-public.id]
  key_name                    = aws_key_pair.rs-task2-tf-ssh-key.key_name
  associate_public_ip_address = true

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task2-web_server-a"
  }
}

resource "aws_instance" "rs-task2-private_server-a" {
  ami             = var.ec2_ubuntu_ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.TFprivate-a.id
  security_groups = [aws_security_group.rs-task2-private.id]
  key_name        = aws_key_pair.rs-task2-tf-ssh-key.key_name

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "database-server-a"
  }
}

resource "aws_instance" "rs-task2-public_server-b" {
  ami                         = var.ec2_ubuntu_ami
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.TFpublic-b.id
  security_groups             = [aws_security_group.rs-task2-public.id]
  key_name                    = aws_key_pair.rs-task2-tf-ssh-key.key_name
  associate_public_ip_address = true

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task2-web_server-b"
  }
}

resource "aws_instance" "rs-task2-private_server-b" {
  ami             = var.ec2_ubuntu_ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.TFprivate-b.id
  security_groups = [aws_security_group.rs-task2-private.id]
  key_name        = aws_key_pair.rs-task2-tf-ssh-key.key_name

  tags = {
    Terraform = true
    Project   = var.project
    Name      = "database-server-b"
  }
}
