# State bucket for Pulsewatch.
# Created with local state first, then we migrate the state into it.

# Get the account ID to keep the bucket name unique.
# It's hardcoded in versions.tf because backend config can't use expressions.
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "tfstate" {
  bucket = "pulsewatch-tfstate-${data.aws_caller_identity.current.account_id}"

  # Don't let Terraform destroy the bucket holding its own state.
  lifecycle {
    prevent_destroy = true
  }
}

# Keep older state versions in case we need to recover one.
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

# State can hold sensitive values, so set encryption explicitly.
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access. The state bucket should stay private.
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}