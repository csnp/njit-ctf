region = "us-east-1"
dynamodb_table_name = "state"
state_bucket_prefix = "ctf"
tags = {
  Source = "Terraform"
  Owner = "ACM CTF"
}
terraformAllowedUsers = []
terraformBoundaryAllowed = ["s3:*", "rds:*", "ecs:*", "dynamodb:*", "iam:*"]