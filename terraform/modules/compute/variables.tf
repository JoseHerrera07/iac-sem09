variable "name_prefix" {
  description = "Prefijo para nombrar los recursos."
  type        = string
}

variable "app_subnet_ids" {
  description = "Subredes privadas de aplicacion donde corren las EC2."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group de las instancias."
  type        = string
}

variable "target_group_arn" {
  description = "Target group del ALB al que se registran las instancias."
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2."
  type        = string
}

variable "min_size" {
  description = "Minimo de instancias."
  type        = number
}

variable "max_size" {
  description = "Maximo de instancias."
  type        = number
}

variable "desired_capacity" {
  description = "Instancias deseadas al crear el grupo."
  type        = number
}
