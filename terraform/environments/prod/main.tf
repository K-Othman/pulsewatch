module "networking" {
  source = "../../modules/networking"

  name     = "pulsewatch"
  vpc_cidr = "10.0.0.0/16"
  azs      = ["eu-west-2a", "eu-west-2b"]

  public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  private_db_subnet_cidrs  = ["10.0.21.0/24", "10.0.22.0/24"]
}

module "security_groups" {
  source = "../../modules/security-groups"

  name   = "pulsewatch"
  vpc_id = module.networking.vpc_id
}

module "ecr" {
  source = "../../modules/ecr"

  name         = "pulsewatch"
  force_delete = true
}


module "acm" {
  source = "../../modules/acm"

  zone_name   = "karimothman.co.uk"
  domain_name = "pulsewatch.karimothman.co.uk"
}