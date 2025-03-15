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
  content = aws_eip.simple-login.public_ip
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "simplelogin-app-a" {
  zone_id = var.cloudflare_zone_ids.augustfeng-email
  name    = "app"
  content = aws_eip.simple-login.public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "simplelogin-mx" {
  zone_id  = var.cloudflare_zone_ids.augustfeng-email
  name     = "augustfeng.email"
  content  = "app.augustfeng.email"
  type     = "MX"
  priority = 10
}

resource "cloudflare_record" "simplelogin-dkim" {
  zone_id = var.cloudflare_zone_ids.augustfeng-email
  name    = "dkim._domainkey.augustfeng.email"
  content = format("v=DKIM1; k=rsa; p=%s", data.sops_file.simple-login.data["dkimKeyPubWithoutGuard"])
  type    = "TXT"
}

resource "cloudflare_record" "simplelogin-spf" {
  zone_id = var.cloudflare_zone_ids.augustfeng-email
  name    = "augustfeng.email"
  content = "v=spf1 mx ~all"
  type    = "TXT"
}

resource "cloudflare_record" "simplelogin-dmarc" {
  zone_id = var.cloudflare_zone_ids.augustfeng-email
  name    = "_dmarc.augustfeng.email"
  content = "v=DMARC1; p=quarantine; adkim=r; aspf=r"
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

resource "tls_private_key" "simple-login" {
  algorithm = "ED25519"
}

resource "tls_cert_request" "simple-login" {
  private_key_pem = tls_private_key.simple-login.private_key_pem
  subject {
    common_name = cloudflare_record.simplelogin-app-a.hostname
  }
}

resource "cloudflare_origin_ca_certificate" "simple-login" {
  csr                = tls_cert_request.simple-login.cert_request_pem
  hostnames          = [cloudflare_record.simplelogin-app-a.hostname]
  request_type       = "origin-ecc"
  requested_validity = 365
}
