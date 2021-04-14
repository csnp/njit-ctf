variable "tags" {
  description = "Tags to add to all instances"
  default     = {}
  type        = map(string)
}
variable "region" {
  description = "region to use"
  default     = "us-east-1"
}
variable "environment" {
  type        = string
  description = "app environment"
}
variable "db_identifier" {
  type = string
}
variable "instance_size" {
  type = string
}
variable "storage_gb" {
  type = number
}
variable "encrypted_storage" {
  type = bool
}
variable "deletion_protection" {
  type = bool
}