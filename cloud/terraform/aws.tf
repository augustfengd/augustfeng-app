data "aws_caller_identity" "default" {}

resource "aws_vpc" "compute" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "compute"
  }
}

resource "aws_subnet" "compute-1a" {
  vpc_id            = aws_vpc.compute.id
  availability_zone = "us-east-1a"
  cidr_block        = cidrsubnet(aws_vpc.compute.cidr_block, 4, 0)
}

resource "aws_subnet" "compute-1b" {
  vpc_id            = aws_vpc.compute.id
  availability_zone = "us-east-1b"
  cidr_block        = cidrsubnet(aws_vpc.compute.cidr_block, 4, 1)
}

resource "aws_subnet" "compute-1c" {
  vpc_id            = aws_vpc.compute.id
  availability_zone = "us-east-1c"
  cidr_block        = cidrsubnet(aws_vpc.compute.cidr_block, 4, 2)
}

resource "aws_subnet" "compute-1d" {
  vpc_id            = aws_vpc.compute.id
  availability_zone = "us-east-1d"
  cidr_block        = cidrsubnet(aws_vpc.compute.cidr_block, 4, 3)
}

resource "aws_subnet" "compute-1e" {
  vpc_id            = aws_vpc.compute.id
  availability_zone = "us-east-1e"
  cidr_block        = cidrsubnet(aws_vpc.compute.cidr_block, 4, 4)
}

resource "aws_subnet" "compute-1f" {
  vpc_id            = aws_vpc.compute.id
  availability_zone = "us-east-1f"
  cidr_block        = cidrsubnet(aws_vpc.compute.cidr_block, 4, 5)
}

resource "aws_internet_gateway" "compute" {
  vpc_id = aws_vpc.compute.id
}

resource "aws_route_table" "compute" {
  vpc_id = aws_vpc.compute.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.compute.id
  }
}

resource "aws_route_table_association" "compute-1a" {
  subnet_id      = aws_subnet.compute-1a.id
  route_table_id = aws_route_table.compute.id
}

resource "aws_route_table_association" "compute-1b" {
  subnet_id      = aws_subnet.compute-1b.id
  route_table_id = aws_route_table.compute.id
}

resource "aws_route_table_association" "compute-1c" {
  subnet_id      = aws_subnet.compute-1c.id
  route_table_id = aws_route_table.compute.id
}

resource "aws_route_table_association" "compute-1d" {
  subnet_id      = aws_subnet.compute-1d.id
  route_table_id = aws_route_table.compute.id
}

resource "aws_route_table_association" "compute-1e" {
  subnet_id      = aws_subnet.compute-1e.id
  route_table_id = aws_route_table.compute.id
}

resource "aws_route_table_association" "compute-1f" {
  subnet_id      = aws_subnet.compute-1f.id
  route_table_id = aws_route_table.compute.id
}

resource "aws_identitystore_user" "augustfengd" {
  identity_store_id = var.aws_identity_store_id

  display_name = "August Feng"
  user_name    = "augustfeng"

  name {
    given_name  = "August"
    family_name = "Feng"
  }

  emails {
    value = "augustfengd@gmail.com"
  }
}

resource "aws_ssoadmin_account_assignment" "augustfengd" {
  instance_arn       = var.aws_ssoadmin_instance_arn
  permission_set_arn = aws_ssoadmin_permission_set.AdministratorAccess.arn

  principal_id   = aws_identitystore_user.augustfengd.user_id
  principal_type = "USER"

  target_id   = data.aws_caller_identity.default.account_id
  target_type = "AWS_ACCOUNT"
}

resource "aws_ssoadmin_permission_set" "AdministratorAccess" {
  name         = "AdministratorAccess"
  instance_arn = var.aws_ssoadmin_instance_arn
}

resource "aws_ssoadmin_managed_policy_attachment" "AdministratorAccess" {
  depends_on = [aws_ssoadmin_account_assignment.augustfengd]

  instance_arn       = var.aws_ssoadmin_instance_arn
  managed_policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  permission_set_arn = aws_ssoadmin_permission_set.AdministratorAccess.arn
}

resource "aws_s3_bucket" "augustfengd" {
  bucket = "augustfengd"
}

resource "aws_s3_bucket" "augustfeng" {
  bucket = "augustfeng"
}

