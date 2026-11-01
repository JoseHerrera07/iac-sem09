resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name_prefix}-cache-subnets"
  subnet_ids = var.data_subnet_ids

  tags = {
    Name = "${var.name_prefix}-cache-subnets"
  }
}

resource "aws_elasticache_replication_group" "this" {
  replication_group_id = "${var.name_prefix}-redis"
  description          = "Redis para bloqueo de asientos y cache"

  engine               = "redis"
  engine_version       = "7.1"
  parameter_group_name = "default.redis7"
  node_type            = var.node_type
  port                 = 6379

  num_cache_clusters         = var.num_nodes
  automatic_failover_enabled = var.num_nodes > 1
  multi_az_enabled           = var.num_nodes > 1

  subnet_group_name  = aws_elasticache_subnet_group.this.name
  security_group_ids = [var.security_group_id]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  apply_immediately          = true

  tags = {
    Name = "${var.name_prefix}-redis"
  }
}
