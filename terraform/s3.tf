### s3.tf

// s3.tf

# Creates an Amazon s3 bucket
resource "aws_s3_bucket" "tf_s3_state" {
  bucket        = var.bucket_name
  force_destroy = true
}

# Enables versioning for s3 bucket
resource "aws_s3_bucket_versioning" "tf_s3_state_versioning" {
  bucket = aws_s3_bucket.tf_s3_state.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

# Configures server-side encryption for s3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_s3_state_encryption" {
  bucket = aws_s3_bucket.tf_s3_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

### s3.tf
# # Store Terraform state in a versioned S3 bucket with server-side encryption.
# resource "aws_s3_bucket" "tf_s3_state" {
#   bucket        = var.bucket_name
#   versioning_configuration {
#     status = "Enabled"
#   }
# }


