resource "cloudflare_record" "simplelogin" {
  zone_id = var.cloudflare_zone_id
  name    = "augustfeng.email"
  content = aws_eip.simplelogin.public_ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "simplelogin-app-a" {
  zone_id = var.cloudflare_zone_id
  name    = "app.augustfeng.email"
  content = aws_eip.simplelogin.public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "simplelogin-mx" {
  zone_id  = var.cloudflare_zone_id
  name     = "augustfeng.email"
  content  = "augustfeng.email"
  type     = "MX"
  priority = 10
}

resource "cloudflare_record" "simplelogin-amazonses" {
  zone_id = var.cloudflare_zone_id
  name    = "_amazonses.augustfeng.email"
  content = format("\"%s\"", aws_ses_domain_identity.augustfeng-email.verification_token) # XXX: this was added after the domain identity was verified; i'm curious.
  type    = "TXT"
}

resource "cloudflare_record" "simplelogin-dkim" {
  count   = 3
  zone_id = var.cloudflare_zone_id
  name    = "${aws_ses_domain_dkim.augustfeng-email.dkim_tokens[count.index]}._domainkey"
  content = "${aws_ses_domain_dkim.augustfeng-email.dkim_tokens[count.index]}.dkim.amazonses.com"
  type    = "CNAME"
}

resource "cloudflare_record" "simplelogin-spf" {
  zone_id = var.cloudflare_zone_id
  name    = "augustfeng.email"
  content = format("\"%s\"", "v=spf1 include:amazonses.com ~all")
  type    = "TXT"
}

resource "cloudflare_record" "simplelogin-bounce-mx" {
  zone_id  = var.cloudflare_zone_id
  name     = "bounce.augustfeng.email"
  content  = "feedback-smtp.us-east-1.amazonses.com"
  type     = "MX"
  priority = 10
}

resource "cloudflare_record" "simplelogin-bounce-spf" {
  zone_id = var.cloudflare_zone_id
  name    = "bounce.augustfeng.email"
  content = format("\"%s\"", "v=spf1 include:amazonses.com ~all")
  type    = "TXT"
}

resource "cloudflare_record" "simplelogin-dmarc" {
  zone_id = var.cloudflare_zone_id
  name    = "_dmarc.augustfeng.email"
  content = format("\"%s\"", "v=DMARC1; p=reject; adkim=s; aspf=r")
  type    = "TXT"
}

resource "tls_private_key" "simplelogin" {
  algorithm = "ED25519"
}

resource "tls_cert_request" "simplelogin" {
  private_key_pem = tls_private_key.simplelogin.private_key_pem
  subject {
    common_name = cloudflare_record.simplelogin-app-a.hostname
  }
}

resource "cloudflare_origin_ca_certificate" "simplelogin" {
  csr                = tls_cert_request.simplelogin.cert_request_pem
  hostnames          = [cloudflare_record.simplelogin-app-a.hostname]
  request_type       = "origin-ecc"
  requested_validity = 365
}
