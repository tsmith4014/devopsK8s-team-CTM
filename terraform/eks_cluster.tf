
### eks_cluster.tf

### eks_cluster.tf

# Define the EKS Cluster
resource "aws_eks_cluster" "shredder_eks" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.shredder_eks_role.arn  # Ensure this IAM role is created

  # VPC Configuration for the EKS Cluster
  vpc_config {
    subnet_ids         = [aws_subnet.shredder_subnet_public_1.id, aws_subnet.shredder_subnet_private_1.id, aws_subnet.shredder_subnet_public_2.id, aws_subnet.shredder_subnet_private_2.id]  # Ensure subnets are declared
    security_group_ids = [aws_security_group.shredder_eks_sg.id]  # Ensure security group is declared
  }

  # Enable logging for debugging and auditing
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Optional: Add timeouts to ensure the process doesn't get stuck
  timeouts {
    create = "30m"
    delete = "30m"
  }
}

# Define the EKS Node Group
resource "aws_eks_node_group" "shredder_node_group" {
  cluster_name    = aws_eks_cluster.shredder_eks.name  # References the EKS cluster
  node_group_name = "${var.eks_cluster_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn  # Ensure this IAM role is declared

  # Specify that the node group depends on the EKS cluster being fully created
  depends_on = [aws_eks_cluster.shredder_eks]

  # Subnets where the worker nodes will be launched
  subnet_ids = [
    aws_subnet.shredder_subnet_public_1.id, 
    aws_subnet.shredder_subnet_private_1.id, 
    aws_subnet.shredder_subnet_public_2.id, 
    aws_subnet.shredder_subnet_private_2.id
  ]

  # Scaling configuration for the EKS worker nodes
  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  # Optional: Specify instance types (ensure this is compatible with your workload)
  instance_types = ["t2.small"]

  # Optional: Add timeouts to prevent creation delays
  timeouts {
    create = "30m"
    delete = "30m"
  }

  # Tags for resource management
  tags = {
    Name                                 = "${var.eks_cluster_name}-node"
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}
