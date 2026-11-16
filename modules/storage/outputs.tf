output "bucket_name" {
  description = "Name of the application storage bucket"
  value       = var.bucket_name
}

output "bucket_arn" {
  description = "ARN of the application storage bucket"
  value       = "arn:aws:s3:::${var.bucket_name}"
}