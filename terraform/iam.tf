### iam.tf

# IAM Role for EKS Cluster
resource "aws_iam_role" "shredder_eks_role" {
  name = var.eks_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Policies to EKS Cluster Role
resource "aws_iam_role_policy_attachment" "eks_policy_attachment" {
  for_each   = toset(var.eks_role_policy_arns)
  role       = aws_iam_role.shredder_eks_role.name
  policy_arn = each.value
}

# IAM Role for EKS Worker Nodes
resource "aws_iam_role" "eks_node_role" {
  name = var.eks_node_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach Managed Policies to EKS Worker Node Role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

# Attach AmazonSSMManagedInstanceCore for worker nodes to communicate with AWS Systems Manager
resource "aws_iam_role_policy_attachment" "ssm_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks_node_role.name
}

### Custom Policies for EKS Cluster Autoscaling and EBS Management

# Attach the Cluster Autoscaler Policy to EKS Worker Node Role (Only attach if not already existing)
resource "aws_iam_policy" "cluster_autoscaler_policy" {
  name        = "ClusterAutoscalerPolicy"
  description = "Policy for EKS Cluster Autoscaler"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:UpdateAutoScalingGroup",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeInstances",
          "ec2:DescribeTags"
        ],
        Resource = "*"
      }
    ]
  })

  lifecycle {
    create_before_destroy = true
    prevent_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler_attachment" {
  policy_arn = aws_iam_policy.cluster_autoscaler_policy.arn
  role       = aws_iam_role.eks_node_role.name

  lifecycle {
    ignore_changes = [policy_arn]  # Prevent re-attachment if already attached
  }
}

# Create Custom Policy for EKS EBS Management (Skip creation if it exists)
resource "aws_iam_policy" "cluster_ebs_policy" {
  name        = "ClusterEBSPolicy"
  description = "Policy for EBS management in the cluster"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateVolume",
          "ec2:AttachVolume",
          "ec2:DeleteVolume",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumeStatus",
          "ec2:ModifyVolume",
          "ec2:CreateTags"
        ],
        Resource = "*"
      }
    ]
  })

  lifecycle {
    create_before_destroy = true
    prevent_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "cluster_ebs_attachment" {
  policy_arn = aws_iam_policy.cluster_ebs_policy.arn
  role       = aws_iam_role.eks_node_role.name

  lifecycle {
    ignore_changes = [policy_arn]  # Prevent re-attachment if already attached
  }
}
