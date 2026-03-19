# Grupo de subnets
resource "aws_elasticache_subnet_group" "main" {
  name       = "feast-cache-subnet"
  subnet_ids = [var.subnet_id]
}

# Redis simple
resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "feast-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1

  subnet_group_name = aws_elasticache_subnet_group.main.name
}