resource "aws_s3_bucket" "augustfeng-app" {
  bucket = "augustfeng-app"
}

data "aws_iam_policy_document" "augustfeng-app" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    actions = ["s3:GetObject"]

    resources = [format("%s/blog/*", aws_s3_bucket.augustfeng-app.arn)]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.blog-augustfeng-app.arn]
    }
  }
}


resource "aws_s3_bucket_policy" "augustfeng-app" {
  bucket = aws_s3_bucket.augustfeng-app.id
  policy = data.aws_iam_policy_document.augustfeng-app.json
}

import {
  id = "E1GWGT4WSSAVAQ"
  to = aws_cloudfront_origin_access_control.sigv4-always-s3
}

resource "aws_cloudfront_origin_access_control" "sigv4-always-s3" {
  name                              = "sigv4-always-s3"
  signing_protocol                  = "sigv4"
  signing_behavior                  = "always"
  origin_access_control_origin_type = "s3"
}

resource "aws_cloudfront_distribution" "blog-augustfeng-app" {
  origin {
    domain_name              = aws_s3_bucket.augustfeng-app.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.sigv4-always-s3.id
    origin_path              = "/blog"
    origin_id                = aws_s3_bucket.augustfeng-app.bucket_regional_domain_name
  }

  aliases = [aws_acm_certificate.blog_augustfeng_app.domain_name]

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"


  default_cache_behavior {
    compress               = true
    viewer_protocol_policy = "allow-all"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.augustfeng-app.bucket_regional_domain_name
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" // Managed-CachingOptimized

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.url-rewrite-single-page-apps.arn
    }
  }

  price_class = "PriceClass_All"

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.blog_augustfeng_app.certificate_arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_cloudfront_function" "url-rewrite-single-page-apps" {
  name    = "url-rewrite-single-page-apps"
  runtime = "cloudfront-js-2.0"
  code    = file("${path.module}/src/cloudfront_functions/url-rewrite-single-page-apps.js")
}

resource "cloudflare_record" "blog_augustfeng_app" {
  zone_id = var.cloudflare_zone_ids.augustfeng-app
  name    = "blog"
  type    = "CNAME"
  content = aws_cloudfront_distribution.blog-augustfeng-app.domain_name
  ttl     = 1
  proxied = true
}

resource "aws_acm_certificate" "blog_augustfeng_app" {
  domain_name       = "blog.augustfeng.app"
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "blog_augustfeng_app" {
  certificate_arn = aws_acm_certificate.blog_augustfeng_app.arn
}

resource "cloudflare_record" "blog_augustfeng_app-validation" {
  for_each = {
    for dvo in aws_acm_certificate.blog_augustfeng_app.domain_validation_options : dvo.domain_name => {
      resource_record_name  = dvo.resource_record_name
      resource_record_value = dvo.resource_record_value
      resource_record_type  = dvo.resource_record_type
    }
  }

  zone_id = var.cloudflare_zone_ids.augustfeng-app
  name    = each.value.resource_record_name
  content = each.value.resource_record_value
  type    = each.value.resource_record_type
}

resource "aws_iam_openid_connect_provider" "gha" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
  ]
}

data "aws_iam_policy_document" "gha-augustfeng-app-trust-policy" {
  statement {
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.gha.arn]
    }

    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:augustfengd/augustfeng-app:*"]
    }
  }
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.default.account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "gha" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.augustfeng-app.arn]
  }
  statement {
    actions   = ["s3:PutObject"]
    resources = [format("%s/*", aws_s3_bucket.augustfeng-app.arn)]
  }
}

resource "aws_iam_policy" "gha-augustfeng-app" {
  name   = "GitHubActionsAugustfengApp"
  policy = data.aws_iam_policy_document.gha.json
}

resource "aws_iam_role" "gha-augustfeng-app" {
  name               = "GitHubActionsAugustfengApp"
  assume_role_policy = data.aws_iam_policy_document.gha-augustfeng-app-trust-policy.json
}

resource "aws_iam_role_policy_attachment" "gha-augustfeng-app" {
  role       = aws_iam_role.gha-augustfeng-app.name
  policy_arn = aws_iam_policy.gha-augustfeng-app.arn
}

