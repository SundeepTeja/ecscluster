variable "tags" {
  type = map(string)
}

variable "meta" {
  type = map(string)
}
locals {
  account_id    = var.meta["account_id"]
  name_prefix   = var.meta["name_prefix"]
  region_name   = var.meta["region_name"]
}


variable "ecs_service_role" {}
variable "ecs_task_role_arn" {}
variable "ecs_execution_role_arn" {}
variable "cpu" { type = string }
variable "memory" { type = string }
variable "dcc" { type = string }
variable "min_cc" { type = string }
variable "max_cc" { type = string }
variable "cloudwatch_log_group_arn" {}
variable "alb_tg_arn" {}
variable "private_subnet_ids" { type = list(string) }
variable "resource_label" { type = string }
variable "security_groups" { type = list(string) }