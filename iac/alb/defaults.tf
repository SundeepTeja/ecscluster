variable "tags" {
  type = map(string)
}

variable "meta" {
  type = map(string)
}
locals {
  account_id = var.meta["account_id"]
  name_prefix = var.meta["name_prefix"]
}


variable "security_groups" { type = list(string) }
variable "public_subnet_ids" { type = list(string) }
variable "alb_certificate_arn" {}
variable "vpc_id" {}