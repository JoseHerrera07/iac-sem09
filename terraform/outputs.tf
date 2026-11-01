output "vpc_id" {
  description = "ID de la VPC."
  value       = module.network.vpc_id
}

output "alb_dns_name" {
  description = "DNS publico del Application Load Balancer."
  value       = module.alb.dns_name
}

output "asg_name" {
  description = "Nombre del Auto Scaling Group de la API."
  value       = module.compute.asg_name
}

output "db_endpoint" {
  description = "Endpoint de RDS PostgreSQL."
  value       = module.database.endpoint
}

output "db_secret_arn" {
  description = "ARN del secreto de Secrets Manager con la contrasena de la BD."
  value       = module.database.master_user_secret_arn
}
