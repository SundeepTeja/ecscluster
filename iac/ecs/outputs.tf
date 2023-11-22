output "ecs_cluster_id" {
  value       = aws_ecs_cluster.cluster.id
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.cluster.name
}

output "ecs_service_name_tutorplus-grafana" {
  value       = aws_ecs_service.ecs_service.name
}
