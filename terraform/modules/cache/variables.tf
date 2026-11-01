variable "name_prefix" {
  description = "Prefijo para nombrar los recursos."
  type        = string
}

variable "data_subnet_ids" {
  description = "Subredes privadas de datos."
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group de Redis."
  type        = string
}

variable "node_type" {
  description = "Tipo de nodo de ElastiCache."
  type        = string
}

variable "num_nodes" {
  description = "Cantidad de nodos (1 = primario, 2 = primario + replica)."
  type        = number
}
