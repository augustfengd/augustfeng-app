data "aws_ami" "al2023-arm64" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*"]
  }
}

resource "aws_instance" "socks" {
  ami           = data.aws_ami.al2023-arm64.id
  instance_type = "t4g.small"
  key_name      = var.aws_key_pair_name

  vpc_security_group_ids = [aws_security_group.socks.id]
  subnet_id              = var.aws_subnet_ids.a

  root_block_device {
    encrypted   = true
    volume_size = 16
  }

  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "stop"
      spot_instance_type             = "persistent"
    }
  }
}

resource "aws_security_group" "socks" {
  name   = "socks"
  vpc_id = var.aws_vpc_ids.compute
}

resource "aws_vpc_security_group_egress_rule" "socks-all" {
  security_group_id = aws_security_group.socks.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "socks-ssh" {
  security_group_id = aws_security_group.socks.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "socks-socks" {
  security_group_id = aws_security_group.socks.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 1080
  to_port           = 1080
  ip_protocol       = "tcp"
}
