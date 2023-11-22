output "sg_alb_id" {
  value       = aws_security_group.alb.id
}

output "sg_ecs_id" {
  value       = aws_security_group.ecs.id
}