### providers.tf
# Specifies which region and which AWS account to deploy to
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

# Ensures AWS will be used
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

# # EC2 instance resource that references an existing key pair
# resource "aws_instance" "my_instance" {
#   ami           = var.ami_id
#   instance_type = var.instance_type
#   key_name      = var.ssh_key_name  # Use the name of an existing key pair
