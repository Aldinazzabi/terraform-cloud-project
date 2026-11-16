output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.network.public_subnet_ids
}

output "app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = module.network.app_subnet_ids
}

output "db_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = module.network.db_subnet_ids
}
output "alb_security_group_id" {
  description = "ID of the ALB security group"
  value       = module.security.alb_security_group_id
}

output "app_security_group_id" {
  description = "ID of the application security group"
  value       = module.security.app_security_group_id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = module.security.db_security_group_id
}

output "ecr_endpoint_security_group_id" {
  description = "ID of the ECR endpoint security group"
  value       = module.security.ecr_endpoint_security_group_id
}
output "app_route_table_id" {
  description = "ID of the private app route table"
  value       = module.network.app_route_table_id
}

output "db_route_table_id" {
  description = "ID of the private DB route table"
  value       = module.network.db_route_table_id
}

output "ecr_api_endpoint_id" {
  description = "ID of the ECR API VPC endpoint"
  value       = module.endpoints.ecr_api_endpoint_id
}

output "ecr_dkr_endpoint_id" {
  description = "ID of the ECR Docker VPC endpoint"
  value       = module.endpoints.ecr_dkr_endpoint_id
}

output "s3_endpoint_id" {
  description = "ID of the S3 Gateway VPC endpoint"
  value       = module.endpoints.s3_endpoint_id
}
output "db_endpoint" {
  description = "RDS connection endpoint"
  value       = module.database.db_endpoint
  sensitive   = true
}

output "db_port" {
  description = "RDS port"
  value       = module.database.db_port
}
output "alb_dns_name" {
  description = "Public DNS name of the ALB"
  value       = module.load_balancer.alb_dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = module.load_balancer.target_group_arn
}
output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.compute.asg_name
}
output "storage_bucket_name" {
  description = "Name of the application storage bucket"
  value       = module.storage.bucket_name
}