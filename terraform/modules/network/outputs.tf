output "vpc_id" {
  description = "ID de la VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs de las subredes publicas."
  value       = aws_subnet.public[*].id
}

output "app_subnet_ids" {
  description = "IDs de las subredes privadas de aplicacion."
  value       = aws_subnet.app[*].id
}

output "data_subnet_ids" {
  description = "IDs de las subredes privadas de datos."
  value       = aws_subnet.data[*].id
}
