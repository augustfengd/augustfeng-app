module "socks" {
  source             = "./socks"
  cloudflare_zone_id = var.cloudflare_zone_ids.augustfeng-app
  aws_key_pair_name  = aws_key_pair.augustfeng-ca-central-1.key_name
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

resource "aws_key_pair" "augustfeng-ca-central-1" {
  provider   = aws.ca-central-1
  key_name   = "augustfeng"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8uyj9CjbNOSW/fkR2sAcif52NwDv/2Cu9BTRVHO0bO augustfeng"
}

resource "aws_vpc" "compute-ca-central-1" {
  provider             = aws.ca-central-1
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "compute"
  }
}

resource "aws_subnet" "compute-ca-central-1a" {
  provider          = aws.ca-central-1
  vpc_id            = aws_vpc.compute-ca-central-1.id
  availability_zone = "ca-central-1a"
  cidr_block        = cidrsubnet(aws_vpc.compute-ca-central-1.cidr_block, 4, 0)
}

resource "aws_subnet" "compute-ca-central-1b" {
  provider          = aws.ca-central-1
  vpc_id            = aws_vpc.compute-ca-central-1.id
  availability_zone = "ca-central-1b"
  cidr_block        = cidrsubnet(aws_vpc.compute-ca-central-1.cidr_block, 4, 1)
}

resource "aws_subnet" "compute-ca-central-1d" {
  provider          = aws.ca-central-1
  vpc_id            = aws_vpc.compute-ca-central-1.id
  availability_zone = "ca-central-1d"
  cidr_block        = cidrsubnet(aws_vpc.compute-ca-central-1.cidr_block, 4, 2)
}

resource "aws_internet_gateway" "compute-ca-central-1" {
  provider = aws.ca-central-1
  vpc_id   = aws_vpc.compute-ca-central-1.id
}

resource "aws_route_table" "compute-ca-central-1" {
  provider = aws.ca-central-1
  vpc_id   = aws_vpc.compute-ca-central-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.compute-ca-central-1.id
  }
}

resource "aws_route_table_association" "compute-ca-central-1a" {
  provider       = aws.ca-central-1
  subnet_id      = aws_subnet.compute-ca-central-1a.id
  route_table_id = aws_route_table.compute-ca-central-1.id
}

resource "aws_route_table_association" "compute-ca-central-1b" {
  provider       = aws.ca-central-1
  subnet_id      = aws_subnet.compute-ca-central-1b.id
  route_table_id = aws_route_table.compute-ca-central-1.id
}

resource "aws_route_table_association" "compute-ca-central-1d" {
  provider       = aws.ca-central-1
  subnet_id      = aws_subnet.compute-ca-central-1d.id
  route_table_id = aws_route_table.compute-ca-central-1.id
}
