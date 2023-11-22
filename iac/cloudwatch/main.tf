resource "aws_cloudwatch_log_group" "log_group" {
  name                    = "${local.name_prefix}-logs"
  retention_in_days       = 90
  tags                    = merge(var.tags)
}