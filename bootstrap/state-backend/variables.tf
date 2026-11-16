variable "aws_region" {
  description = "AWS region for the state bucket"
  type        = string
}

variable "project_name" {
  description = "Project identifier"
  type        = string
}

variable "state_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform state"
  type        = string
}