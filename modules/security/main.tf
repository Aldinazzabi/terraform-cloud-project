# -----------------------------------------------------------------------------
# Security groups
# -----------------------------------------------------------------------------
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "ALB security group - public HTTP ingress"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

resource "aws_security_group" "app" {
  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Application security group - traffic only from ALB"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-app-sg"
  }
}

resource "aws_security_group" "db" {
  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "Database security group - traffic only from App"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-db-sg"
  }
}

resource "aws_security_group" "ecr_endpoint" {
  name        = "${var.project_name}-${var.environment}-ecr-endpoint-sg"
  description = "ECR endpoint security group - HTTPS from App only"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-ecr-endpoint-sg"
  }
}

# -----------------------------------------------------------------------------
# ALB rules
# -----------------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "alb_http_from_internet" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP from Internet"
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_app_http" {
  security_group_id            = aws_security_group.alb.id
  description                  = "Allow HTTP to App SG"
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.app.id
}

# -----------------------------------------------------------------------------
# App rules
# -----------------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "app_http_from_alb" {
  security_group_id            = aws_security_group.app.id
  description                  = "Allow HTTP from ALB SG"
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
  referenced_security_group_id = aws_security_group.alb.id
}

resource "aws_vpc_security_group_egress_rule" "app_to_db" {
  security_group_id            = aws_security_group.app.id
  description                  = "Allow DB port to DB SG"
  ip_protocol                  = "tcp"
  from_port                    = var.db_port
  to_port                      = var.db_port
  referenced_security_group_id = aws_security_group.db.id
}

resource "aws_vpc_security_group_egress_rule" "app_to_ecr_https" {
  security_group_id            = aws_security_group.app.id
  description                  = "Allow HTTPS to ECR endpoint SG"
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = aws_security_group.ecr_endpoint.id
}

# -----------------------------------------------------------------------------
# DB rules
# -----------------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id            = aws_security_group.db.id
  description                  = "Allow DB port from App SG"
  ip_protocol                  = "tcp"
  from_port                    = var.db_port
  to_port                      = var.db_port
  referenced_security_group_id = aws_security_group.app.id
}

# -----------------------------------------------------------------------------
# ECR endpoint rules
# -----------------------------------------------------------------------------
resource "aws_vpc_security_group_ingress_rule" "ecr_https_from_app" {
  security_group_id            = aws_security_group.ecr_endpoint.id
  description                  = "Allow HTTPS from App SG"
  ip_protocol                  = "tcp"
  from_port                    = 443
  to_port                      = 443
  referenced_security_group_id = aws_security_group.app.id
}