resource "aws_security_group_rule" "redis_from_server" {
  security_group_id        = var.redis_security_group_id
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.server.id
  description              = "Managed by Terraform"
}

resource "aws_security_group_rule" "redis_from_ops" {
  security_group_id        = var.redis_security_group_id
  type                     = "ingress"
  from_port                = 6379
  to_port                  = 6379
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ops.id
  description              = "Managed by Terraform"
}