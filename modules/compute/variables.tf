variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "app_subnet_ids" {
  description = "IDs of the two private application subnets"
  type        = list(string)

  validation {
    condition     = length(var.app_subnet_ids) == 2
    error_message = "Exactly two application subnet IDs must be provided."
  }
}

variable "app_security_group_id" {
  description = "Security group ID for the app instances"
  type        = string
}

variable "instance_profile_name" {
  description = "IAM instance profile name for EC2"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "aws_region" {
  description = "AWS region (used in user_data ECR login)"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID (used in user_data ECR login)"
  type        = string
}

variable "ecr_repo_name" {
  description = "ECR repository name"
  type        = string
}

variable "docker_image_tag" {
  description = "Docker image tag to pull"
  type        = string
  default     = "latest"
}