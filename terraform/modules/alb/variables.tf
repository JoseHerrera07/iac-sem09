variable "name_prefix" {
  description = "Prefijo para nombrar los recursos."
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC."
  type        = string
}

variable "public_subnet_ids" {
  description = "Subredes publicas donde vive el ALB."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group del ALB."
  type        = string
}
