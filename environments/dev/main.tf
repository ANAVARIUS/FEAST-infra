provider "aws" {
  region = var.region
}

locals {
  environment = "dev"
}

# =========================
# NETWORKING
# =========================
module "networking" {
  source      = "../../modules/networking"
  environment = local.environment
}

# =========================
# DATABASE
# =========================
module "database" {
  source     = "../../modules/database"

  db_name    = var.db_name
  username   = var.db_user
  password   = var.db_password

  subnet_id  = module.networking.private_subnet_id
}

# =========================
# CACHE (Redis)
# =========================
module "cache" {
  source    = "../../modules/cache"
  subnet_id = module.networking.private_subnet_id
}

# =========================
# SEARCH (OpenSearch)
# =========================
module "search" {
  source      = "../../modules/search"
  environment = local.environment
}

# =========================
# MESSAGING (SQS)
# =========================
module "messaging" {
  source      = "../../modules/messaging"
  environment = local.environment
}

# =========================
# COMPUTE (ECS)
# =========================
module "compute" {
  source = "../../modules/compute"

  environment     = local.environment
  # Se recomienda mover el cómputo a la subred privada por seguridad
  subnet_id       = module.networking.private_subnet_id
  vpc_id          = module.networking.vpc_id

  container_image  = "nginx" # Placeholder para demo
  target_group_arn  = module.api.target_group_arn
}

# =========================
# API (ALB)
# =========================
module "api" {
  source = "../../modules/api_gateway"

  vpc_id    = module.networking.vpc_id
  subnet_id = module.networking.public_subnet_id
}