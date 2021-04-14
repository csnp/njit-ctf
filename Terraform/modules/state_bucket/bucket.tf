resource "aws_s3_bucket" "state" {
  bucket_prefix = var.state_bucket_prefix
  acl           = "private"
  force_destroy = false

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  # expire non current versions after 5 days
  lifecycle_rule {
    enabled = true
    noncurrent_version_expiration {
      days = 5
    }
  }

  tags = var.tags
}

# Block all public access via policy
resource "aws_s3_bucket_public_access_block" "state" {
  bucket = aws_s3_bucket.state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}