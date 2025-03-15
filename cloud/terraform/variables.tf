variable "aws_ssoadmin_instance_arn" {
  type = string
}

variable "aws_identity_store_id" {
  type = string
}


variable "cloudflare_zone_ids" {
  type = object({
    augustfeng-app   = string
    practicing-app   = string
    augustfeng-email = string
  })
}
