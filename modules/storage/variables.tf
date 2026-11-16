variable "bucket_name" {
  description = "Globally unique name for the application storage bucket"
  type        = string
}

variable "tags" {
  description = "Tags applied to the storage bucket"
  type        = map(string)
  default     = {}
}