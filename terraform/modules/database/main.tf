resource "aws_db_subnet_group" "this" {
  name       = "${var.name_prefix}-db-subnets"
  subnet_ids = var.data_subnet_ids

  tags = {
    Name = "${var.name_prefix}-db-subnets"
  }
}

resource "aws_db_instance" "this" {
  identifier     = "${var.name_prefix}-db"
  engine         = "postgres"
  engine_version = "16"
  instance_class = var.instance_class

  allocated_storage = 20
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = "transandes"
  username = "transandes_admin"

  # La contrasena la genera y rota AWS en Secrets Manager (no se guarda en el codigo)
  manage_master_user_password = true

  multi_az               = var.multi_az
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.security_group_id]
  publicly_accessible    = false

  backup_retention_period    = var.backup_retention_period
  auto_minor_version_upgrade = true

  # Valores de laboratorio: permiten destruir sin pedir snapshot final
  deletion_protection = false
  skip_final_snapshot = true

  tags = {
    Name = "${var.name_prefix}-db"
  }
}
