variable "region" {
  description = "aws region"
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment to deploy into"
}

variable "namespace" {
  description = "Organization name or abbreviation"
}

variable "cidr_block" {
  description = "CIDR block to be used for the VPC"
}

variable "public_subnets" {
  description = "List of public subnets for VPC"
}

variable "private_subnets" {
  description = "List of private subnets for VPC"
}

variable "azs" {
  description = "Availability zones of VPC"
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
