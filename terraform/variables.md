# variables.tf
# Defining variables for reusable and configurable values.
# provided by Chat.GPT 1 pm 10/08/2024
# Provider Variables
variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Specifies which AWS account to deploy infrastructure."
  type        = string
  default     = "Cassandra"  # Modify as needed
}

# VPC and Subnet Variables
variable "internet_cidr_block" {
  description = "CIDR block for internet access."
  type        = string
  default     = "0.0.0.0/0"
}

variable "map_public_ip_on_launch" {
  description = "Whether to assign a public IP to instances in the subnet."
  type        = bool
  default     = true
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
  default     = "10.0.2.0/24"
}

variable "availability_zone_1" {
  description = "Availability zone for the public subnet."
  type        = string
  default     = "us-east-1a"
}

variable "availability_zone_2" {
  description = "Availability zone for the private subnet."
  type        = string
  default     = "us-east-1b"
}

# EKS Cluster Variables
variable "eks_cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
  default     = "shredder-cluster"
}

variable "eks_node_group_name" {
  description = "Name of the EKS node group."
  type        = string
  default     = "shredder-node-group"
}

# IAM Role for EKS Cluster
variable "eks_role_name" {
  description = "Name of the IAM role for the EKS cluster."
  type        = string
  default     = "shredder-eks-role"
}

variable "eks_role_policy_arns" {
  description = "List of policy ARNs to attach to the IAM role for the EKS cluster."
  type        = list(string)
  default     = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
}

# IAM Role for EKS Worker Nodes
variable "eks_node_role_name" {
  description = "Name of the IAM role for EKS worker nodes."
  type        = string
  default     = "eks-node-role"
}

variable "eks_node_role_policy_arns" {
  description = "List of policy ARNs to attach to the IAM role for EKS worker nodes."
  type        = list(string)
  default     = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

# Scaling configuration for EKS worker nodes
variable "desired_size" {
  description = "Desired number of EKS nodes."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of EKS nodes."
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of EKS nodes."
  type        = number
  default     = 1
}

# Custom IAM Policies for Autoscaling and EBS
variable "cluster_autoscaler_policy_arns" {
  description = "ARNs for custom IAM policies used for EKS Cluster Autoscaler."
  type        = list(string)
  default     = []
}

variable "cluster_ebs_policy_arns" {
  description = "ARNs for custom IAM policies used for EBS management."
  type        = list(string)
  default     = []
}

# Lambda Execution Role
variable "lambda_execution_role_name" {
  description = "Name of the IAM role for Lambda execution."
  type        = string
  default     = "rds_snapshot_lambda_role"
}

# EC2 Instance Variables
variable "instance_type" {
  description = "Instance type for EC2 and EKS nodes."
  type        = string
  default     = "t2.micro"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair registered in AWS."
  type        = string
  default     = "shredder-key"  # Modify as needed
}

variable "public_key_path" {
  description = "Path to the public SSH key file."
  type        = string
  default     = "/home/birdfever/my_projects/Keys/shredder-key.pub"  # Modify as needed
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance."
  type        = string
  default     = "ami-003932de22c285676"
}

# Load Balancer Variables
variable "alb_name" {
  description = "Name of the Application Load Balancer."
  type        = string
  default     = "shredder-alb"
}

variable "alb_internal" {
  description = "Whether the Load Balancer is internal or public."
  type        = bool
  default     = false
}

variable "alb_type" {
  description = "Type of Load Balancer."
  type        = string
  default     = "application"
}

variable "target_group_name" {
  description = "Name of the target group for backend services."
  type        = string
  default     = "shredder-backend-tg"
}

variable "target_group_port" {
  description = "Port for the backend target group."
  type        = number
  default     = 8000
}

variable "target_group_protocol" {
  description = "Protocol for the backend target group."
  type        = string
  default     = "HTTP"
}

variable "target_group_type" {
  description = "Target type for the backend target group."
  type        = string
  default     = "ip"
}

variable "listener_port" {
  description = "Port for the Load Balancer listener."
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for the Load Balancer listener."
  type        = string
  default     = "HTTP"
}

# Route53 Variables
variable "domain_name" {
  description = "The domain name for the Route53 hosted zone."
  type        = string
  default     = "example.com"  # Replace with your actual domain name
}

variable "route53_record_name" {
  description = "The name of the DNS record to create within the hosted zone."
  type        = string
  default     = "www"  # Replace with your desired subdomain or leave empty for root domain
}

# Lambda Variables
variable "lambda_function_name" {
  description = "Name of the Lambda function."
  type        = string
  default     = "rds_snapshot_lambda"
}

variable "lambda_handler" {
  description = "Handler for the Lambda function."
  type        = string
  default     = "index.handler"
}

variable "lambda_runtime" {
  description = "Runtime for the Lambda function."
  type        = string
  default     = "python3.8"
}

variable "lambda_code_bucket" {
  description = "S3 bucket containing the Lambda code."
  type        = string
  default     = "shredder-lambda-code-bucket"
}

variable "lambda_code_key" {
  description = "Path to the Lambda code zip file in S3."
  type        = string
  default     = "my-functions/lambda_function.py.zip"
}

# DynamoDB Variables
variable "dynamodb_name" {
  description = "Name of the DynamoDB table for Terraform state locking."
  type        = string
  default     = "tf_state_lock"
}

# RDS Variables
variable "final_snapshot_identifier" {
  description = "Prefix for the final snapshot to be created when the RDS instance is deleted."
  type        = string
  default     = "shredder-final-snapshot"
}

# S3 Bucket Variables
variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state storage."
  type        = string
  default     = "shredder-tf-state"
}

variable "s3_force_destroy" {
  description = "Flag to allow S3 bucket destruction without requiring empty."
  type        = bool
  default     = true
}

# Security Group Variables
variable "sg_name" {
  description = "Security group name."
  type        = string
  default     = "shredder-node-sg1"
}

variable "allowed_ips" {
  description = "List of allowed IP addresses for accessing resources."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_cidr_blocks" {
  description = "CIDR blocks allowed for outbound traffic."
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
