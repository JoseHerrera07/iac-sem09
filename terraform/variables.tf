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
