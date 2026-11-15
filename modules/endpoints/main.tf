# -----------------------------------------------------------------------------
# ECR API interface endpoint
# -----------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.app_subnet_ids
  security_group_ids  = [var.ecr_endpoint_security_group_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-ecr-api-endpoint"
  }
}

# -----------------------------------------------------------------------------
# ECR Docker interface endpoint
# -----------------------------------------------------------------------------
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.app_subnet_ids
  security_group_ids  = [var.ecr_endpoint_security_group_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-${var.environment}-ecr-dkr-endpoint"
  }
}

# -----------------------------------------------------------------------------
# S3 Gateway endpoint (free, used by ECR for image layers)
# -----------------------------------------------------------------------------
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [var.app_route_table_id, var.db_route_table_id]

  tags = {
    Name = "${var.project_name}-${var.environment}-s3-endpoint"
  }
}