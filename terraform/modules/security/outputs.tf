output "alb_security_group_id" {
  description = "ID del security group del ALB."
  value       = aws_security_group.alb.id
}

output "app_security_group_id" {
  description = "ID del security group de la API."
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "ID del security group de RDS."
  value       = aws_security_group.db.id
}

output "cache_security_group_id" {
  description = "ID del security group de Redis."
  value       = aws_security_group.cache.id
}
