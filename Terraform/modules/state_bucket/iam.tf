data "aws_caller_identity" "current" {
}

locals {
  aws_identifier = {
    type        = "AWS"
    identifiers = length(var.terraformAllowedUsers) == 0 ? ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"] : var.terraformAllowedUsers
  }
}

resource "aws_iam_policy" "terraform" {
  name_prefix = "terraformPolicy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.state.arn}"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "${aws_s3_bucket.state.arn}/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "${aws_dynamodb_table.lock.arn}"
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:ListKeys"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

# Terraform policy document
data "aws_iam_policy_document" "terraform" {
  statement {
    actions = ["sts:AssumeRole"]
    dynamic "principals" {
      for_each = list(local.aws_identifier)
      content {
        type        = principals.value["type"]
        identifiers = principals.value["identifiers"]
      }
    }
    effect = "Allow"
  }
}

# Terraform role boundary 
data "aws_iam_policy_document" "terraform_boundary" {
  statement {
    actions   = var.terraformBoundaryAllowed
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_policy" "terraform_boundary" {
  name_prefix = "terraformBoundaryPolicy"

  policy = data.aws_iam_policy_document.terraform_boundary.json
}

# create terraform role and attach policy
resource "aws_iam_role" "terraform" {
  name = "terraformUser"

  force_detach_policies = true
  permissions_boundary  = aws_iam_policy.terraform_boundary.arn
  assume_role_policy    = data.aws_iam_policy_document.terraform.json
}

resource "aws_iam_role_policy_attachment" "terraform" {
  role       = aws_iam_role.terraform.name
  policy_arn = aws_iam_policy.terraform.arn
}