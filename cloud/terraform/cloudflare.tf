resource "cloudflare_record" "aws" {
  zone_id = var.cloudflare_zone_ids.augustfeng-app
  name    = "awsapps"
  content = "192.0.2.1" // https://developers.cloudflare.com/rules/page-rules/#page-rules-require-proxied-dns-records
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "simplelogin" {
  zone_id = var.cloudflare_zone_ids.augustfeng-email
  name    = "augustfeng.email"
  content = aws_eip.simplelogin.public_ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "simplelogin-app-a" {
  zone_id = var.cloudflare_zone_ids.augustfeng-email
  name    = "app.augustfeng.email"
  content = aws_eip.simplelogin.public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "simplelogin-mx" {
  zone_id  = var.cloudflare_zone_ids.augustfeng-email
  name     = "augustfeng.email"
  content  = "augustfeng.email"
  type     = "MX"
  priority = 10
}

resource "cloudflare_record" "simplelogin-amazonses" {
  zone_id = var.cloudflare_zone_ids.augustfeng-email
  name    = "_amazonses.augustfeng.email"
  content = aws_ses_domain_identity.augustfeng-email.verification_token # XXX: this was added after the domain identity was verified; i'm curious.
  type    = "TXT"
}

resource "cloudflare_record" "simplelogin-dkim" {
  count   = 3
  zone_id = var.cloudflare_zone_ids.augustfeng-email
  name    = "${aws_ses_domain_dkim.augustfeng-email.dkim_tokens[count.index]}._domainkey"
  content = "${aws_ses_domain_dkim.augustfeng-email.dkim_tokens[count.index]}.dkim.amazonses.com"
  type    = "CNAME"
}

resource "cloudflare_record" "simplelogin-spf" {
  zone_id = var.cloudflare_zone_ids.augustfeng-email
  name    = "augustfeng.email"
  content = "v=spf1 include:amazonses.com ~all"
  type    = "TXT"
}

resource "cloudflare_record" "simplelogin-dmarc" {
  zone_id = var.cloudflare_zone_ids.augustfeng-email
  name    = "_dmarc.augustfeng.email"
  content = "v=DMARC1; p=reject; adkim=s; aspf=s"
  type    = "TXT"
}

resource "cloudflare_ruleset" "single_redirects" {
  zone_id     = var.cloudflare_zone_ids.augustfeng-app
  name        = "redirects"
  description = "Redirects ruleset"
  kind        = "zone"
  phase       = "http_request_dynamic_redirect"

  rules {
    description = "Redirect from awsapps.augustfeng.app to AWS access portal"
    expression  = "(http.host eq \"awsapps.augustfeng.app\")"
    action      = "redirect"
    action_parameters {
      from_value {
        status_code = 301
        target_url {
          value = format("https://%s.awsapps.com/start", var.aws_identity_store_id)
        }
      }
    }
  }
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
