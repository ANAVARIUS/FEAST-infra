# Grupo de subnets para RDS (aunque solo tengamos una por ahora)
resource "aws_db_subnet_group" "main" {
  name       = "feast-db-subnet"
  subnet_ids = [var.subnet_id]
}

# Instancia MariaDB en RDS
resource "aws_db_instance" "main" {
  allocated_storage    = 20
  engine               = "mariadb"
  engine_version       = "10.6"
  instance_class       = "db.t3.micro"

  db_name              = var.db_name
  username             = var.username
  password             = var.password

  db_subnet_group_name = aws_db_subnet_group.main.name

  skip_final_snapshot  = true

  tags = {
    Name = "feast-db"
  }
}