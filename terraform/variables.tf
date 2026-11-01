variable "aws_region" {
  description = "Region de AWS donde se crean todos los recursos."
  type        = string
  default     = "us-east-2"
}

variable "project" {
  description = "Prefijo del laboratorio."
  type        = string
  default     = "lab09"
}

variable "environment" {
  description = "Nombre del entorno."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR de la VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs de las subredes publicas (ALB y NAT), una por zona."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "app_subnet_cidrs" {
  description = "CIDRs de las subredes privadas de aplicacion, una por zona."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "data_subnet_cidrs" {
  description = "CIDRs de las subredes privadas de datos, una por zona."
  type        = list(string)
  default     = ["10.0.21.0/24", "10.0.22.0/24"]
}

variable "instance_type" {
  description = "Tipo de instancia EC2 de la API."
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Minimo de instancias del Auto Scaling Group."
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Maximo de instancias del Auto Scaling Group."
  type        = number
  default     = 6
}

variable "asg_desired_capacity" {
  description = "Instancias deseadas al crear el Auto Scaling Group."
  type        = number
  default     = 2
}

variable "db_instance_class" {
  description = "Clase de instancia de RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "db_multi_az" {
  description = "Activa Multi-AZ en RDS (false en dev para ahorrar costo)."
  type        = bool
  default     = false
}
