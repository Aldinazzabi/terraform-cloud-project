variable "project_name" {
  description = "Project name used for naming and tagging resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid CIDR block."
  }
}

variable "availability_zones" {
  description = "Two Availability Zones for the subnets"
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "Exactly two Availability Zones must be provided."
  }
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the two public subnets"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Exactly two public subnet CIDRs must be provided."
  }
}

variable "app_subnet_cidrs" {
  description = "CIDR blocks for the two private application subnets"
  type        = list(string)

  validation {
    condition     = length(var.app_subnet_cidrs) == 2
    error_message = "Exactly two application subnet CIDRs must be provided."
  }
}

variable "db_subnet_cidrs" {
  description = "CIDR blocks for the two private database subnets"
  type        = list(string)

  validation {
    condition     = length(var.db_subnet_cidrs) == 2
    error_message = "Exactly two database subnet CIDRs must be provided."
  }
}