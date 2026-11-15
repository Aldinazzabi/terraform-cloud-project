variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, test, prod)"
  type        = string
}

variable "db_subnet_ids" {
  description = "IDs of the two private database subnets"
  type        = list(string)

  validation {
    condition     = length(var.db_subnet_ids) == 2
    error_message = "Exactly two database subnet IDs must be provided."
  }
}

variable "db_security_group_id" {
  description = "Security group ID for the database"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Master password for the database (must be provided via tfvars, never committed)"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}