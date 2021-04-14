variable "dynamodb_table_name" {
  description = "Name of dynamo table for state"
}

variable "tags" {
  description = "Tags to add to all instances"
  default     = {}
  type        = map(string)
}

variable "region" {
  description = "region to use"
  default     = "us-east-1"
}


variable "terraformAllowedUsers" {
  description = "List of ARNs which are allowed to assume the terraform role."
  type        = list(string)
  default     = []
}
#todo: restrict IAM more
variable "terraformBoundaryAllowed" {
  description = "list of AWS actions Terraform role is allowed to do"
  type        = set(string)
  default     = []
}
variable "state_bucket_prefix" {
  description = "name of state bucket"
}
