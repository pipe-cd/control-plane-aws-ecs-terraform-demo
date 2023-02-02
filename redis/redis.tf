resource "aws_elasticache_cluster" "main" {
  availability_zone        = "ap-northeast-1a"
  az_mode                  = "single-az"
  cluster_id               = var.project
  engine                   = "redis"
  engine_version           = "5.0.0"
  maintenance_window       = "mon:18:30-mon:19:30"
  node_type                = var.node_type
  num_cache_nodes          = "1"
  parameter_group_name     = "default.redis5.0"
  port                     = "6379"
  security_group_ids       = [aws_security_group.redis.id]
  depends_on               = [aws_security_group.redis]
  snapshot_retention_limit = "0"
  snapshot_window          = "17:00-18:00"
  subnet_group_name        = var.redis_subnet_group_name
  tags                     = var.tags
}