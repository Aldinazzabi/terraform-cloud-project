terraform {
  backend "s3" {
    bucket       = "cloud-project-tfstate-201679117202"
    key          = "prod/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
data "aws_caller_identity" "current" {}
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

module "network" {
  source = "../../modules/network"

  project_name        = var.project_name
  environment         = var.environment
  owner               = var.owner
  availability_zones  = var.availability_zones
  vpc_cidr            = "10.20.0.0/16"
  public_subnet_cidrs = ["10.20.1.0/24", "10.20.2.0/24"]
  app_subnet_cidrs    = ["10.20.11.0/24", "10.20.12.0/24"]
  db_subnet_cidrs     = ["10.20.21.0/24", "10.20.22.0/24"]
}
module "security" {
  source = "../../modules/security"

  vpc_id       = module.network.vpc_id
  project_name = var.project_name
  environment  = var.environment
  db_port      = 5432
}
module "endpoints" {
  source = "../../modules/endpoints"

  vpc_id                         = module.network.vpc_id
  project_name                   = var.project_name
  environment                    = var.environment
  aws_region                     = var.aws_region
  app_subnet_ids                 = module.network.app_subnet_ids
  app_route_table_id             = module.network.app_route_table_id
  db_route_table_id              = module.network.db_route_table_id
  ecr_endpoint_security_group_id = module.security.ecr_endpoint_security_group_id
}

module "database" {
  source = "../../modules/database"

  project_name         = var.project_name
  environment          = var.environment
  db_subnet_ids        = module.network.db_subnet_ids
  db_security_group_id = module.security.db_security_group_id
  db_password          = var.db_password
  db_instance_class    = "db.t3.micro"
  db_allocated_storage = 20
}
module "load_balancer" {
  source = "../../modules/load-balancer"

  project_name          = var.project_name
  environment           = var.environment
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  alb_security_group_id = module.security.alb_security_group_id
  target_port           = 80
  health_check_path     = "/"
}
module "compute" {
  source = "../../modules/compute"

  project_name          = var.project_name
  environment           = var.environment
  app_subnet_ids        = module.network.app_subnet_ids
  app_security_group_id = module.security.app_security_group_id
  instance_profile_name = "LabInstanceProfile"
  target_group_arn      = module.load_balancer.target_group_arn
  instance_type         = "t3.micro"
  min_size              = 2
  max_size              = 4
  desired_capacity      = 2
  aws_region            = var.aws_region
  aws_account_id        = data.aws_caller_identity.current.account_id
  ecr_repo_name         = "cloud-project-dev-app"
  docker_image_tag      = "latest"
}
module "storage" {
  source = "../../modules/storage"

  bucket_name = "${var.project_name}-${var.environment}-storage-${data.aws_caller_identity.current.account_id}"
  tags        = local.common_tags
}