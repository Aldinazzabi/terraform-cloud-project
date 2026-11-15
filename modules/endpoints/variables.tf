variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region for endpoint service names"
  type        = string
}

variable "app_subnet_ids" {
  description = "IDs of the private application subnets"
  type        = list(string)

  validation {
    condition     = length(var.app_subnet_ids) == 2
    error_message = "Exactly two application subnet IDs must be provided."
  }
}

variable "app_route_table_id" {
  description = "ID of the private app route table (for S3 Gateway Endpoint)"
  type        = string
}

variable "db_route_table_id" {
  description = "ID of the private DB route table (for S3 Gateway Endpoint)"
  type        = string
}

variable "ecr_endpoint_security_group_id" {
  description = "Security group ID for the ECR interface endpoints"
  type        = string
}