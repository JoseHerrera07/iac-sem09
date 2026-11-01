output "vpc_id" {
  description = "ID de la VPC."
  value       = module.network.vpc_id
}

output "alb_dns_name" {
  description = "DNS publico del Application Load Balancer."
  value       = module.alb.dns_name
}
