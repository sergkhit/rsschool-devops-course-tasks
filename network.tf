resource "aws_vpc" "TFvpc" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"
  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task2-vpc"
  }
}

resource "aws_subnet" "TFpublic-a" {
  vpc_id            = aws_vpc.TFvpc.id
  cidr_block        = "10.10.1.0/24"
  availability_zone = var.avail_zone
  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task2-subnet-public-a"
  }
}

resource "aws_subnet" "TFpublic-b" {
  vpc_id            = aws_vpc.TFvpc.id
  cidr_block        = "10.10.3.0/24"
  availability_zone = var.avail_zone
  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task2-subnet-public-b"
  }
}

resource "aws_subnet" "TFpublic-c" {
  vpc_id            = aws_vpc.TFvpc.id
  cidr_block        = "10.10.5.0/24"
  availability_zone = var.avail_zone
  tags = {
    Terraform = true
    Project   = var.project
    Name      = "rs-task2-subnet-public-c"
  }
}

// Similar resources for public_subnet_b and public_subnet_c

resource "aws_internet_gateway" "TFgw" {
  vpc_id = aws_vpc.TFvpc.id
  tags = {
    Name      = "rs-task2-igw"
    Terraform = true
    Project   = var.project
  }
}

resource "aws_route_table" "TFrt" {
  vpc_id = aws_vpc.TFvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.TFgw.id
  }
  tags = {
    Name      = "rs-task2-rt"
    Terraform = true
    Project   = var.project
  }
}

