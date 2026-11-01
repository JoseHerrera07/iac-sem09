output "endpoint" {
  description = "Endpoint de conexion de RDS."
  value       = aws_db_instance.this.endpoint
}

output "master_user_secret_arn" {
  description = "ARN del secreto con las credenciales del usuario administrador."
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}
