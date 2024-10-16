// access list for public subnets

resource "aws_network_acl" "rs-task2-public_acl" {
  vpc_id = aws_vpc.TFvpc.id

  tags = {
    Terraform = true
    Name      = "rs-task2-public_acl"
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
}

resource "aws_network_acl_association" "public_acl_assoc_a" {
  subnet_id      = aws_subnet.TFpublic-a.id
  network_acl_id = aws_network_acl.rs-task2-public_acl.id
}

resource "aws_network_acl_association" "public_acl_assoc_b" {
  subnet_id      = aws_subnet.TFpublic-b.id
  network_acl_id = aws_network_acl.rs-task2-public_acl.id
}
