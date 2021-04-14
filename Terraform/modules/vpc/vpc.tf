module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.namespace
  cidr = var.cidr_block

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_s3_endpoint       = true
  s3_endpoint_policy = <<POLICY
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "s3:ResourceAccount": "${data.aws_caller_identity.current.account_id}"
        }
      }
    },
    {
      "Sid": "Access-to-ecs",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": [
        "arn:aws:s3:::prod-us-east-1-starport-layer-bucket/*"
      ]
    },
    {
      "Sid": "Access-to-repos",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "*",
      "Resource": [
          "arn:aws:s3:::*.amazonaws.com",
          "arn:aws:s3:::*.amazonaws.com/*"
      ]
    }
  ]
}
POLICY
  enable_dynamodb_endpoint = true
  

  public_dedicated_network_acl = true
  public_inbound_acl_rules = concat(
    local.network_acls["public_inbound"]
  )
  public_outbound_acl_rules = concat(
    local.network_acls["public_outbound"]
  )
  private_inbound_acl_rules = concat(
    local.network_acls["private_inbound"]
  )
  private_outbound_acl_rules = concat(
    local.network_acls["private_outbound"]
  )
  private_dedicated_network_acl = true

  tags = {
    Environment = var.environment
  }

  public_subnet_tags = {
    Tier = "public"
  }

  private_subnet_tags = {
    Tier = "private"
  }
}