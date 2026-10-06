# ---------- networking ----------

module "networking" {
  source = "../../modules/networking"

  name     = "pulsewatch"
  vpc_cidr = "10.0.0.0/16"
  azs      = ["eu-west-2a", "eu-west-2b"]

  public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  private_db_subnet_cidrs  = ["10.0.21.0/24", "10.0.22.0/24"]
}

# ---------- security groups ----------

module "security_groups" {
  source = "../../modules/security-groups"

  name   = "pulsewatch"
  vpc_id = module.networking.vpc_id
}

# ---------- acr ----------

module "ecr" {
  source = "../../modules/ecr"

  name         = "pulsewatch"
  force_delete = true
}

# ---------- acm ----------

module "acm" {
  source = "../../modules/acm"

  zone_name   = "karimothman.co.uk"
  domain_name = "pulsewatch.karimothman.co.uk"
}


# ---------- ALB ----------

module "alb" {
  source = "../../modules/alb"

  name              = "pulsewatch"
  environment       = "production"
  vpc_id            = module.networking.vpc_id
  public_subnet_ids = module.networking.public_subnet_ids
  alb_sg_id         = module.security_groups.alb_sg_id
  certificate_arn   = module.acm.certificate_arn
  zone_id           = module.acm.zone_id
  domain_name       = "pulsewatch.karimothman.co.uk"
}

# ---------- RDS ----------

module "rds" {
  source = "../../modules/rds"

  name                  = "pulsewatch"
  db_name               = "pulsewatch"
  username              = "pulsewatch"
  private_db_subnet_ids = module.networking.private_db_subnet_ids
  rds_sg_id             = module.security_groups.rds_sg_id
}