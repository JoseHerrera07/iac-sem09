variable "name_prefix" {
  description = "Prefijo para nombrar los recursos."
  type        = string
}

variable "data_subnet_ids" {
  description = "Subredes privadas de datos."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group de RDS."
  type        = string
}

variable "instance_class" {
  description = "Clase de instancia de RDS."
  type        = string
}

variable "multi_az" {
  description = "Activa Multi-AZ."
  type        = bool
}

variable "backup_retention_period" {
  description = "Dias de retencion de respaldos automaticos."
  type        = number
  default     = 1
}
