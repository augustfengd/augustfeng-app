module "socks" {
  source            = "./socks"
  aws_key_pair_name = aws_key_pair.augustfeng.key_name
  aws_vpc_ids = {
    compute = aws_vpc.compute-ca-central-1.id
  }
  aws_subnet_ids = {
    a = aws_subnet.compute-ca-central-1a.id
    b = aws_subnet.compute-ca-central-1b.id
    d = aws_subnet.compute-ca-central-1d.id
  }
  providers = {
    aws = aws.ca-central-1
  }
}

resource "aws_vpc" "compute-ca-central-1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "compute"
  }
}

resource "aws_subnet" "compute-ca-central-1a" {
  vpc_id            = aws_vpc.compute-ca-central-1.id
  availability_zone = "ca-central-1a"
  cidr_block        = cidrsubnet(aws_vpc.compute-ca-central-1.cidr_block, 4, 0)
}

resource "aws_subnet" "compute-ca-central-1b" {
  vpc_id            = aws_vpc.compute-ca-central-1.id
  availability_zone = "ca-central-1b"
  cidr_block        = cidrsubnet(aws_vpc.compute-ca-central-1.cidr_block, 4, 1)
}

resource "aws_subnet" "compute-ca-central-1d" {
  vpc_id            = aws_vpc.compute-ca-central-1.id
  availability_zone = "ca-central-1d"
  cidr_block        = cidrsubnet(aws_vpc.compute-ca-central-1.cidr_block, 4, 2)
}

resource "aws_internet_gateway" "compute-ca-central-1" {
  vpc_id = aws_vpc.compute-ca-central-1.id
}

resource "aws_route_table" "compute-ca-central-1" {
  vpc_id = aws_vpc.compute-ca-central-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.compute-ca-central-1.id
  }
}

resource "aws_route_table_association" "compute-ca-central-1a" {
  subnet_id      = aws_subnet.compute-ca-central-1a.id
  route_table_id = aws_route_table.compute-ca-central-1.id
}

resource "aws_route_table_association" "compute-ca-central-1b" {
  subnet_id      = aws_subnet.compute-ca-central-1b.id
  route_table_id = aws_route_table.compute-ca-central-1.id
}

resource "aws_route_table_association" "compute-ca-central-1d" {
  subnet_id      = aws_subnet.compute-ca-central-1d.id
  route_table_id = aws_route_table.compute-ca-central-1.id
}
