variable "cloudflare_zone_id" {
  type = string
}
variable "aws_key_pair_name" {
  type = string
}

variable "aws_vpc_ids" {
  type = object({
    compute = string
  })
}

variable "aws_subnet_ids" {
  type = object({
    a = string
    b = string
    d = string
  })
}
