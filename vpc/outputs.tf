output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_private_a_id" {
  value = aws_subnet.private_a.id
}

output "subnet_private_c_id" {
  value = aws_subnet.private_c.id
}

output "subnet_private_d_id" {
  value = aws_subnet.private_d.id
}

output "subnet_public_a_id" {
  value = aws_subnet.public_a.id
}

output "subnet_public_c_id" {
  value = aws_subnet.public_c.id
}

output "subnet_public_d_id" {
  value = aws_subnet.public_d.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.main.name
}
output "redis_subnet_group_name" {
  value = aws_elasticache_subnet_group.main.name
}