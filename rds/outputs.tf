output "db_instance_address" {
  value = aws_db_instance.main.address
}

output "aws_security_group_id" {
  value = aws_security_group.db.id
}