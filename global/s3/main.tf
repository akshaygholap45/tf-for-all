resource "aws_s3_bucket" "terraform_state" {
  bucket = "tf-for-all"
  # Prevents Accidental deletion of this bucket
  lifecycle {
    prevent_destroy = true
  }
}

# Buckeet versioning enable
resource "aws_s3_bucket_versioning" "version_enabling" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable Server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
# Block public access to S3 bucket
resource "aws_s3_bucket_public_access_block" "s3_block_public_access" {
  bucket = aws_s3_bucket.terraform_state.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

# AWS DynamoDB for locking
resource "aws_dynamodb_table" "terraform_state_locks" {
  name = "terraform-state-locking"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}