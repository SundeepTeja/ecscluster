variable "tags" {
  type = map(string)
}

variable "meta" {
  type = map(string)
}
locals {
  account_id = var.meta["account_id"]
  name_prefix = var.meta["name_prefix"]
  region_name = var.meta["region_name"]
}
