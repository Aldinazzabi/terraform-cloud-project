locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "Terraform"
  }
}

module "ecr" {
  source = "../../modules/ecr"

  repository_name      = "${var.project_name}-${var.environment}-app"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
}