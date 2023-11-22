output "vpc_id" {
  value       = aws_vpc.assignment_vpc.id
}

output "vpc_cidr" {
  value       = aws_vpc.assignment_vpc.cidr_block
  
}
output "public_subnet_ids" {
  value       = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  value       = aws_subnet.private_subnet[*].id
}