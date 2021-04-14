
variable "name" {
  type = string
  description = "(optional) describe your variable"
}
variable "azs" {
  description = "Availability zones of VPC"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "family" {
  type = string
}

variable "cluster_size" {
  type = number
}
variable "instance_type" {
  type = string
}

variable "environment" {
  type = string
}
variable "region" {
  type = string
}