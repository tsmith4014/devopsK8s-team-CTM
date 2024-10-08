### outputs.tf

# outputs.tf
output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.shredder_vpc.id
}


output "s3-bucket-name" {
  description = "The S3 Bucket Name"
  value = aws_s3_bucket.tf_s3_state.bucket
}

output "s3-arn" {
  description = "The s3 State ARN "
  value = aws_s3_bucket.tf_s3_state.arn
}


output "eks_node_group_name" {
  description = "The EKS Node Group"
  value = aws_eks_node_group.shredder_node_group.node_group_name
}

output "eks_cluster_endpoint" {
  description = "The EKS Cluster Endpoint"
  value = aws_eks_cluster.shredder_eks.endpoint
}

output "load_balancer_dns_name" {
  description = "The Load Balancer DNS Name"
  value = aws_lb.shredder_alb.dns_name
}

# output "rds_endpoint" {
#   description = "The RDS Endpoint"
#   value = aws_db_instance.postgresql.endpoint

# }

# outputs.tf

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.shredder_alb.dns_name
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.shredder_alb.arn
}

# Add any other outputs you need



