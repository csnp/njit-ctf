Creates Terraform role with policy, state bucket and dynamo

This is a chicken vs egg problem with creating TF state bucket in Terraform, so typically the state file for the bucket is checked in or you upload it into the state bucket after creating it