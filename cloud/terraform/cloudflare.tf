resource "cloudflare_record" "aws" {
  zone_id = var.cloudflare_zone_ids.augustfeng-app
  name    = "awsapps"
  content = "192.0.2.1" // https://developers.cloudflare.com/rules/page-rules/#page-rules-require-proxied-dns-records
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "simplelogin-a" {
  zone_id = var.cloudflare_zone_ids.augustfeng-email
  name    = "app"
  content = aws_eip.simple-login.public_ip
  type    = "A"
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
