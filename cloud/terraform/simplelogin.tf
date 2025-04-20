module "simplelogin" {
  source = "./simplelogin"
}

moved {
  from = aws_eip.simplelogin
  to   = module.simplelogin.aws_eip.simplelogin
}

moved {
  from = aws_instance.simplelogin
  to   = module.simplelogin.aws_instance.simplelogin
}

moved {
  from = aws_security_group.simplelogin
  to   = module.simplelogin.aws_security_group.simplelogin
}

moved {
  from = aws_vpc_security_group_egress_rule.simplelogin-all
  to   = module.simplelogin.aws_vpc_security_group_egress_rule.simplelogin-all
}

moved {
  from = aws_vpc_security_group_ingress_rule.simplelogin-ssh
  to   = module.simplelogin.aws_vpc_security_group_ingress_rule.simplelogin-ssh
}

moved {
  from = aws_vpc_security_group_ingress_rule.simplelogin-smtp
  to   = module.simplelogin.aws_vpc_security_group_ingress_rule.simplelogin-smtp
}

moved {
  from = aws_vpc_security_group_ingress_rule.simplelogin-http
  to   = module.simplelogin.aws_vpc_security_group_ingress_rule.simplelogin-http
}

moved {
  from = aws_secretsmanager_secret.simplelogin
  to   = module.simplelogin.aws_secretsmanager_secret.simplelogin
}

moved {
  from = aws_secretsmanager_secret_version.simplelogin
  to   = module.simplelogin.aws_secretsmanager_secret_version.simplelogin
}

moved {
  from = terraform_data.aws-sesv2-put-account-details-production-access-enabled
  to   = module.simplelogin.terraform_data.aws-sesv2-put-account-details-production-access-enabled
}

moved {
  from = aws_ses_domain_identity.augustfeng-email
  to   = module.simplelogin.aws_ses_domain_identity.augustfeng-email
}

moved {
  from = aws_ses_domain_mail_from.augustfeng-email
  to   = module.simplelogin.aws_ses_domain_mail_from.augustfeng-email
}

moved {
  from = aws_ses_domain_dkim.augustfeng-email
  to   = module.simplelogin.aws_ses_domain_dkim.augustfeng-email
}

moved {
  from = aws_iam_user.augustfeng-email-simplelogin
  to   = module.simplelogin.aws_iam_user.augustfeng-email-simplelogin
}

moved {
  from = aws_iam_access_key.augustfeng-email-simplelogin
  to   = module.simplelogin.aws_iam_access_key.augustfeng-email-simplelogin
}

moved {
  from = data.aws_iam_policy_document.augustfeng-email-simplelogin
  to   = module.simplelogin.data.aws_iam_policy_document.augustfeng-email-simplelogin
}

moved {
  from = aws_iam_user_policy.augustfeng-email-simplelogin
  to   = module.simplelogin.aws_iam_user_policy.augustfeng-email-simplelogin
}
