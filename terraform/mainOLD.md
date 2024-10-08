### main

# VPC Configuration
resource "aws_vpc" "shredder_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "shredder-vpc"
  }
}

resource "aws_subnet" "shredder_subnet_public" {
  vpc_id                  = aws_vpc.shredder_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true
}

resource "aws_subnet" "shredder_subnet_private" {
  vpc_id            = aws_vpc.shredder_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone_2
}

resource "aws_internet_gateway" "shredder_igw" {
  vpc_id = aws_vpc.shredder_vpc.id
}

resource "aws_route_table" "shredder_public_rt" {
  vpc_id = aws_vpc.shredder_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.shredder_igw.id
  }
}

resource "aws_route_table_association" "shredder_public_rt_assoc" {
  subnet_id      = aws_subnet.shredder_subnet_public.id
  route_table_id = aws_route_table.shredder_public_rt.id
}

# Security Groups Configuration
resource "aws_security_group" "shredder_eks_sg" {
  vpc_id = aws_vpc.shredder_vpc.id

  ingress {
    description      = "Allow all traffic for Kubernetes nodes"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.allowed_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# RDS Configuration
resource "aws_db_instance" "postgresql" {
  allocated_storage      = var.rds_allocated_storage
  instance_class         = var.rds_instance_class
  engine                 = "postgres"
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  vpc_security_group_ids = [aws_security_group.shredder_eks_sg.id]
  skip_final_snapshot    = true
}

# EKS Cluster Configuration
resource "aws_eks_cluster" "shredder_eks" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.shredder_eks_role.arn

  vpc_config {
    subnet_ids         = [aws_subnet.shredder_subnet_public.id, aws_subnet.shredder_subnet_private.id]
    security_group_ids = [aws_security_group.shredder_eks_sg.id]
  }

  # Enable cluster logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}

# Load Balancer Configuration
resource "aws_lb" "shredder_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.shredder_eks_sg.id]
  subnets            = [aws_subnet.shredder_subnet_public.id]
}

resource "aws_lb_target_group" "backend_target_group" {
  name     = var.target_group_name
  port     = var.target_group_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.shredder_vpc.id
  target_type = "ip"
}

resource "aws_lb_listener" "shredder_listener" {
  load_balancer_arn = aws_lb.shredder_alb.arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend_target_group.arn
  }
}

# Route53 Configuration
resource "aws_route53_zone" "shredder_zone" {
  name = var.domain_name
}

resource "aws_route53_record" "shredder_record" {
  zone_id = aws_route53_zone.shredder_zone.zone_id
  name    = var.route53_record_name
  type    = "A"
  alias {
    name                   = aws_lb.shredder_alb.dns_name
    zone_id                = aws_lb.shredder_alb.zone_id
    evaluate_target_health = true
  }
}

# Lambda Function Configuration
resource "aws_lambda_function" "rds_snapshot" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = var.lambda_handler
  runtime       = var.lambda_runtime
  s3_bucket     = var.lambda_code_bucket
  s3_key        = var.lambda_code_key

  environment {
    variables = {
      DB_INSTANCE_IDENTIFIER = aws_db_instance.postgresql.id
    }
  }
}


# module "vpc" {
#   source = "./modules/vpc"

#   vpc_cidr_block        = var.vpc_cidr_block
#   public_subnet_cidr    = var.public_subnet_cidr
#   private_subnet_cidr   = var.private_subnet_cidr
#   availability_zone_1   = var.availability_zone_1
#   availability_zone_2   = var.availability_zone_2
# }

# module "security_groups" {
#   source    = "./modules/security_groups"
#   vpc_id    = module.vpc.vpc_id
#   allowed_ips = var.allowed_ips
# }

# module "rds" {
#   source = "./modules/rds"
  
#   rds_allocated_storage   = var.rds_allocated_storage
#   rds_instance_class      = var.rds_instance_class
#   db_username             = var.db_username
#   db_password             = var.db_password
#   db_name                 = var.db_name
#   vpc_security_group_ids  = [module.security_groups.rds_sg_id]
# }

# module "eks" {
#   source = "./modules/eks"

#   eks_role_name           = var.eks_role_name
#   desired_size            = var.desired_size
#   max_size                = var.max_size
#   min_size                = var.min_size
#   vpc_id                  = module.vpc.vpc_id
#   public_subnet_ids       = module.vpc.public_subnet_ids
# }

# module "load_balancer" {
#   source = "./modules/load_balancer"

#   alb_name             = var.alb_name
#   target_group_name    = var.target_group_name
#   target_group_port    = var.target_group_port
#   listener_port        = var.listener_port
#   security_groups      = [module.security_groups.eks_sg_id]
#   subnets              = module.vpc.public_subnet_ids
# }

# module "route53" {
#   source = "./modules/route53"

#   domain_name          = var.domain_name
#   route53_record_name  = var.route53_record_name
#   load_balancer_dns_name = module.load_balancer.alb_dns_name
# }

# module "lambda" {
#   source = "./modules/lambda"

#   lambda_function_name = var.lambda_function_name
#   lambda_handler       = var.lambda_handler
#   lambda_runtime       = var.lambda_runtime
#   lambda_code_bucket   = var.lambda_code_bucket
#   lambda_code_key      = var.lambda_code_key
#   db_instance_identifier = module.rds.db_instance_id
# }
