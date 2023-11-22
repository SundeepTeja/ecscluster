output "alb_domain_name" {
  value       = aws_lb.alb.dns_name
}

output "alb_hosted_zone_id" {
  value       = aws_lb.alb.zone_id
}

output "alb_arn" {
  value       = aws_lb.alb.arn
}

output "alb_arn_suffix" {
  value       = aws_lb.alb.arn_suffix
}

output "alb_tg_arn" {
  value       = aws_lb_target_group.tg.arn
}

output "alb_tg_arn_suffix" {
  value       = aws_lb_target_group.tg.arn_suffix
}