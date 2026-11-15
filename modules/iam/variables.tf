variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID (used in ECR and OIDC trust policies)"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository in format owner/repo (e.g. alaa/terraform-cloud-project)"
  type        = string
}