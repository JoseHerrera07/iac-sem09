variable "name_prefix" {
  description = "Prefijo para nombrar los recursos."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR de la VPC."
  type        = string
}

variable "azs" {
  description = "Zonas de disponibilidad a usar (2)."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs de las subredes publicas."
  type        = list(string)
}

variable "app_subnet_cidrs" {
  description = "CIDRs de las subredes privadas de aplicacion."
  type        = list(string)
}

variable "data_subnet_cidrs" {
  description = "CIDRs de las subredes privadas de datos."
  type        = list(string)
}
