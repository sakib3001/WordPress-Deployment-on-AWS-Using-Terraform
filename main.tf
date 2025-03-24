provider "aws" {
  region              = var.region
  shared_config_files = [var.shared_config_files_path]
}

module "networking" {
  source = "./modules/networking"
  region = var.region
}

module "sg" {
  source = "./modules/security-groups"
  vpc_id = module.networking.vpc_id
}

module "compute" {
  source             = "./modules/compute"
  wp-server-sg       = module.sg.wp-server-sg-id
  jumpbox-sg         = module.sg.jumpbox-sg-id
  public_subnet_id   = module.networking.public_subnet_ids[1]
  private_subnet_ids = module.networking.private_subnet_ids
}

module "alb" {
  source          = "./modules/load-balancing"
  vpc_id          = module.networking.vpc_id
  security_groups = module.sg.alb-sg-id
  subnets         = module.networking.public_subnet_ids
  target_ids      = module.compute.wp-tg-ids
}

module "rds-mysql" {
  source = "./modules/database"
  vpc_security_group_ids = module.sg.rds-sg-id
  db_password = "ndksjd6Djkdwryu90"
  subnet_ids = module.networking.private_subnet_ids
}