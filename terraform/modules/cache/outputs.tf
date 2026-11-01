output "primary_endpoint" {
  description = "Endpoint primario de Redis."
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}