resource "aws_apigatewayv2_api" "whoami" {
  name          = "whoami"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "default" {
  api_id             = aws_apigatewayv2_api.whoami.id
  route_key          = "$default"
  authorization_type = "AWS_IAM"
  target             = format("integrations/%s", aws_apigatewayv2_integration.default.id)
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.whoami.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "default" {
  api_id                 = aws_apigatewayv2_api.whoami.id
  integration_type       = "AWS_PROXY"
  connection_type        = "INTERNET"
  payload_format_version = "2.0"
  integration_uri        = aws_lambda_function.id.invoke_arn
}


resource "aws_secretsmanager_secret" "github-app" {
  name = "github-app"
}

resource "aws_secretsmanager_secret_version" "github-app" {
  secret_id     = aws_secretsmanager_secret.github-app.id
  secret_string = data.sops_file.github-app.raw
}

data "aws_iam_policy_document" "augustfeng_app_id_trust_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "augustfeng_app_id_role" {
  name               = "AugustfengAppIdRole"
  assume_role_policy = data.aws_iam_policy_document.augustfeng_app_id_trust_policy.json
}

resource "aws_lambda_function" "id" {
  s3_bucket     = aws_s3_bucket.augustfeng-app.bucket
  s3_key        = "lambdas/id.zip"
  function_name = "id"
  role          = aws_iam_role.augustfeng_app_id_role.arn
  handler       = "id::id.Function::FunctionHandler"

  runtime = "dotnet8"
}

resource "aws_key_pair" "augustfeng" {
  key_name   = "augustfeng"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO8uyj9CjbNOSW/fkR2sAcif52NwDv/2Cu9BTRVHO0bO augustfeng"
}

resource "aws_eip" "simple-login" {
  instance = aws_instance.simple-login.id
  domain   = "vpc"
}

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

data "aws_ami" "al2023-ecs-arm64" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-2023.*"]
  }
}

resource "aws_instance" "simple-login" {
  ami           = data.aws_ami.al2023-arm64.id
  instance_type = "t4g.small"
  key_name      = aws_key_pair.augustfeng.key_name

  vpc_security_group_ids = [aws_security_group.simple-login.id]
  subnet_id              = aws_subnet.compute-1a.id

  root_block_device {
    encrypted   = true
    volume_size = 16
  }

  instance_market_options {
    market_type = "spot"
    spot_options {
      instance_interruption_behavior = "hibernate"
      spot_instance_type             = "persistent"
    }
  }
}

resource "aws_security_group" "simple-login" {
  name   = "simple-login"
  vpc_id = aws_vpc.compute.id
}

resource "aws_vpc_security_group_egress_rule" "simple-login-all" {
  security_group_id = aws_security_group.simple-login.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "simple-login-ssh" {
  security_group_id = aws_security_group.simple-login.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "simple-login-http" {
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
  security_group_id = aws_security_group.simple-login.id
  cidr_ipv4         = each.value
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_secretsmanager_secret" "simple-login" {
  name = "simple-login"
}

resource "aws_secretsmanager_secret_version" "simple-login" {
  secret_id = aws_secretsmanager_secret.simple-login.id
  secret_string = jsonencode({
    certificate   = cloudflare_origin_ca_certificate.simple-login.certificate
    private_key   = tls_private_key.simple-login.private_key_pem
    public_key    = tls_private_key.simple-login.public_key_pem
    smtp_username = aws_iam_access_key.augustfeng-email.name
    smtp_password = aws_iam_access_key.augustfeng-email.ses_smtp_password_v4
  })
}

resource "terraform_data" "aws-sesv2-put-account-details-production-access-enabled" {
  provisioner "local-exec" {
    command = "aws --region us-east-1 sesv2 put-account-details --production-access-enabled --mail-type TRANSACTIONAL --website-url https://augustfeng.email --additional-contact-email-addresses augustfeng@augustfeng.email --contact-language EN"
  }
}

resource "aws_ses_domain_identity" "augustfeng-email" {
  domain = "augustfeng.email"
}

resource "aws_ses_domain_dkim" "augustfeng-email" {
  domain = aws_ses_domain_identity.augustfeng-email.domain
}

resource "aws_iam_user" "augustfeng-email-simplelogin" {
  name = "augustfeng-email-simplelogin"
}

resource "aws_iam_access_key" "augustfeng-email" {
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
  policy = data.aws_iam_policy_document.augustfeng-email-simplelogin
}
