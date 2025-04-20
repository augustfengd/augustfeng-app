resource "terraform_data" "aws-sesv2-put-account-details-production-access-enabled" {
  provisioner "local-exec" {
    command = "aws --region us-east-1 sesv2 put-account-details --production-access-enabled --mail-type TRANSACTIONAL --website-url https://augustfeng.email --additional-contact-email-addresses augustfeng@augustfeng.email --contact-language EN"
  }
}
