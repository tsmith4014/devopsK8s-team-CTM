### dynamod.tf

# dynamod.tf
# Use DynamoDB for Terraform state locking to ensure consistency in resource provisioning.
resource "aws_dynamodb_table" "tf_state_lock" {
  name     = var.dynamodb_name
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"  # Keep this line, remove any duplicates
}



