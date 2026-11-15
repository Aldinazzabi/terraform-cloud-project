variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the two public subnets"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) == 2
    error_message = "Exactly two public subnet IDs must be provided."
  }
}

variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "target_port" {
  description = "Port the app instances listen on"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Path for the target group health check"
  type        = string
  default     = "/"
}