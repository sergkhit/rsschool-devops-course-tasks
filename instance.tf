resource "aws_instance" "rs-task2-web_server-a" {
  ami           = var.ec2_ubuntu_ami
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.TFpublic-a.id
  security_groups = [aws_security_group.rs-task2-public.id]
  associate_public_ip_address = true 

  tags = {
    Terraform = true
    Project   = var.project
    Name = "rs-task2-web_server-a"
  }
}

resource "aws_instance" "rs-task2-database_server-a" {
  ami           = var.ec2_ubuntu_ami
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.TFprivate-a.id
  security_groups = [aws_security_group.rs-task2-private.id]
  
  tags = {
    Terraform = true
    Project   = var.project
    Name = "database-server-a"
  }
}

resource "aws_instance" "rs-task2-web_server-b" {
  ami           = var.ec2_ubuntu_ami
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.TFpublic-b.id
  security_groups = [aws_security_group.rs-task2-public.id]
  associate_public_ip_address = true 

  tags = {
    Terraform = true
    Project   = var.project
    Name = "rs-task2-web_server-b"
  }
}

resource "aws_instance" "rs-task2-database_server-b" {
  ami           = var.ec2_ubuntu_ami
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.TFprivate-b.id
  security_groups = [aws_security_group.rs-task2-private.id]

  tags = {
    Terraform = true
    Project   = var.project
    Name = "database-server-b"
  }
}

output "web_server_a_public_ip" {
  description = "public ip from web server a"
  value       = aws_instance.rs-task2-web_server-a.public_ip
}

output "web_server_a_private_ip" {
  description = "private ip from web server a"
  value       = aws_instance.rs-task2-web_server-a.private_ip
}

output "database_server_a_private_ip" {
  description = "private ip from database server a"
  value       = aws_instance.rs-task2-database_server-a.private_ip
}

output "web_server_b_public_ip" {
  description = "public ip from web server b"
  value       = aws_instance.rs-task2-web_server-b.public_ip
}

output "web_server_b_private_ip" {
  description = "private ip from web server b"
  value       = aws_instance.rs-task2-web_server-a.private_ip
}

output "database_server_b_private_ip" {
  description = "private ip from database server a"
  value       = aws_instance.rs-task2-database_server-b.private_ip
}