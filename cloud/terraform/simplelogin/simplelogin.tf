resource "aws_eip" "simplelogin" {
  instance = aws_instance.simplelogin.id
  domain   = "vpc"
}

resource "aws_instance" "simplelogin" {
  ami           = data.aws_ami.al2023-arm64.id
  instance_type = "t4g.small"
  key_name      = aws_key_pair.augustfeng.key_name

  vpc_security_group_ids = [aws_security_group.simplelogin.id]
  subnet_id              = aws_subnet.compute-1a.id

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

resource "aws_security_group" "simplelogin" {
  name   = "simplelogin"
  vpc_id = aws_vpc.compute.id
}

resource "aws_vpc_security_group_egress_rule" "simplelogin-all" {
  security_group_id = aws_security_group.simplelogin.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "simplelogin-ssh" {
  security_group_id = aws_security_group.simplelogin.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "simplelogin-smtp" {
  security_group_id = aws_security_group.simplelogin.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 25
  to_port           = 25
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "simplelogin-http" {
  // XXX: https://developers.cloudflare.com/fundamentals/concepts/cloudflare-ip-addresses/#allowlist-cloudflare-ip-addresses
  for_each = toset([
    "173.245.48.0/20",
    "103.21.244.0/22",
    "103.22.200.0/22",
    "103.31.4.0/22",
    "141.101.64.0/18",
    "108.162.192.0/18",
    "190.93.240.0/20",
    "188.114.96.0/20",
    "197.234.240.0/22",
    "198.41.128.0/17",
    "162.158.0.0/15",
    "104.16.0.0/13",
    "104.24.0.0/14",
    "172.64.0.0/13",
    "131.0.72.0/22"
  ])
  security_group_id = aws_security_group.simplelogin.id
  cidr_ipv4         = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_secretsmanager_secret" "simplelogin" {
  name = "simplelogin"
}

resource "aws_secretsmanager_secret_version" "simplelogin" {
  secret_id = aws_secretsmanager_secret.simplelogin.id
  secret_string = jsonencode({
    certificate   = cloudflare_origin_ca_certificate.simplelogin.certificate
    private_key   = tls_private_key.simplelogin.private_key_pem
    public_key    = tls_private_key.simplelogin.public_key_pem
    smtp_username = aws_iam_access_key.augustfeng-email-simplelogin.id
    smtp_password = aws_iam_access_key.augustfeng-email-simplelogin.ses_smtp_password_v4
  })
}

resource "aws_ses_domain_identity" "augustfeng-email" {
  domain = "augustfeng.email"
}

resource "aws_ses_domain_mail_from" "augustfeng-email" {
  domain           = aws_ses_domain_identity.augustfeng-email.domain
  mail_from_domain = format("bounce.%s", aws_ses_domain_identity.augustfeng-email.domain)
}

resource "aws_ses_domain_dkim" "augustfeng-email" {
  domain = aws_ses_domain_identity.augustfeng-email.domain
}

resource "aws_iam_user" "augustfeng-email-simplelogin" {
  name = "augustfeng-email-simplelogin"
}

resource "aws_iam_access_key" "augustfeng-email-simplelogin" {
  user = aws_iam_user.augustfeng-email-simplelogin.name
}

data "aws_iam_policy_document" "augustfeng-email-simplelogin" {
  statement {
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}

resource "aws_iam_user_policy" "augustfeng-email-simplelogin" {
  name   = "Application"
  user   = aws_iam_user.augustfeng-email-simplelogin.name
  policy = data.aws_iam_policy_document.augustfeng-email-simplelogin.json
}
