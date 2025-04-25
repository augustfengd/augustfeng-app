resource "cloudflare_record" "socks" {
  zone_id = var.cloudflare_zone_id
  name    = "socks.augustfeng.app"
  content = aws_eip.socks.public_ip
  type    = "A"
  proxied = false
}

resource "aws_eip" "socks" {
  instance = aws_instance.socks.id
  domain   = "vpc"
}
