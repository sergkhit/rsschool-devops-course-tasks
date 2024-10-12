resource "aws_instance" "rs-task2-web_server-a" {
  ami           = "ami-005fc0f236362e99f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.TFpublic-a.id
  security_groups = [aws_security_group.rs-task2-public.id]

  tags = {
    Terraform = true
    Project   = var.project
    Name = "rs-task2-web_server-a"
  }
}

resource "aws_instance" "rs-task2-database_server-a" {
  ami           = "ami-005fc0f236362e99f"
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
  ami           = "ami-005fc0f236362e99f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.TFpublic-b.id
  security_groups = [aws_security_group.rs-task2-public.id]

  tags = {
    Terraform = true
    Project   = var.project
    Name = "rs-task2-web_server-b"
  }
}

resource "aws_instance" "rs-task2-database_server-b" {
  ami           = "ami-005fc0f236362e99f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.TFprivate-b.id
  security_groups = [aws_security_group.rs-task2-private.id]

  tags = {
    Terraform = true
    Project   = var.project
    Name = "database-server-b"
  }
}
