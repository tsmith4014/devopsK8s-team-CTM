# ### backend.tf
# # For managing the Terraform state effectively telling terraform where to store the Terraform State
# terraform {
#   backend "s3" {
#     bucket         = "shredder-bucket"
#     # key            = "path/to/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "tf_state_lock"
#   }
# }

# # Backend TF does not allow the use of variables, had to add in actual values. 