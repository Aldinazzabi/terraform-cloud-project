output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = aws_subnet.app[*].id
}

output "db_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = aws_subnet.db[*].id
}
output "app_route_table_id" {
  description = "ID of the private app route table"
  value       = aws_route_table.app.id
}

output "db_route_table_id" {
  description = "ID of the private DB route table"
  value       = aws_route_table.db.id
}