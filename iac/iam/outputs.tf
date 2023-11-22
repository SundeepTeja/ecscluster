output "iam_role_arn" {
  value       = aws_iam_role.role.arn
}

output "iam_role_name" {
  value       = aws_iam_role.role.name
}

output "iam_instance_profile_arn" {
  value       = aws_iam_instance_profile.profile.arn
}

output "iam_instance_profile_name" {
  value       = aws_iam_instance_profile.profile.name
}