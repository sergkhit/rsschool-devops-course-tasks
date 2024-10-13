resource "aws_vpc" "TFvpc" {
  cidr_block       = "10.20.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy = "default"
  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task2-vpc"
  }
}

resource "aws_subnet" "TFpublic-a" {
  vpc_id            = aws_vpc.TFvpc.id
  cidr_block        = "10.20.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task2-subnet-public-a"
  }
}

resource "aws_subnet" "TFpublic-b" {
  vpc_id            = aws_vpc.TFvpc.id
  cidr_block        = "10.20.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task2-subnet-public-b"
  }
}

resource "aws_subnet" "TFprivate-a" {
  vpc_id            = aws_vpc.TFvpc.id
  cidr_block        = "10.20.102.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task2-subnet-private-a"
  }
}

resource "aws_subnet" "TFprivate-b" {
  vpc_id            = aws_vpc.TFvpc.id
  cidr_block        = "10.20.104.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task2-subnet-private-b"
  }
}

// Similar resources for public_subnet

resource "aws_internet_gateway" "TFgw" {
  vpc_id = aws_vpc.TFvpc.id
  tags = {
    Name      = "rs-task2-igw"
    Terraform = true
    Project   = var.project
  }
}

resource "aws_route_table" "TF_rt_public" {
  vpc_id = aws_vpc.TFvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.TFgw.id
  }
  tags = {
    Name      = "rs-task2-rt-public"
    Terraform = true
    Project   = var.project
  }
}

// route table to the public subnets with the terraform resource called aws_route_table_association.

resource "aws_route_table_association" "TF_rta_public_a" {
  subnet_id      = aws_subnet.TFpublic-a.id
  route_table_id = aws_route_table.TF_rt_public.id
}
resource "aws_route_table_association" "TF_rta_public_b" {
  subnet_id      = aws_subnet.TFpublic-b.id
  route_table_id = aws_route_table.TF_rt_public.id
}

// Similar resources for private_subnet

resource "aws_eip" "TF_eip" {
  domain = "vpc"
  tags = {
    Name      = "rs-task2-TF-eip"
    Terraform = true
    Project   = var.project
  }
}

resource "aws_nat_gateway" "TF_nat_gw" {
  allocation_id = aws_eip.TF_eip.id
  subnet_id     = aws_subnet.TFpublic-a.id
  tags = {
    Name      = "rs-task2-TF-nat-gw"
    Terraform = true
    Project   = var.project
  }
}


// route table to the private subnets with the terraform resource called aws_route_table_association.


resource "aws_route_table" "TF_rt_private" {
  vpc_id = aws_vpc.TFvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.TF_nat_gw.id
  }
  tags = {
    Name      = "rs-task2-rt-private"
    Terraform = true
    Project   = var.project
  }
}



resource "aws_route_table_association" "TF_rta_private_1" {
  subnet_id      = aws_subnet.TFprivate-a.id
  route_table_id = aws_route_table.TF_rt_private.id
}
resource "aws_route_table_association" "TF_rta_private_2" {
  subnet_id      = aws_subnet.TFprivate-b.id
  route_table_id = aws_route_table.TF_rt_private.id
}
