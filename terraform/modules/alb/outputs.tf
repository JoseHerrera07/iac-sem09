output "dns_name" {
  description = "DNS publico del ALB."
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "ARN del target group de la API."
  value       = aws_lb_target_group.api.arn
}
